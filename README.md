# Scientific Knowledge System (UI Prototype)

This project is a Streamlit-based prototype for your CIS 360 assignment.  
It converts extracted paper data (CSV/XLSX) into a searchable interface focused on:

- Datasets
- Fusion Methods
- Uncertainty Types (U1, U2, U3)

## 1) Expected Spreadsheet Columns

Your file should include these columns:

- `Paper Title`
- `Dataset Name`
- `Method Name`
- `Uncertainty Type` (U1/U2/U3)
- `Description`

The app also tries to auto-map common variants (for example: `Method` -> `Method Name`).

## 2) Setup

```bash
pip install -r requirements.txt
streamlit run app.py
```

## 3) What the UI Includes

- Upload + schema validation
- Data table view
- Core filters (dataset, uncertainty type, description keyword)
- Assignment-required query pages:
  - **Linkage Query**: methods applied to both Dataset A and Dataset B
  - **Uncertainty Query**: papers with U2 for a chosen sensor keyword
  - **Discovery Query**: most popular dataset by number of distinct methods

## 4) Suggested Submission Artifacts

For your GitHub repo submission, include:

- `app.py`
- `requirements.txt`
- your cleaned spreadsheet CSV
- screenshots of each required query output

