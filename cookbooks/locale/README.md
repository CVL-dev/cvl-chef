Description
===========

Sets the default system locale.   

You can see which locales are available by running.
$ locale -a 

On debian based systems, the locale is set by running `update-locale`
to update the file `/etc/default/locale`.

On rhel based systems, the `/etc/sysconfig/i18n` file is updated directly.

Notes:

* The default system locale will only fully take effect after a reboot.
* The recipe check that a binary locale is known before configuring it.
* This recipe currently has no provision for compiling binary locales.

Requirements
============

Tested on Ubuntu, CentOS

Attributes
==========

* `node[:locale][:lang]` -- defaults to the current locale setting, or to 
  "en_US.utf8" if there is none.

Other locale variables will be set if you supply them.  Just use the variable 
name as the Chef attribute name.

If 'language' and 'lc_all' are not specified, they are set to the value of the
'lang' locale variable.

Usage
=====

Include the default recipe in your run list.

