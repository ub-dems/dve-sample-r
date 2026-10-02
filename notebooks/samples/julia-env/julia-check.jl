# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:percent
#     text_representation:
#       extension: .jl
#       format_name: percent
#       format_version: '1.3'
#       jupytext_version: 1.19.5
#   kernelspec:
#     display_name: Julia 1.13
#     language: julia
#     name: julia-1.13
# ---

# %%
VERSION

# %%
versioninfo()

# %%
using Pkg

# %%
Pkg.add("PyCall")

# %%
Pkg.build("PyCall")

# %%
using PyCall
math = pyimport("math")
math.sin(math.pi / 4) # returns ≈ 1/√2 = 0.70710678...


# %%
using PyPlot; pygui(true)

# %%

# %%
using PyPlot
# use x = linspace(0,2*pi,1000) in Julia 0.6
x = range(0; stop=2*pi, length=1000); y = sin.(3 * x + 4 * cos.(2 * x));
plot(x, y, color="red", linewidth=2.0, linestyle="--")
title("A sinusoidally modulated sinusoid")


# %% [markdown]
# ### PyCall Tutorial
#
# * [How To Use PyCall.jl: Python Libraries In Julia](https://towardsdatascience.com/how-to-use-pycall-jl-python-libraries-in-julia-7f0e7a47ba70)

# %%
