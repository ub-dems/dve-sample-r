---
title: Managed Dependency Management
subtitle: dependency management with "renv"
caption: deps - managed
author: --
date: 2021-10-29
---
|                                                                    |   |                                           |                                  |                                      |
|--------------------------------------------------------------------|---|-------------------------------------------|----------------------------------|--------------------------------------|
| [Next: Unmanaged Dependency Management](../deps-no-renv/README.md) |   | [Up: Dependency Management](../README.md) | [[Contents]](../../../README.md) | [[Index]](../../../_index/README.md) |

_**WARNING:**_ *this module isn't released yet ...*


Managed Dependency Management
=============================


Overview
--------

Dependency resolution and versioning is managed by `renv`. See:

* [Introduction to renv](https://rstudio.github.io/renv/articles/renv.html)


Configuration
-------------

In [`renv/settings.dcf`](../../../../renv/settings.dcf), define some custom setting (see [settings.dcf](https://rstudio.github.io/renv/reference/settings.html) reference):

- **external.libraries**: 

```
external.libraries: /usr/local/lib/R/site-library, /usr/local/lib/R/library,
    /usr/lib/R/site-library

```

where `/usr/local/lib/R/site-library` is the rocker images package installation path.
Important to include image packages in `renv` dependency discovery.


- **snapshot.type**:

```
snapshot.type: explicit
package.dependency.fields: Imports, Depends, LinkingTo

```

Disable implicit source scanning for dependency discovery, 
but limits dependency specification to [DESCRIPTION](../../../../../../../../DESCRIPTION) contents.

```
Imports:
    logging,
    yaml,
    ...
    
Suggests: 
    assertthat,
    cli (>= 3.3.0),
    knitr,
    ...

```
 

Usage
-----


From ["Introduction to renv"](https://rstudio.github.io/renv/articles/renv.html),
library management requires two steps:

1. `renv` context initialization.
1. dependency resolution and locking, with [renv.lock](../../../../../../../../renv.lock) generation.
1. package installation from [renv.lock](../../../../../../../../renv.lock) specification.


### Step 1: `renv` initialization

```R

rinv::init()

```

### Step 2: `renv.lock` generation

```R

rinv::snapshot()

```

### Step 3: package installation from `renv.lock` specification

```R

rinv::restore()

```
