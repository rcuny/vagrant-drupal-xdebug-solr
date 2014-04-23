# Vagrant dev box for Drupal: Apache2 + Solr + Xdebug

## Companion repository
This repository is part of a 2 repositories Vagrant project:

* *[A first repo](https://github.com/rcuny/vagrant-apache2-xdebug-solr), aim at provisionning your box once.*
* **[This repo](https://github.com/rcuny/vagrant-drupal-xdebug-solr), using the first one to build a Drupal customized box.**

More info on this project is available on my blog: [Vagrant for Drupal dev with Solr and Xdebug](http://rcuny.li/1cs5VS7).

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



## How to use this Vagrant box

### Prepare the files
Simply grab this repository somewhere, we'll use it on the next steps.

``` bash
cd /tmp/
mkdir vagrant-drupal-xdebug-solr && cd vagrant-drupal-xdebug-solr
git clone git@github.com:rcuny/vagrant-drupal-xdebug-solr.git ./
```

### Use the box in your Drupal project
Let's create a new Drupal project, intgrate the Vagrant files and launch the box.

Considering /vhosts/ is your favourite locations for your Drupal sites on your local machine, execute the following:

``` bash
cd /vhosts/
curl -O  http://ftp.drupal.org/files/projects/drupal-7.26.tar.gz
tar xzf drupal-7.26.tar.gz
mv drupal-7.26 drupal-vagrant-test.local
cd drupal-vagrant-test.local
cp /tmp/vagrant-drupal-xdebug-solr/Vagrantfile ./
cp -fr /tmp/vagrant-drupal-xdebug-solr/scripts ./scripts
echo ".vagrant" >> .gitignore
vagrant up
```

Note that during the vagrant up command, you may be prompted for a password. This is your host OS asking for your local admin password, to mount network shares from the VM.

If everything went well during provisionning, you can now open these 3 URLs:

* http://192.168.66.6 - you should see a Drupal install screen
* http://192.168.66.6/phpmyadmin - to create your database and user. Defaults connection values: user: root / pass: root
* http://192.168.66.6:8080/solr - that is your Solr admin


### SSH and MySQL access to your box

#### SSH
If you need to login to your box, you can run:

``` bash
vagrant ssh
```

#### MySQL from local
No need to connect to the box for dumping or loading a database. From your local machine, simply run mysql with --host parameter. Ex:

``` bash
mysql test --user=root --password=root --host=192.168.66.6
```


### Using Solr with Drupal

The box comes with Solr 4.6.1, already installed and configured to work with Drupal.

For the Drupal side, I recommend using the following modules:

* [Search API](https://drupal.org/project/search_api)
* [Search API Solr](https://drupal.org/project/search_api_solr)

As your box comes with Drush, a quick way to install these module is to connect to your box and run drush:

``` bash
vagrant ssh
cd /var/www
drush en search_api -y
drush en search_api_solr -y
```

Note that the configuration files from search_api_solr have already been copied to the Solr conf directory during the provisionning of the virtual machine; no need to worry about it.

The only remaining steps are to configure a search server and an index in http://192.168.66.6/admin/config/search/search_api. This is pretty straight forward:

* [Add a server](http://192.168.66.6/admin/config/search/search_api/add_server) - your Solr server is on localhost:8080 (Tomcat).
* [Add an index](http://192.168.66.6/admin/config/search/search_api/add_index) - select "Node" as item type (if you want to index nodes), and select the server you've just created. Create the index, then on the "Select fields to index", click "Node ID" and "Title". Save, and on the click "Bundler filter", and leave them to default value. Save again.
* [Create a node](http://192.168.66.6/node/add/page) with dummy content.
* Come back to your [Search Index](http://192.168.66.6/admin/config/search/search_api/index/sol_index), you should see "0/1 indexed". Click "Queue all items for reindexing" then "Index now".
* Open your Collection 1 on your [Solr admin](http://192.168.66.6:8080/solr/#/collection1), if everything went fine you should see at least 1 document (be patient, it can take up to a few seconds). You can even run an [empty Solr query](http://192.168.66.6:8080/solr/#/collection1/query) to see what the index content is.


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
