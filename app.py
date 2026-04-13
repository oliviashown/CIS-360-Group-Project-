import io
from typing import List

import pandas as pd
import streamlit as st


REQUIRED_COLUMNS = [
    "Paper Title",
    "Dataset Name",
    "Method Name",
    "Uncertainty Type",
    "Description",
]


def normalize_columns(df: pd.DataFrame) -> pd.DataFrame:
    """Normalize common column variants to required schema names."""
    rename_map = {}
    for col in df.columns:
        clean = col.strip().lower()
        if clean in {"paper", "paper title", "title"}:
            rename_map[col] = "Paper Title"
        elif clean in {"dataset", "dataset name", "data set"}:
            rename_map[col] = "Dataset Name"
        elif clean in {"method", "method name", "fusion method"}:
            rename_map[col] = "Method Name"
        elif clean in {"uncertainty", "uncertainty type", "u-type", "u level"}:
            rename_map[col] = "Uncertainty Type"
        elif clean in {"description", "notes", "details"}:
            rename_map[col] = "Description"

    out = df.rename(columns=rename_map).copy()
    return out


def validate_schema(df: pd.DataFrame) -> List[str]:
    missing = [col for col in REQUIRED_COLUMNS if col not in df.columns]
    return missing


def clean_values(df: pd.DataFrame) -> pd.DataFrame:
    out = df.copy()
    for col in REQUIRED_COLUMNS:
        out[col] = out[col].astype(str).str.strip()
    out["Uncertainty Type"] = out["Uncertainty Type"].str.upper()
    out = out[out["Dataset Name"] != ""]
    out = out[out["Method Name"] != ""]
    out = out[out["Paper Title"] != ""]
    return out


def to_csv_download(df: pd.DataFrame) -> bytes:
    buffer = io.StringIO()
    df.to_csv(buffer, index=False)
    return buffer.getvalue().encode("utf-8")


def main() -> None:
    st.set_page_config(page_title="Scientific Knowledge System", layout="wide")
    st.title("Scientific Knowledge System (UI Prototype)")
    st.caption("Upload your extracted paper spreadsheet and run required stakeholder queries.")

    uploaded = st.file_uploader("Upload CSV or Excel file", type=["csv", "xlsx"])
    if not uploaded:
        st.info("Upload your spreadsheet to begin.")
        return

    if uploaded.name.lower().endswith(".csv"):
        raw_df = pd.read_csv(uploaded)
    else:
        raw_df = pd.read_excel(uploaded)

    st.subheader("Step 1: Schema Check")
    df = normalize_columns(raw_df)
    missing = validate_schema(df)
    if missing:
        st.error(
            "Missing required columns: "
            + ", ".join(missing)
            + ". Please include all required fields."
        )
        st.write("Detected columns:", list(df.columns))
        return

    df = clean_values(df)
    st.success("Spreadsheet loaded and validated.")
    st.dataframe(df, use_container_width=True, hide_index=True)
    st.download_button(
        "Download cleaned CSV",
        data=to_csv_download(df),
        file_name="cleaned_knowledge_data.csv",
        mime="text/csv",
    )

    st.subheader("Step 2: Core Search")
    col1, col2, col3 = st.columns(3)
    with col1:
        dataset_filter = st.selectbox(
            "Dataset",
            options=["(All)"] + sorted(df["Dataset Name"].unique().tolist()),
        )
    with col2:
        uncertainty_filter = st.selectbox(
            "Uncertainty Type",
            options=["(All)", "U1", "U2", "U3"],
        )
    with col3:
        keyword = st.text_input("Keyword in Description", value="")

    filtered = df.copy()
    if dataset_filter != "(All)":
        filtered = filtered[filtered["Dataset Name"] == dataset_filter]
    if uncertainty_filter != "(All)":
        filtered = filtered[filtered["Uncertainty Type"] == uncertainty_filter]
    if keyword.strip():
        filtered = filtered[
            filtered["Description"].str.contains(keyword.strip(), case=False, na=False)
        ]

    st.write(f"Results: {len(filtered)} rows")
    st.dataframe(filtered, use_container_width=True, hide_index=True)

    st.subheader("Required Query 1: Linkage Query")
    st.caption(
        "Find all Fusion Methods applied to both Dataset A and Dataset B."
    )
    q1c1, q1c2 = st.columns(2)
    datasets = sorted(df["Dataset Name"].unique().tolist())
    with q1c1:
        dataset_a = st.selectbox("Dataset A", datasets, key="dataset_a")
    with q1c2:
        dataset_b = st.selectbox("Dataset B", datasets, key="dataset_b")

    methods_a = set(df.loc[df["Dataset Name"] == dataset_a, "Method Name"])
    methods_b = set(df.loc[df["Dataset Name"] == dataset_b, "Method Name"])
    common_methods = sorted(methods_a.intersection(methods_b))
    st.write("Common methods:", common_methods if common_methods else "None found")

    st.subheader("Required Query 2: Uncertainty Query")
    st.caption(
        "Find papers that report U2 (Measurement) uncertainty for a specific sensor type."
    )
    sensor_keyword = st.text_input(
        "Sensor type keyword (e.g., Satellite, Traffic Camera, Census)",
        value="Satellite",
    )
    u2_rows = df[
        (df["Uncertainty Type"] == "U2")
        & (
            df["Dataset Name"].str.contains(sensor_keyword, case=False, na=False)
            | df["Description"].str.contains(sensor_keyword, case=False, na=False)
        )
    ]
    st.write(f"Matching papers: {u2_rows['Paper Title'].nunique()}")
    st.dataframe(
        u2_rows[["Paper Title", "Dataset Name", "Method Name", "Uncertainty Type"]],
        use_container_width=True,
        hide_index=True,
    )

    st.subheader("Required Query 3: Discovery Query")
    st.caption(
        "Find the most popular dataset (most connections to different methods)."
    )
    popularity = (
        df.groupby("Dataset Name")["Method Name"]
        .nunique()
        .reset_index(name="Unique Methods")
        .sort_values("Unique Methods", ascending=False)
    )
    st.dataframe(popularity, use_container_width=True, hide_index=True)
    if not popularity.empty:
        top_dataset = popularity.iloc[0]["Dataset Name"]
        top_score = int(popularity.iloc[0]["Unique Methods"])
        st.success(f"Most popular dataset: {top_dataset} ({top_score} methods)")

    st.subheader("Assignment Query Examples")
    traffic_methods = (
        df[df["Dataset Name"].str.contains("Traffic", case=False, na=False)]["Method Name"]
        .dropna()
        .unique()
        .tolist()
    )
    st.write('Methods used for "Traffic Data":', sorted(traffic_methods))

    sat_u2 = df[
        (df["Uncertainty Type"] == "U2")
        & df["Dataset Name"].str.contains("Satellite", case=False, na=False)
    ]
    st.write("Papers reporting U2 for Satellite Imagery:", sat_u2["Paper Title"].nunique())

    census_rows = df[df["Dataset Name"].str.contains("Census", case=False, na=False)]
    fused_with_census = sorted(census_rows["Dataset Name"].unique().tolist())
    st.write("Datasets commonly fused with Census Data (from matching rows):", fused_with_census)


if __name__ == "__main__":
    main()
