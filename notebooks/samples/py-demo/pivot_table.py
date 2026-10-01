# ---
# jupyter:
#   jupytext:
#     formats: ipynb,py:percent
#     text_representation:
#       extension: .py
#       format_name: percent
#       format_version: '1.3'
#       jupytext_version: 1.19.5
#   kernelspec:
#     display_name: Python 3 (ipykernel)
#     language: python
#     name: python3
# ---

# %% colab={"base_uri": "https://localhost:8080/"} id="Jf2pVM_H_-qi" outputId="3f793626-3142-4b8f-93cc-1c4c4e9a516d"
# pip install pandas

# %% id="-ojM03ZlABIh"
import pandas as pd

# %% id="pvb1PyinADcW"
data = {
    "Name": ["Alice", "Bob", "Charlie", "Alice", "Bob", "Charlie"],
    "Age": [25, 30, 35, 28, 31, 36],
    "City": ["New York", "Los Angeles", "Chicago", "New York", "Los Angeles", "Chicago"],
    "Sales": [200, 150, 100, 300, 250, 200],
}
df = pd.DataFrame(data)

# %% colab={"base_uri": "https://localhost:8080/"} id="12VdPbW5AF_a" outputId="3d6b9944-fb3d-4c75-c9af-b3b65cf30b27"
print(df.head())

# %% colab={"base_uri": "https://localhost:8080/"} id="pYxHoeWpBMq1" outputId="3de9625e-a8f3-41f9-e4db-ff098ca00155"
print(df.info())

# %% colab={"base_uri": "https://localhost:8080/", "height": 206} id="2AThqfPAA3Qt" outputId="2d3be099-a5a5-481a-86c1-7af5d0098b1c"
pd.pivot_table(
    df,
    values="Sales",
    index="City",
    columns="Name",
    aggfunc="mean",
    fill_value=0,
    margins=True,
    dropna=True,
    margins_name="Total",
    observed=False,
)

# %% colab={"base_uri": "https://localhost:8080/"} id="0uh4vV47BvRk" outputId="e2f017d9-4a66-4526-dc06-e110bf5c5e2c"
import pandas as pd

# Sample data
data = {
    "Date": ["2023-01-01", "2023-01-01", "2023-01-01", "2023-01-01", "2023-01-02", "2023-01-02"],
    "City": ["New York", "New York", "New York", "Los Angeles", "New York", "Los Angeles"],
    "Sales": [200, 100, 300, 150, 300, 250],
}

df = pd.DataFrame(data)

# Creating a pivot table
pivot = pd.pivot_table(df, values="Sales", index="Date", columns="City", aggfunc="sum")
print(pivot)

# %% colab={"base_uri": "https://localhost:8080/"} id="_TOJsApYCtu-" outputId="96cb372c-09a4-48c8-abab-73dc2a0e5a6f"
data = {
    "Date": ["2023-01-01", "2023-01-01", "2023-01-01", "2023-01-01", "2023-01-02", "2023-01-02"],
    "City": ["New York", "New York", "New York", "Los Angeles", "New York", "Los Angeles"],
    "Product": ["A", "A", "B", "B", "A", "B"],
    "Sales": [200, 100, 300, 150, 300, 250],
}

df = pd.DataFrame(data)

# Multi-index pivot table
pivot = pd.pivot_table(df, values="Sales", index=["Date", "City"], columns="Product", aggfunc="sum")
print(pivot)

# %% colab={"base_uri": "https://localhost:8080/"} id="dc-muMcAEl6z" outputId="a50a461a-8881-424b-e6fa-7457f4cd724e"
# Using multiple aggregation functions
pivot = pd.pivot_table(df, values="Sales", index="Date", columns="City", aggfunc=["sum", len])
print(pivot)

# %% colab={"base_uri": "https://localhost:8080/"} id="vwfVoFMSErzz" outputId="590d1a0d-bc17-43bc-941d-97d471f303be"
# Filling missing values with 0
pivot = pd.pivot_table(
    df, values="Sales", index="Date", columns="City", aggfunc="sum", fill_value=0
)
print(pivot)

# %% colab={"base_uri": "https://localhost:8080/", "height": 143} id="phpALGZAFPTB" outputId="c0824beb-8c80-4dc5-f998-a9337da00028"
# Styling the pivot table
pivot.style.format("${:.2f}").background_gradient(cmap="viridis")

# %% colab={"base_uri": "https://localhost:8080/"} id="P764xDWrFWo8" outputId="461c2f7b-00cf-419c-ca83-02e3dbee6443"
# Renaming index and columns
pivot.rename(columns={"New York": "NY", "Los Angeles": "LA"}, inplace=True)
pivot.rename_axis("City", axis="columns", inplace=True)
pivot.rename_axis("Sales Date", axis="index", inplace=True)
print(pivot)

# %% colab={"base_uri": "https://localhost:8080/"} id="nMhjGOv9FdE3" outputId="935c4495-d97b-4eb7-9288-b90af309beb9"
# Adding margins
pivot = pd.pivot_table(
    df, values="Sales", index="Date", columns="City", aggfunc="sum", margins=True
)
print(pivot)

# %% id="ICeTn4SiFjHk"
# Optimizing memory usage
df["Sales"] = df["Sales"].astype("int32")

# %% colab={"base_uri": "https://localhost:8080/", "height": 210} id="hc-SPreEFpRG" outputId="d3e59fdc-a1df-4bf3-83ba-2caf10efacb6"
df["Sales"]

# %% colab={"base_uri": "https://localhost:8080/", "height": 1542} id="cMXC16yXFsvk" outputId="74752e8a-fc10-4b86-f790-2c365184af9c"
df

# %% cellView="form" colab={"base_uri": "https://localhost:8080/", "height": 639} id="uVH4Xk5wGQBN" outputId="3e309c61-cd39-4502-d3ed-a7e0d5cbd585"
# from google.colab import sheets
# sheet = sheets.InteractiveSheet(df=df)
