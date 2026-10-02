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
# # py-sympy-hello: python symbolic math demo
#
# ## sympy
#
# - [SymPy documentation](https://docs.sympy.org/latest/index.html)
# - [SymPy Features](https://docs.sympy.org/latest/tutorials/intro-tutorial/features.html)
# - [SymPy Plotting Backends](https://sympy-plot-backends.readthedocs.io/en/latest/index.html)
#

# %%
# ruff: disable[B018]
# pyright: reportUnusedExpression=false

# %%
from sympy import init_printing, symbols, Integral, integrate, diff, oo, exp, sin
from spb import plot

init_printing()



# %%
x, y, z, t = symbols("x y z t")

# %%
f = exp(-(x**2) - y**2)
F = f , (x, -oo, oo), (y, -oo, oo)

# %%
Integral(*F)

# %%
integrate(*F)

# %%
g = sin(x) / x

# %%
dg = diff(g)

# %%
g

# %%
dg

# %%
plot(g, dg)

# %%
# ruff: enable[B018]
