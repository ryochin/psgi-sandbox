About
=====

my (slightly old) psgi sandbox (test codes).


How To Setup Environment
------------------------

install Carton library first.

```sh
cpanm Carton
```

then you can install all dependencies to ./local/ with:

```sh
carton
```

Hot to run each psgi scripts
----------------------------

use `carton` command as below.

```sh
carton exec plackup ./simple.psgi
```

then access with browser to:

[http://localhost:5000/](http://localhost:5000/)

