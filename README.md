What is it?
===========

A puppet module that configured disk parameters on Linux systems.  Currently
it only sets the scheduler


Usage:
------

Set the scheduler for xvde1 to deadline
<pre>
  disk::scheduler { 'xvde1': scheduler => 'deadline' }
</pre>


Known Issues:
-------------
Only tested on CentOS 6

TODO:
____
[ ] Add additional tunings
[ ] Add monitoring

License:
_______

Released under the Apache 2.0 licence


Contribute:
-----------
* Fork it
* Create a topic branch
* Improve/fix (with spec tests)
* Push new topic branch
* Submit a PR
