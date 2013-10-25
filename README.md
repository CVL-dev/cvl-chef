cvl-chef
========

This repository contains Chef cookbooks for some NeCTAR Characterization 
Virtual Laboratory (CVL) projects.  

Menu
====

* `site-cookbooks/mediaflux` - Installation and configuration of generic Mediaflux server 
* `site-cookbooks/daris` - Installation and configuration of a DaRIS instance
* `site-cookbooks/pvconv` - Download, build and install the pvconv Bruker converter.

Status
======

Any cookbooks with a "0.0.1" version number should be viewed as prerelease;
e.g. potentially incomplete and unstable.

Cookbooks are currently only being tested on CentOS 6.4.
  

Micro-introduction to Chef
==========================

Opscode Chef is system for automating the configuration of (typically) Linux / 
UNIX based machines and virtuals.  See http://www.opscode.com/chef/ for details.

The basic idea is that configuration tasks are performed using Recipes.  These
are (mostly) declarative scripts written in the Chef's Ruby-based "domain 
specific language".  Recipes are run on "nodes" (i.e. computers) which are
configured using Node and Role specifications.  These typically say what Recipes
to run, and provide various attributes that parameterize the Recipe behaviour.
Recipes and their associated files are bundled up as Cookbooks, and the whole
lot are (typically) checked into version control.

Chef can either be used in two ways:

* You can use a central server to hold all of the configuration specifications,
and manage the configuration state and authorization details.  This mode of
operation is best if you have a number of machines to manage, but it requires
you to either set up and maintain a Chef server, or use the "Enterprise Chef"
service managed by Opscode.  (The latter is free for up to 5 nodes.  After that
you pay by the month.)

* You can use Chef solo mode where you essentially manage each system 
individually, and take care of the distribution of configuration specs and
state yourself.  (Chef solo does not support shared Data Bags or dynamic Node 
attribute storage ... or any form of authorization.)

There is lots of material on the Opscode site about how to use Chef in its
various forms.  But here's a quick "cheat sheet" to get yourself started with
Chef Solo and the recipes in this repo:

1. Use yum or apt-get to install git

2. Install the latest version of chef-client:
```
	sudo bash -c "true && curl -L https://www.opscode.com/chef/install.sh | bash"
```
3. Create a directory for doing chef solo work.
```
   	sudo mkdir /var/chef-solo
	sudo chown <your-id> /var/chef-solo
```
4. Clone this repo ...
```
   	cd /var/chef-solo
	git clone <the url>
	cd cvl-chef
```
5. Make a node definition ...
```
   	cp solo/sample-node.json mynode.json
	# edit mynode.json to add override attributes, 
	#    change the runlist and so on
```
6. Run it using chef-solo
```
	sudo chef-solo -c solo/solo.rb -j mynode.json -ldebug
```
