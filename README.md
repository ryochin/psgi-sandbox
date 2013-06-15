About
=====

my (slightly old) psgi sandbox (test codes).


How To Setup Environment
------------------------

install Carton library first.

	cpanm Carton

then you can install all dependencies to ./local/ with:

	carton

Hot to run each psgi scripts
----------------------------

use `carton` command as below.

	carton exec plackup ./simple.psgi

then access with browser to:

[http://localhost:5000/](http://localhost:5000/)

