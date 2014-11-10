What is it?
===========

A puppet module for configuring various disk parameters on Linux systems.

Supported tunings:

* Scheduler


Usage:
------

Configure some defaults:

```puppet
class { 'disk':
  persist_file  => "/etc/rc.local"
}
```

Configure xvde1 with the deadline scheduler:
```puppet
disk::scheduler { 'xvde1': scheduler => 'deadline' }
```

Configure xvde1 with a readahead:
```puppet
disk::readahead { 'xvde1': readahead => 2048 }
```

Known Issues:
-------------

Its only been tested on CentOS but with appropriate tunings to the 
disk class parameters it should work on most Linux distributions.


To Do:
------

[ ]Add additional tunings
[ ]Add monitoring


License:
--------

Released under the Apache 2.0 licence


Contribute:
-----------
* Fork it
* Create a topic branch
* Improve/fix (with spec tests)
* Push new topic branch
* Submit a PR
