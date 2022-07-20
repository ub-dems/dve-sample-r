---
title: "runner" actions
subtitle: development environment actions
author: --
date: 2021-10-29
---
|   |   |                                       |                                  |                                      |
|---|---|---------------------------------------|----------------------------------|--------------------------------------|
|   |   | [Up: Dependency Management](../README.md) | [[Contents]](../../../README.md) | [[Index]](../../../_index/README.md) |

_**WARNING:**_ *this mudule isn't released yet ...*



`renv` Managed Depencency Management
====================================

Configuration
-------------

In [`runner.sh`](../../../../renv/settings.dcf), define some custom setting (see [settings.dcf](https://rstudio.github.io/renv/reference/settings.html) reference):


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

Disable implicit source scannin for depndency discovery, 
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
