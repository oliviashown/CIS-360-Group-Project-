
import json
import os
import re
import sqlite3
from typing import List

import pandas as pd
import requests
import streamlit as st
import streamlit.components.v1 as components
from dotenv import load_dotenv


load_dotenv()


def _init_sqlite_db(sql_text: str) -> sqlite3.Connection:
    conn = sqlite3.connect(":memory:", check_same_thread=False)
    conn.row_factory = sqlite3.Row
    conn.executescript(sql_text)
    return conn


def _sql_select_only(sql: str) -> bool:
    s = sql.strip().lower()
    if not s:
        return False
    return s.startswith("select") or s.startswith("with")


def _run_sql(conn: sqlite3.Connection, sql: str) -> pd.DataFrame:
    return pd.read_sql_query(sql, conn)


def _list_tables(conn: sqlite3.Connection) -> List[str]:
    df = _run_sql(
        conn,
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name;",
    )
    return df["name"].tolist() if not df.empty else []


def _get_db_schema_summary(conn: sqlite3.Connection) -> str:
    parts: list[str] = []
    tables = _list_tables(conn)
    parts.append("SQLite schema (tables and columns):")
    for tname in tables:
        safe_tname = tname.replace("'", "''")
        cols = _run_sql(conn, f"PRAGMA table_info('{safe_tname}');")
        if cols.empty:
            continue
        col_list = ", ".join(
            [f"{row['name']} ({row['type']})" for _, row in cols.iterrows()]
        )
        parts.append(f"- {tname}: {col_list}")
    return "\n".join(parts)


def _ensure_limit(sql: str, limit: int = 200) -> str:
    s = sql.strip().rstrip(";").strip()
    if re.search(r"\blimit\b", s, flags=re.IGNORECASE):
        return s
    return f"{s} LIMIT {int(limit)}"


def _extract_first_json_object(text: str) -> dict | None:
    t = (text or "").strip()
    if not t:
        return None
    try:
        return json.loads(t)
    except Exception:
        pass

    m = re.search(r"\{[\s\S]*\}", t)
    if not m:
        return None
    try:
        return json.loads(m.group(0))
    except Exception:
        return None


def _openai_nl_to_sql(prompt: str, schema_summary: str, model: str) -> tuple[str | None, str | None]:
    api_key = os.environ.get("OPENAI_API_KEY") or os.environ.get("OPENAI_KEY")
    if not api_key:
        return None, "Missing OPENAI_API_KEY environment variable."

    url = "https://api.openai.com/v1/chat/completions"
    headers = {"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"}
    system = (
        "You are a careful data assistant that writes SQLite SELECT queries.\n"
        "Rules:\n"
        "- Output MUST be valid JSON, and ONLY JSON.\n"
        '- JSON shape: {"sql": "...", "explanation": "..."}\n'
        "- SQL must be SQLite-compatible.\n"
        "- SQL must be READ-ONLY: SELECT (or WITH ... SELECT). Never write INSERT/UPDATE/DELETE/CREATE/DROP.\n"
        "- Prefer joining tables using foreign keys when needed.\n"
        "- If the question is ambiguous, make a reasonable assumption.\n"
        "- Uncertainty Types: U1 is Conceptual (FUSION_METHOD), U2 is Measurement (DATA), U3 is Algorithmic (FUSION_METHOD).\n"
        "- Linkage: Join DOI, DATA, and FUSION_METHOD using doi_address, d_doi, and m_doi.\n"
        "- Keep results concise: include LIMIT 50 unless the user asks otherwise.\n"
    )
    user = f"{schema_summary}\n\nUser question: {prompt}"

    payload = {
        "model": model,
        "temperature": 0.1,
        "messages": [
            {"role": "system", "content": system},
            {"role": "user", "content": user},
        ],
    }

    try:
        resp = requests.post(url, headers=headers, json=payload, timeout=45)
    except Exception as e:
        return None, f"OpenAI request failed: {e}"

    if resp.status_code >= 400:
        return None, f"OpenAI error {resp.status_code}: {resp.text[:400]}"

    data = resp.json()
    content = (
        data.get("choices", [{}])[0]
        .get("message", {})
        .get("content", "")
    )
    obj = _extract_first_json_object(content)
    if not obj or "sql" not in obj:
        return None, "OpenAI returned an unexpected response (could not parse JSON)."
    return str(obj.get("sql") or "").strip(), str(obj.get("explanation") or "").strip()


def _ollama_nl_to_sql(prompt: str, schema_summary: str, model: str) -> tuple[str | None, str | None]:
    url = "http://localhost:11434/api/generate"
    system = (
        "You write SQLite SELECT queries.\n"
        'Return ONLY valid JSON: {"sql": "...", "explanation": "..."}\n'
        "Constraints: read-only SELECT/WITH SELECT; SQLite compatible; use LIMIT 50 unless asked otherwise."
        "Note: U1/U3 are in FUSION_METHOD, U2 is in DATA. Join on DOI.doi_address."
    )
    full_prompt = f"{system}\n\n{schema_summary}\n\nUser question: {prompt}\n\nJSON:"
    payload = {"model": model, "prompt": full_prompt, "stream": False}
    try:
        resp = requests.post(url, json=payload, timeout=60)
    except Exception as e:
        return None, f"Ollama request failed: {e}"

    if resp.status_code >= 400:
        return None, f"Ollama error {resp.status_code}: {resp.text[:400]}"

    data = resp.json()
    content = str(data.get("response") or "").strip()
    obj = _extract_first_json_object(content)
    if not obj or "sql" not in obj:
        return None, "Ollama returned an unexpected response (could not parse JSON)."
    return str(obj.get("sql") or "").strip(), str(obj.get("explanation") or "").strip()


def _gemini_nl_to_sql(prompt: str, schema_summary: str, model: str) -> tuple[str | None, str | None]:
    api_key = os.environ.get("GEMINI_API_KEY") or os.environ.get("GOOGLE_API_KEY")
    if not api_key:
        return None, "Missing GEMINI_API_KEY (or GOOGLE_API_KEY) environment variable."

    system = (
        "You are a careful data assistant that writes SQLite SELECT queries.\n"
        "Rules:\n"
        "- Output MUST be valid JSON, and ONLY JSON.\n"
        '- JSON shape: {"sql": "...", "explanation": "..."}\n'
        "- SQL must be SQLite-compatible.\n"
        "- SQL must be READ-ONLY: SELECT (or WITH ... SELECT). Never write INSERT/UPDATE/DELETE/CREATE/DROP.\n"
        "- Prefer joining tables using foreign keys when needed.\n"
        "- If the question is ambiguous, make a reasonable assumption.\n"
        "- Schema Help: DOI (papers), DATA (datasets/U2), FUSION_METHOD (methods/U1/U3).\n"
        "- Link via DOI.doi_address = DATA.d_doi = FUSION_METHOD.m_doi.\n"
        "- Keep results concise: include LIMIT 50 unless the user asks otherwise.\n"
    )
    text = f"{system}\n\n{schema_summary}\n\nUser question: {prompt}"
    url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={api_key}"
    payload = {"contents": [{"parts": [{"text": text}]}]}
    try:
        resp = requests.post(url, json=payload, timeout=45)
    except Exception as e:
        return None, f"Gemini request failed: {e}"
    if resp.status_code >= 400:
        return None, f"Gemini error {resp.status_code}: {resp.text[:400]}"
    data = resp.json()
    candidates = data.get("candidates", [])
    content = ""
    if candidates:
        parts = candidates[0].get("content", {}).get("parts", [])
        if parts:
            content = str(parts[0].get("text") or "")
    obj = _extract_first_json_object(content)
    if not obj or "sql" not in obj:
        return None, "Gemini returned an unexpected response (could not parse JSON)."
    return str(obj.get("sql") or "").strip(), str(obj.get("explanation") or "").strip()


def _openai_summarize_answer(
    question: str, sql: str, df: pd.DataFrame, model: str
) -> tuple[str | None, str | None]:
    api_key = os.environ.get("OPENAI_API_KEY") or os.environ.get("OPENAI_KEY")
    if not api_key:
        return None, "Missing OPENAI_API_KEY environment variable."

    sample_records = df.head(30).to_dict(orient="records")
    payload = {
        "model": model,
        "temperature": 0.2,
        "messages": [
            {
                "role": "system",
                "content": (
                    "You are a data analyst assistant. Write concise, readable answers in plain English.\n"
                    "Use only the provided query results; do not invent facts.\n"
                    "Prefer 4-8 bullet points and include concrete names/titles when possible."
                ),
            },
            {
                "role": "user",
                "content": (
                    f"User question: {question}\n"
                    f"SQL used: {sql}\n"
                    f"Rows returned: {len(df)}\n"
                    f"Columns: {', '.join(df.columns.tolist())}\n"
                    f"Sample rows (up to 30): {json.dumps(sample_records, ensure_ascii=True)}\n\n"
                    "Now provide a readable answer."
                ),
            },
        ],
    }

    try:
        resp = requests.post(
            "https://api.openai.com/v1/chat/completions",
            headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"},
            json=payload,
            timeout=45,
        )
    except Exception as e:
        return None, f"OpenAI summary request failed: {e}"

    if resp.status_code >= 400:
        return None, f"OpenAI summary error {resp.status_code}: {resp.text[:400]}"

    data = resp.json()
    content = data.get("choices", [{}])[0].get("message", {}).get("content", "")
    return str(content or "").strip(), None


def _ollama_summarize_answer(
    question: str, sql: str, df: pd.DataFrame, model: str
) -> tuple[str | None, str | None]:
    sample_records = df.head(30).to_dict(orient="records")
    prompt = (
        "You are a data analyst assistant. Write concise, readable answers in plain English.\n"
        "Use only the provided rows; do not invent facts.\n"
        "Prefer 4-8 bullet points with concrete paper titles/datasets when available.\n\n"
        f"User question: {question}\n"
        f"SQL used: {sql}\n"
        f"Rows returned: {len(df)}\n"
        f"Columns: {', '.join(df.columns.tolist())}\n"
        f"Sample rows (up to 30): {json.dumps(sample_records, ensure_ascii=True)}\n\n"
        "Answer:"
    )

    try:
        resp = requests.post(
            "http://localhost:11434/api/generate",
            json={"model": model, "prompt": prompt, "stream": False},
            timeout=60,
        )
    except Exception as e:
        return None, f"Ollama summary request failed: {e}"

    if resp.status_code >= 400:
        return None, f"Ollama summary error {resp.status_code}: {resp.text[:400]}"

    data = resp.json()
    content = str(data.get("response") or "").strip()
    return content, None


def _gemini_summarize_answer(
    question: str, sql: str, df: pd.DataFrame, model: str
) -> tuple[str | None, str | None]:
    api_key = os.environ.get("GEMINI_API_KEY") or os.environ.get("GOOGLE_API_KEY")
    if not api_key:
        return None, "Missing GEMINI_API_KEY (or GOOGLE_API_KEY) environment variable."

    sample_records = df.head(30).to_dict(orient="records")
    prompt = (
        "You are a data analyst assistant. Write concise, readable answers in plain English.\n"
        "Use only the provided query results; do not invent facts.\n"
        "Prefer 4-8 bullet points and include concrete names/titles when possible.\n\n"
        f"User question: {question}\n"
        f"SQL used: {sql}\n"
        f"Rows returned: {len(df)}\n"
        f"Columns: {', '.join(df.columns.tolist())}\n"
        f"Sample rows (up to 30): {json.dumps(sample_records, ensure_ascii=True)}\n\n"
        "Now provide a readable answer."
    )
    url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={api_key}"
    payload = {"contents": [{"parts": [{"text": prompt}]}]}
    try:
        resp = requests.post(url, json=payload, timeout=45)
    except Exception as e:
        return None, f"Gemini summary request failed: {e}"
    if resp.status_code >= 400:
        return None, f"Gemini summary error {resp.status_code}: {resp.text[:400]}"
    data = resp.json()
    candidates = data.get("candidates", [])
    content = ""
    if candidates:
        parts = candidates[0].get("content", {}).get("parts", [])
        if parts:
            content = str(parts[0].get("text") or "")
    if not content:
        return None, "Gemini summary returned empty content."
    return content.strip(), None


def _fallback_summary(question: str, df: pd.DataFrame) -> str:
    lines = [f"Here’s what I found for: **{question}**", ""]
    cols = set(df.columns.tolist())

    # Determine which uncertainty types were requested
    question_lower = question.lower()
    requested_uncertainties = []
    if "u1" in question_lower or "conceptual uncertainty" in question_lower:
        requested_uncertainties.append("u1")
    if "u2" in question_lower or "measurement uncertainty" in question_lower:
        requested_uncertainties.append("u2")
    if "u3" in question_lower or "algorithmic uncertainty" in question_lower:
        requested_uncertainties.append("u3")
    
    # Check for "all uncertainty types" or similar phrases
    if ("all" in question_lower and "uncertainty" in question_lower) or ("any" in question_lower and "uncertainty" in question_lower):
        requested_uncertainties = ["u1", "u2", "u3"]

    if {"doi_title", "pub_date", "publisher", "field"}.issubset(cols):
        for _, row in df.head(5).iterrows():
            title = str(row.get("doi_title", "Untitled")).strip()
            year = str(row.get("pub_date", "N/A")).strip()
            publisher = str(row.get("publisher", "N/A")).strip()
            field = str(row.get("field", "N/A")).strip()
            lines.append(f"- **{title}** ({year})")
            lines.append(f"  - Publisher: {publisher}")
            lines.append(f"  - Field: {field}")
            if "abstract" in cols and str(row.get("abstract", "")).strip():
                abstract = str(row.get("abstract"))
                lines.append(f"  - *Abstract*: {abstract[:500]}..." if len(abstract) > 500 else f"  - *Abstract*: {abstract}")
            if "authors" in cols and str(row.get("authors", "")).strip():
                lines.append(f"  - Authors: {str(row.get('authors')).strip()}")
            if "m_name" in cols and str(row.get("m_name", "")).strip():
                lines.append(f"  - Method: {row['m_name']}")
                if "m_desc" in cols and str(row.get("m_desc", "")).strip():
                    lines.append(f"    - *Desc*: {row['m_desc']}")
            if "d_name" in cols and str(row.get("d_name", "")).strip():
                lines.append(f"  - Dataset: {row['d_name']}")
            # Show only the requested uncertainty types
            if requested_uncertainties:
                for uncertainty in requested_uncertainties:
                    if uncertainty == "u1" and "u1" in cols and row.get("u1"):
                        lines.append(f"  - **U1 (Conceptual)**: {row['u1']}")
                    elif uncertainty == "u2" and "u2" in cols and row.get("u2"):
                        lines.append(f"  - **U2 (Measurement)**: {row['u2']}")
                    elif uncertainty == "u3" and "u3" in cols and row.get("u3"):
                        lines.append(f"  - **U3 (Algorithmic)**: {row['u3']}")
            else:
                # If no specific uncertainty was requested, show all that exist
                if "u1" in cols and row.get("u1"):
                    lines.append(f"  - **U1 (Conceptual)**: {row['u1']}")
                if "u2" in cols and row.get("u2"):
                    lines.append(f"  - **U2 (Measurement)**: {row['u2']}")
                if "u3" in cols and row.get("u3"):
                    lines.append(f"  - **U3 (Algorithmic)**: {row['u3']}")
        return "\n".join(lines)

    if "d_name" in cols:
        lines.append("Matching Datasets:")
        for _, row in df.head(10).iterrows():
            lines.append(f"- **{row['d_name']}**")
            if "collection_method" in cols and row["collection_method"]:
                lines.append(f"  - Collection: {row['collection_method']}")
            # Show only the requested uncertainty types
            if requested_uncertainties:
                for uncertainty in requested_uncertainties:
                    if uncertainty == "u2" and "u2" in cols and row.get("u2"):
                        lines.append(f"  - **U2 (Measurement)**: {row['u2']}")
                    elif uncertainty == "u1" and "u1" in cols and row.get("u1"):
                        lines.append(f"  - **U1 (Conceptual)**: {row['u1']}")
                    elif uncertainty == "u3" and "u3" in cols and row.get("u3"):
                        lines.append(f"  - **U3 (Algorithmic)**: {row['u3']}")
            else:
                # If no specific uncertainty was requested, show all that exist
                if "u2" in cols and row["u2"]:
                    lines.append(f"  - **U2 (Measurement)**: {row['u2']}")
                if "u1" in cols and row.get("u1"):
                    lines.append(f"  - **U1 (Conceptual)**: {row['u1']}")
                if "u3" in cols and row.get("u3"):
                    lines.append(f"  - **U3 (Algorithmic)**: {row['u3']}")
            if "d_type" in cols and row["d_type"]:
                lines.append(f"  - Type: {row['d_type']}")
        return "\n".join(lines)

    if "publisher" in cols and "paper_count" in cols:
        lines.append("Most common publishers:")
        for _, row in df.head(10).iterrows():
            lines.append(f"- {row['publisher']}: {row['paper_count']} papers")
        return "\n".join(lines)

    lines.append("Top matching results:")
    for _, row in df.head(5).iterrows():
        pairs = [f"**{k}**: {row[k]}" for k in df.columns if row[k] is not None]
        lines.append(f"- {' | '.join(pairs)}")
    return "\n".join(lines)


def _nl_to_sql(user_text: str) -> str | None:
    t = user_text.strip()
    if not t:
        return None

    low = t.lower()
    safe_text = t.replace("'", "''")

    # exact/manual prompts first
    if "list" in low and "table" in low:
        return "SELECT name AS table_name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name;"

    # STAKEHOLDER QUERY: Discovery (Most popular dataset by distinct methods)
    if "most popular dataset" in low or "dataset with most methods" in low:
        return """
        SELECT d.d_name AS dataset_name, COUNT(DISTINCT d.method_key) AS unique_methods_count, 
               GROUP_CONCAT(DISTINCT fm.m_name) AS method_list
        FROM DATA d
        LEFT JOIN FUSION_METHOD fm ON fm.m_key = d.method_key
        WHERE d.d_name IS NOT NULL AND d.method_key IS NOT NULL
        GROUP BY d.d_name
        ORDER BY unique_methods_count DESC, d.d_name
        LIMIT 1;
        """

    if ("top" in low and "paper" in low) or ("best" in low and "paper" in low) or ("recent" in low and "paper" in low):
        return (
            "SELECT d.doi_address, d.doi_title, d.pub_date, d.publisher, d.field, "
            "COUNT(DISTINCT da.author) AS author_count, "
            "COALESCE(GROUP_CONCAT(DISTINCT da.author), '') AS authors, "
            "COALESCE(GROUP_CONCAT(DISTINCT fm.m_name), '') AS methods, "
            "COALESCE(GROUP_CONCAT(DISTINCT dt.d_name), '') AS datasets "
            "FROM DOI d "
            "LEFT JOIN DOI_AUTHOR da ON da.a_doi = d.doi_address "
            "LEFT JOIN FUSION_METHOD fm ON fm.m_doi = d.doi_address "
            "LEFT JOIN DATA dt ON dt.d_doi = d.doi_address "
            "GROUP BY d.doi_address, d.doi_title, d.pub_date, d.publisher, d.field "
            "ORDER BY d.pub_date DESC, author_count DESC, d.doi_title "
            "LIMIT 5;"
        )

    if "summary" in low and "paper" in low:
        return (
            "SELECT d.doi_address, d.doi_title, d.pub_date, d.publisher, d.field, "
            "COALESCE(GROUP_CONCAT(DISTINCT da.author), '') AS authors, "
            "COALESCE(GROUP_CONCAT(DISTINCT fm.m_name), '') AS methods, "
            "COALESCE(GROUP_CONCAT(DISTINCT dt.d_name), '') AS datasets "
            "FROM DOI d "
            "LEFT JOIN DOI_AUTHOR da ON da.a_doi = d.doi_address "
            "LEFT JOIN FUSION_METHOD fm ON fm.m_doi = d.doi_address "
            "LEFT JOIN DATA dt ON dt.d_doi = d.doi_address "
            "GROUP BY d.doi_address, d.doi_title, d.pub_date, d.publisher, d.field "
            "ORDER BY d.pub_date DESC, d.doi_title "
            "LIMIT 10;"
        )

    if "publisher" in low and ("most" in low or "common" in low or "often" in low):
        return (
            "SELECT publisher, COUNT(*) AS paper_count "
            "FROM DOI "
            "GROUP BY publisher "
            "ORDER BY paper_count DESC, publisher "
            "LIMIT 10;"
        )

    if "recent" in low and "field" in low:
        return (
            "SELECT field, pub_date, COUNT(*) AS paper_count "
            "FROM DOI "
            "GROUP BY field, pub_date "
            "ORDER BY pub_date DESC, paper_count DESC, field "
            "LIMIT 20;"
        )

    if ("show" in low or "list" in low) and "dataset" in low and "method" not in low and "methods" not in low and "fused with" not in low and "used with" not in low:
        return (
            "SELECT d_name AS dataset_name, d_type, spatial_coverage, temporal_coverage, format, license "
            "FROM DATA WHERE d_name IS NOT NULL ORDER BY d_name;"
        )

    if "authors for" in low or "authors of" in low:
        m = re.search(r"authors?\s+(?:for|of)\s+(10\.\S+)", t, flags=re.IGNORECASE)
        if m:
            doi = m.group(2).strip().replace("'", "''")
            return (
                "SELECT a.author "
                "FROM DOI_AUTHOR a "
                f"WHERE a.a_doi = '{doi}' "
                "ORDER BY a.author;"
            )

    # simpler keyword-based fallback for demo questions
    stopwords = {
        "show", "me", "all", "list", "which", "what", "are", "is", "the", "for", "with",
        "used", "use", "that", "report", "reports", "reporting", "commonly", "data",
        "dataset", "datasets", "paper", "papers", "fusion", "method", "methods", "tell",
        "uncertainty", "u2", "of", "in", "on", "to", "database", "info",
        "everything", "find", "search", "about"
    }

    raw_words = re.findall(r"[a-zA-Z0-9\-]+", low)
    keywords = []
    for word in raw_words:
        if word not in stopwords and len(word) > 2:
            keywords.append(word)

    # intent detection
    intent = None
    if "method" in low:
        intent = "methods"
    elif "paper" in low:
        intent = "papers"
    elif "dataset" in low or "most popular" in low:
        intent = "datasets"

    if not intent:
        if "author" in low:
            intent = "authors"
        elif "publisher" in low:
            intent = "publishers"

    # If no specific intent is found but keywords exist, default to a broad search
    if not intent and keywords:
        intent = "general"
    elif not keywords and not intent:
        return None

    def make_like_conditions(aliases: list[str]) -> str:
        parts = []
        for k in keywords:
            safe_k = k.replace("'", "''")
            if "d" in aliases:
                parts.append(f"d.d_name LIKE '%{safe_k}%'")
                parts.append(f"d.collection_method LIKE '%{safe_k}%'")
            if "doi" in aliases:
                parts.append(f"doi.doi_title LIKE '%{safe_k}%'")
                parts.append(f"doi.abstract LIKE '%{safe_k}%'")
                parts.append(f"doi.field LIKE '%{safe_k}%'")
            if "fm" in aliases:
                parts.append(f"fm.m_name LIKE '%{safe_k}%'")
                parts.append(f"fm.m_desc LIKE '%{safe_k}%'")
        return " OR ".join(parts) if parts else "1=1"

    like_conds = make_like_conditions(["doi", "d", "fm"])

    # special case: papers asking about specific uncertainty types
    uncertainty_filters = []
    if "u1" in low or "conceptual uncertainty" in low:
        uncertainty_filters.append("u1")
    if "u2" in low or "measurement uncertainty" in low:
        uncertainty_filters.append("u2")
    if "u3" in low or "algorithmic uncertainty" in low:
        uncertainty_filters.append("u3")
    
    # Check for "all uncertainty types" or similar phrases
    if ("all" in low and "uncertainty" in low) or ("any" in low and "uncertainty" in low):
        uncertainty_filters = ["u1", "u2", "u3"]

    # special case: methods used for a dataset/topic
    if intent == "methods":
        query = f"SELECT DISTINCT doi.doi_title, fm.m_name, fm.m_desc, fm.u1, fm.u3, d.d_name FROM FUSION_METHOD fm JOIN DOI doi ON fm.m_doi = doi.doi_address LEFT JOIN DATA d ON d.method_key = fm.m_key WHERE {like_conds}"
        if uncertainty_filters:
            conditions = []
            if "u1" in uncertainty_filters:
                conditions.append("fm.u1 IS NOT NULL")
            if "u3" in uncertainty_filters:
                conditions.append("fm.u3 IS NOT NULL")
            if conditions:
                query += f" AND ({' OR '.join(conditions)})"
        query += " ORDER BY doi.pub_date DESC"
        return query

    # special case: papers asking about uncertainty
    if intent == "papers" and uncertainty_filters:
        query = f"SELECT DISTINCT doi.doi_title, doi.pub_date, d.d_name, fm.u1, d.u2, fm.u3 FROM DATA d JOIN DOI doi ON d.d_doi = doi.doi_address LEFT JOIN FUSION_METHOD fm ON d.method_key = fm.m_key WHERE ({like_conds})"
        conditions = []
        if "u1" in uncertainty_filters:
            conditions.append("fm.u1 IS NOT NULL")
        if "u2" in uncertainty_filters:
            conditions.append("d.u2 IS NOT NULL")
        if "u3" in uncertainty_filters:
            conditions.append("fm.u3 IS NOT NULL")
        if conditions:
            query += f" AND ({' OR '.join(conditions)})"
        query += " ORDER BY doi.pub_date DESC"
        return query

    if intent == "papers":
        return f"SELECT DISTINCT doi.doi_title, doi.pub_date, doi.publisher, doi.field, doi.abstract FROM DOI doi WHERE {make_like_conditions(['doi'])} ORDER BY doi.pub_date DESC"

    # special case: datasets commonly fused with X
    if intent == "datasets" and ("fused with" in low or "used with" in low):
        target_conditions = []
        for k in keywords:
            safe_k = k.replace("'", "''")
            target_conditions.append(f"d1.d_name LIKE '%{safe_k}%'")
            target_conditions.append(f"d1.collection_method LIKE '%{safe_k}%'")
            target_conditions.append(f"doi.doi_title LIKE '%{safe_k}%'")
        target_where = " OR ".join(target_conditions) if target_conditions else "1=0"

        return f"""
        SELECT DISTINCT d2.d_name AS fused_dataset, 
               doi.doi_title AS source_paper,
               fm.m_name AS fusion_method
        FROM DATA d1
        JOIN DATA d2 ON d1.d_doi = d2.d_doi
        JOIN DOI doi ON d1.d_doi = doi.doi_address
        LEFT JOIN FUSION_METHOD fm ON fm.m_doi = doi.doi_address
        WHERE ({target_where}) 
          AND d1.d_name != d2.d_name
        ORDER BY d2.d_name
        """

    if intent == "datasets":
        return f"SELECT DISTINCT d.d_name, d.d_type, d.collection_method, fm.u1, d.u2, fm.u3, d.spatial_coverage FROM DATA d JOIN DOI doi ON d.d_doi = doi.doi_address LEFT JOIN FUSION_METHOD fm ON d.method_key = fm.m_key WHERE d.d_name IS NOT NULL AND ({like_conds}) ORDER BY d.d_name"

    if intent == "authors":
        return f"""
        SELECT DISTINCT da.author, doi.doi_title, doi.pub_date
        FROM DOI_AUTHOR da
        JOIN DOI doi ON doi.doi_address = da.a_doi
        LEFT JOIN DATA d ON d.d_doi = doi.doi_address
        LEFT JOIN FUSION_METHOD fm ON fm.m_doi = doi.doi_address
        WHERE {like_conds}
        ORDER BY da.author
        """

    if intent == "publishers":
        return """
        SELECT publisher, COUNT(*) AS paper_count
        FROM DOI
        GROUP BY publisher
        ORDER BY paper_count DESC, publisher
        LIMIT 10
        """

    if intent == "general":
        return f"SELECT DISTINCT doi.doi_title, doi.pub_date, doi.field, d.d_name, fm.m_name, fm.m_desc, fm.u1, d.u2, fm.u3 FROM DOI doi LEFT JOIN DATA d ON d.d_doi = doi.doi_address LEFT JOIN FUSION_METHOD fm ON d.method_key = fm.m_key WHERE {like_conds} ORDER BY doi.pub_date DESC LIMIT 20"

    return None


def _scroll_to_latest_result():
    components.html(
        """
        <script>
            window.scrollTo({
                top: document.body.scrollHeight,
                behavior: "smooth"
            });
        </script>
        """,
        height=0,
    )


def render_sql_chat() -> None:
    # Custom CSS for better visual appeal
    st.markdown("""
    <style>
    .main-header {
        text-align: center;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        font-size: 3em;
        font-weight: bold;
        margin-bottom: 10px;
    }
    .sub-header {
        text-align: center;
        color: #666;
        font-size: 1.2em;
        margin-bottom: 30px;
    }
    .chat-container {
        border-radius: 10px;
        padding: 10px;
        margin: 10px 0;
    }
    .suggested-questions {
        background: #f8f9fa;
        border-radius: 10px;
        padding: 20px;
        margin: 20px 0;
        border: 1px solid #e9ecef;
    }
    .suggested-questions h3 {
        color: #495057;
        text-align: center;
        margin-bottom: 15px;
    }
    .stButton button {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        border-radius: 5px;
        padding: 10px 20px;
        font-weight: bold;
        transition: all 0.3s ease;
    }
    .stButton button:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    }
    .stChatMessage {
        border-radius: 15px;
        margin: 10px 0;
        padding: 15px;
    }
    .stChatMessage[data-testid="stChatMessage-assistant"] {
        background: #f1f3f4;
        border-left: 4px solid #667eea;
    }
    .stChatMessage[data-testid="stChatMessage-user"] {
        background: #e3f2fd;
        border-left: 4px solid #764ba2;
    }
    </style>
    """, unsafe_allow_html=True)

    st.markdown('<h1 class="main-header">🔬 Scientific Knowledge System</h1>', unsafe_allow_html=True)
    st.markdown('<p class="sub-header">Your AI-powered assistant for exploring scientific papers, authors, datasets, and research methods</p>', unsafe_allow_html=True)

    # Hardcoded settings (sidebar removed)
    ai_enabled = True
    provider = "Gemini"
    model = "gemini-1.5-flash"
    default_limit = 10000  # High limit to effectively remove limits

    try:
        with open("sql_code/db.sql", "r", encoding="utf-8") as f:
            sql_text = f.read()
    except OSError:
        st.error("Could not find db.sql in this project folder.")
        st.info("Make sure your db.sql file is in the same folder as this Streamlit app.")
        return

    if "sql_conn" not in st.session_state or st.session_state.get("sql_source_hash") != hash(sql_text):
        st.session_state["sql_conn"] = _init_sqlite_db(sql_text)
        st.session_state["sql_source_hash"] = hash(sql_text)
        st.session_state["chat_messages"] = [
            {
                "role": "assistant",
                "content": (
                    "Hi! I’m your knowledge assistant. I can help you explore the papers, "
                    "authors, datasets, methods, and publishers stored in this database.\n\n"
                    "Try asking things like:\n"
                    "- What are the most recent papers?\n"
                    "- Which methods are used for a dataset?\n"
                    "- Who are the authors for a paper?\n"
                    "- Which publishers appear most often?"
                ),
            }
        ]

    conn: sqlite3.Connection = st.session_state["sql_conn"]
    schema_summary = _get_db_schema_summary(conn)

    for msg in st.session_state["chat_messages"]:
        with st.chat_message(msg["role"]):
            st.markdown(msg["content"])

    # Enhanced suggested questions section
    st.markdown("""
    <div class="suggested-questions">
    <h3>💡 Quick Start Questions</h3>
    <p style="text-align: center; color: #666; margin-bottom: 20px;">Click any button below to get started with common queries</p>
    </div>
    """, unsafe_allow_html=True)
    
    col1, col2, col3 = st.columns(3)
    with col1:
        st.markdown("📄 **Recent Research**")
        qp1 = st.button("Recent papers", use_container_width=True, key="recent_btn")
    with col2:
        st.markdown("🏢 **Publishing Trends**")
        qp2 = st.button("Common publishers", use_container_width=True, key="publishers_btn")
    with col3:
        st.markdown("🧪 **Research Methods**")
        qp3 = st.button("Methods by dataset", use_container_width=True, key="methods_btn")

    quick_prompt = None
    if qp1:
        quick_prompt = "What are the most recent papers?"
    elif qp2:
        quick_prompt = "Which publishers appear most often?"
    elif qp3:
        quick_prompt = "Show methods used for datasets in the database."

    user_prompt = st.chat_input("💬 Ask me anything about the scientific papers, authors, methods, or datasets...")
    if not user_prompt and not quick_prompt:
        return
    user_prompt = quick_prompt or user_prompt

    st.session_state["chat_messages"].append({"role": "user", "content": user_prompt})
    with st.chat_message("user"):
        st.markdown(user_prompt)

    with st.chat_message("assistant"):
        raw = user_prompt.strip()
        sql = None

        if raw.lower().startswith("sql:"):
            sql = raw[4:].strip()
            if not _sql_select_only(sql):
                response = "Only read-only SELECT queries are allowed."
                st.markdown(response)
                st.session_state["chat_messages"].append({"role": "assistant", "content": response})
                _scroll_to_latest_result()
                return
        else:
            explanation = ""
            if ai_enabled:
                with st.spinner("Thinking..."):
                    if provider == "OpenAI":
                        sql, explanation = _openai_nl_to_sql(raw, schema_summary, model)
                    elif provider == "Gemini":
                        sql, explanation = _gemini_nl_to_sql(raw, schema_summary, model)
                    else:
                        sql, explanation = _ollama_nl_to_sql(raw, schema_summary, model)

                if not sql:
                    sql = _nl_to_sql(raw)

                if sql and not _sql_select_only(sql):
                    sql = _nl_to_sql(raw)

                if sql:
                    sql = _ensure_limit(sql, int(default_limit))
            else:
                sql = _nl_to_sql(raw)

        if not sql:
            response = (
                "I couldn’t understand that question yet. Try asking about recent papers, "
                "authors, datasets, methods, or publishers."
            )
            st.markdown(response)
            st.session_state["chat_messages"].append({"role": "assistant", "content": response})
            _scroll_to_latest_result()
            return

        try:
            df = _run_sql(conn, sql)
        except Exception as e:
            response = f"I ran into a problem searching the paper database: {e}"
            st.markdown(response)
            st.session_state["chat_messages"].append({"role": "assistant", "content": response})
            _scroll_to_latest_result()
            return

        if df.empty:
            response = "I couldn’t find any matching papers or records for that question."
            st.markdown(response)
            st.session_state["chat_messages"].append({"role": "assistant", "content": response})
            _scroll_to_latest_result()
            return

        if len(df) > int(default_limit):
            df = df.head(int(default_limit))

        summary_text: str | None = None
        summary_err: str | None = None

        if ai_enabled:
            with st.spinner("Writing answer..."):
                if provider == "OpenAI":
                    summary_text, summary_err = _openai_summarize_answer(raw, sql, df, model)
                elif provider == "Gemini":
                    summary_text, summary_err = _gemini_summarize_answer(raw, sql, df, model)
                else:
                    summary_text, summary_err = _ollama_summarize_answer(raw, sql, df, model)

        if not summary_text:
            summary_text = _fallback_summary(raw, df)

        st.markdown(summary_text)
        st.session_state["chat_messages"].append({"role": "assistant", "content": summary_text})
        _scroll_to_latest_result()

    # Add a subtle footer
    st.markdown("---")
    st.markdown(
        '<div style="text-align: center; color: #666; font-size: 0.8em;">'
        'Powered by Gemini AI • Built with Streamlit • 🔬 Explore Scientific Knowledge'
        '</div>',
        unsafe_allow_html=True
    )


def main() -> None:
    st.set_page_config(
        page_title="🔬 Scientific Knowledge System",
        page_icon="🔬",
        layout="centered",
        initial_sidebar_state="collapsed"
    )
    render_sql_chat()


if __name__ == "__main__":
    main()
