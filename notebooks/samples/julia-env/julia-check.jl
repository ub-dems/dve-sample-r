# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:percent
#     text_representation:
#       extension: .jl
#       format_name: percent
#       format_version: '1.3'
#       jupytext_version: 1.19.6
#   kernelspec:
#     display_name: Julia 1.13
#     language: julia
#     name: julia-1.13
# ---

# %% [markdown]
# # Julia Environmnet Check
#
#
# ## Language Integrations
#
# - "R -> Julia": see CRAN Package ["JuliaCall"](https://cran.r-project.org/web/packages/JuliaCall/)
# - "Python -> Julia": see PYPI Package ["juliacall"](https://pypi.org/project/juliacall/)
# - "Julia -> Python"; see Julia Package: ["PythonCall"](https://juliapy.github.io/PythonCall.jl/stable/)
#
# ## Julia References
#
# - [Julia Documentation](https://docs.julialang.org/en/v1/)
# - [Tutorials](https://julialang.org/learning/tutorials/)
# - [Plots Gallery](https://docs.juliaplots.org/stable/gallery/gr/)
# - [SynPyCore.jj - Calculus](https://jverzani.github.io/SymPyCore.jl/stable/Tutorial/calculus/)
#
#

# %%
VERSION

# %%
versioninfo()

# %%
macro bash_str(s) open(`bash`,"w",stdout) do io; print(io, s); end; end


# %%
bash"""

 env | grep -e '^JULIA'

"""

# %%
using PythonCall
math = pyimport("math")
math.sin(math.pi / 4) # returns ≈ 1/√2 = 0.70710678...

# %%
using Pkg

# %%
Pkg.add("Plots")

# %%
Pkg.build("Plots")

# %%
using PythonCall
math = pyimport("math")
math.sin(math.pi / 4) # returns ≈ 1/√2 = 0.70710678...


# %%
using Plots

# %%
x = range(0, 10, length=100)
y1 = sin.(x)
y2 = cos.(x)
y3 = @. sin(x)^2 - 1/2

plot(x, [y1 y2], label=["sin(x)" "cos(x)"], lw=[2 1])
plot!(x, y3, label="sin(x)^2 - 1/2", lw=3, ls=:dot)
plot!(legend=:outerbottom, legendcolumns=3)
xlims!(0, 2pi)
title!("Trigonometric functions")
xlabel!("x")
ylabel!("y")

# %%
