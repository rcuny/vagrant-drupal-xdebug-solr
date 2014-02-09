# Vagrant dev box for Drupal: Apache2 + Solr + Xdebug

## Companion repository
This repository is part of a 2 repositories Vagrant project:

* *[A first repo](https://github.com/rcuny/vagrant-apache2-xdebug-solr), aim at provisionning your box once.*
* **[This repo](https://github.com/rcuny/vagrant-drupal-xdebug-solr), using the first one to build a Drupal customized box.**


## What is in this box
This repo contains Vagrant provisionning script to use with your new or existing Drupal projects. It is based on a box provisionned by [this Vagrant project](https://github.com/rcuny/vagrant-apache2-xdebug-solr), available here:

On the basis of the previous box, this repo adds:

* PHP settings configuration to match Drupal requirements (ex: MEMORY_LIMIT)
* [Drush](https://github.com/drush-ops/drush) installation 


## Before starting

### Dependencies / Prerequisites

* [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](http://downloads.vagrantup.com/)


### Note to Windows users

NFS will not work on Windows. Keep it disabled in Vagrantfile.


### Important note on security

This repo is for demonstration purposes only and contains some passwords. 
It's stronlgy recommended to not use the resources 'as is' for production or even development environments.

Also know that for developer convenience, some default PHP variable (ex: max memory) have been modified. These modifications may not be suitable for production. See provision.sh for details.







## Sources & Thanks

This project is a compilation of many already existing pieces. Thanks to all of the authors for their work.

### Original provisionning box
This provisionning script is based on the first part of the repository used at DrupalCamp Leuven. It was created by [Jurgen Verhasselt](http://wunderkraut.com/people/jurgen-verhasselt) from [Wunderkraut](http://wunderkraut.com).

Many thanks for this highly valueable work!

* [Getting Started With Vagrant](http://wunderkraut.com/blog/drupalcamp-leuven-getting-started-with-vagrant/2013-09-17)
* [Full project repo on Github](https://github.com/sjugge/DCL13_Vagrant)



## Additional resources

* [Vagrant docs](http://docs.vagrantup.com/)


## About the author
[Renaud CUNY](http://renaud-cuny.com) is a Drupal consutant & developer.