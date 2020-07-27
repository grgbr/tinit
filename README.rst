.. role:: sh(code)
   :language: sh

Tinit
#####

A busybox runit / glibc based init.
 
Supported platforms
===================

TODO

Build / install workflow
========================

Prerequisites
*************

You will need busybox with the following options enabled and built against
glibc:

* mandatory runit utilities :
  
  * runsv
  * runsvdir
  * sv
    
* optional init utilities :
  
  * halt
  * poweroff
  * reboot
  * setsid
    
* printf
* setsid
* /bin/sh
* sed, grep, awk with extended regular expression support
* ???

Getting help
************

TODO

Build
*****

TODO

Install
*******

TODO

Install directory hierarchy
***************************

TODO

TODO
****

At configure time, ensure that build prerequisites are installed into staging
area.
