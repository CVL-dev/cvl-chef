Overview
========

This cookbook is for installing and doing the initial configuration of a
MediaFlux / DaRIS instance.  The prerequisites are the installation files 
for MediaFlux and DaRIS, and a current license key file for MediaFlux:

  - The MediaFlux installation JAR file and license key should be obtained
    from Architecta.
  - The DaRIS files can be downloaded from the DaRIS downloads area; refer
    to http://nsp.nectar.org.au/wiki-its-r/doku.php?id=data_management:daris:downloads for details.

Configuration
=============

MediaFlux is a Java application, and this cookbook uses the OpenJDK Java 7 JDK
to fulfill this dependency.  If you want to, you can set node attributes to
override the defaults; see the http://community.opscode.com/cookbooks/java for
the relevant attributes

 
