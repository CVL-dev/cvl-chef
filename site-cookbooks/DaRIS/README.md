Overview
========

This cookbook is for installing and doing the initial configuration of a
MediaFlux / DaRIS instance.  The prerequisites are the installation files 
for MediaFlux and DaRIS, and a current license key file for MediaFlux:

  - The MediaFlux installation JAR file and license key should be obtained
    from Architecta.
  - The DaRIS files can be downloaded from the DaRIS downloads area; refer
    to http://nsp.nectar.org.au/wiki-its-r/doku.php?id=data_management:daris:downloads for details.

Prerequisites
=============

MediaFlux is a Java application, and this cookbook doesn't handle the
installation thereoff.  Instead you should either install a JDK or JRE by
hand, or by adding the relevant "java" recipe to the role or node 
specification together with attributes to select the version you require.
(Refer to the java cookbook README.md - http://community.opscode.com/cookbooks/java for details.)

At least Java 6 (1.6) is recommended in the DaRIS installation notes.

