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

# %% [markdown]
# # NVIDIA system check

# %%
# !echo $PATH | tr ':' '\n'

# %%
# !nvidia-smi

# %%
# !nvidia-smi --version

# %%
# !nvidia-smi -L

# %%
# !lspci

# %%
# !lsmod | grep nv

# %%
# !apt list --installed | grep -i -e nvidia -e cuda -e blas -e cudnn

# %%
# !nvidia-smi -q

# %%
# !uv pip list

# %%
# ! uv tree --no-dedupe --no-group jupyter --show-sizes | grep -i -e nvidia -e torch -e keras -e tensorflow

# %%
# ! uv tree --no-dedupe --no-group jupyter --show-sizes

# %%
