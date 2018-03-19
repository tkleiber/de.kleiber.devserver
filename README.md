# My development server

This is the repository for all blogs related to my virtual development server which you can find here:
<https://develishdevelopment.wordpress.com/tag/virtual-development-server/>

## Goals:

*   virtual development server to decoupling development from my computer
*   testing some ideas and play with some new and old technologies
*   components should be easy replaceable and should influence my computer as little as possible

## Build the base vagrant box with packer

```
cd packer
packer build ubuntu.json
cd ..
vagrant box remove ubuntu-17.10.1-amd64-virtualbox.box
vagrant up
```

## Planned features:

*   Vagrant as for creating and provisioning the virtual server
*   Oracle Enterprise Linux as operating system in the server and, when possible, in the docker containers
*   Docker containers for decoupling of technologies and components
    *   Jenkins for orchestrating the build and delivering process
    *   Sonarcube for Code Analysis
    *   Oracle Database Enterprise Edition 12c Oracle Database XE 11g
    *   Oracle Weblogic Server 12c
    *   Oracle ADF Runtime 12c
    *   etc.
