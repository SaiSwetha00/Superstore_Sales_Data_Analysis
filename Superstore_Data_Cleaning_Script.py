# ============================================================
#  SUPERSTORE DATA CLEANING SCRIPT
#  Use this on the raw CSV downloaded from Kaggle
#  Tools: Python, pandas
# ============================================================

import pandas as pd

# ── Step 1: Load raw data ────────────────────────────────────
# Update the filename below to match your downloaded Kaggle file
df = pd.read_csv('Sample - Superstore.csv', encoding='latin1')

print("Original shape:", df.shape)
print("\nColumn names:\n", df.columns.tolist())
print("\nData types:\n", df.dtypes)
print("\nMissing values:\n", df.isnull().sum()[df.isnull().sum() > 0])

# ── Step 2: Remove duplicates ────────────────────────────────
before = len(df)
df = df.drop_duplicates()
print(f"\nRemoved {before - len(df)} duplicate rows")

# ── Step 3: Fix date columns ─────────────────────────────────
df['Order Date'] = pd.to_datetime(df['Order Date'], errors='coerce')
df['Ship Date'] = pd.to_datetime(df['Ship Date'], errors='coerce')

# ── Step 4: Handle missing values ────────────────────────────
# Drop rows with missing Sales or Profit (core fields)
df = df.dropna(subset=['Sales', 'Profit'])

# Fill missing categorical values with 'Unknown'
cat_cols = ['Region', 'Category', 'Sub-Category', 'Segment']
for col in cat_cols:
    if col in df.columns:
        df[col] = df[col].fillna('Unknown')

# ── Step 5: Standardize text columns ─────────────────────────
text_cols = ['Region', 'Category', 'Sub-Category', 'Segment', 'Ship Mode']
for col in text_cols:
    if col in df.columns:
        df[col] = df[col].str.strip().str.title()

# ── Step 6: Remove invalid rows ──────────────────────────────
df = df[df['Sales'] > 0]          # Remove zero/negative sales
df = df[df['Quantity'] > 0]       # Remove zero/negative quantity

# ── Step 7: Feature engineering ──────────────────────────────
df['Year'] = df['Order Date'].dt.year
df['Month'] = df['Order Date'].dt.month
df['Month Name'] = df['Order Date'].dt.strftime('%B')
df['Quarter'] = df['Order Date'].dt.quarter.map({1: 'Q1', 2: 'Q2', 3: 'Q3', 4: 'Q4'})
df['Days to Ship'] = (df['Ship Date'] - df['Order Date']).dt.days
df['Profit Margin %'] = (df['Profit'] / df['Sales'] * 100).round(2)
df['Revenue per Unit'] = (df['Sales'] / df['Quantity']).round(2)
df['Discount %'] = (df['Discount'] * 100).round(0).astype(int)
df['Profit Flag'] = df['Profit'].apply(lambda x: 'Profit' if x > 0 else 'Loss')
df['Margin Band'] = pd.cut(
    df['Profit Margin %'],
    bins=[-999, 0, 10, 25, 999],
    labels=['Loss', 'Low Margin', 'Medium Margin', 'High Margin']
)

# ── Step 8: Reset index and save ─────────────────────────────
df = df.reset_index(drop=True)

print("\nCleaned shape:", df.shape)
print("\nCleaned columns:\n", df.columns.tolist())
print("\nSample of cleaned data:")
print(df.head())

df.to_csv('Superstore_Cleaned_Dataset.csv', index=False)
print("\n✅ Cleaned dataset saved as 'Superstore_Cleaned_Dataset.csv'")

# ── Step 9: Quick sanity check ───────────────────────────────
print("\n── Quick Summary ──")
print(f"Total Sales   : ${df['Sales'].sum():,.2f}")
print(f"Total Profit  : ${df['Profit'].sum():,.2f}")
print(f"Date Range    : {df['Order Date'].min().date()} to {df['Order Date'].max().date()}")
print(f"Unique Orders : {df['Order ID'].nunique():,}")
