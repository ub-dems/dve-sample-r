import sys

##
# @see: https://stackoverflow.com/questions/15411967/how-can-i-check-if-code-is-executed-in-the-ipython-notebook
#

# def in_notebook():
#     try:
#         from IPython import get_ipython
#         if "IPKernelApp" not in get_ipython().config:  # pragma: no cover
#             return False
#     except ImportError:
#         return False
#     except AttributeError:
#         return False
#     return True


def in_notebook():
    """
    Returns ``True`` if the module is running in IPython kernel,
    ``False`` if in IPython shell or other Python shell.
    """
    return "ipykernel" in sys.modules


# later I found out this:


def ipython_info():
    ip = False
    if "ipykernel" in sys.modules:
        ip = "notebook"
    elif "IPython" in sys.modules:
        ip = "terminal"
    return ip
