# hue

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with hue](#setup)
    * [What hue affects](#what-hue-affects)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Module to install and configure Cloudera's Hue in your cluster. It has been
tested on CentOS7 with an Ambari Distribution.

## Module Description

If applicable, this section should have a brief description of the technology
the module integrates with and what that integration enables. This section
should answer the questions: "What does this module *do*?" and "Why would I use
it?"

If your module has a range of functionality (installation, configuration,
management, etc.) this is the time to mention it.

## Setup

### Pre-requisites

A Java Development Kit must be installed.

### What hue affects

The following packages will be installed by this module :
* wget
* ant
* gcc
* make
* maven
* asciidoc
* cyrus-sasl-devel
* cyrus-sasl-gssapi
* cyrus-sasl-plain
* gcc-c++
* rb5-devel
* libxml2-devel
* libxslt-devel
* mariadb-devel
* openldap-devel
* python-devel
* sqlite-devel
* openssl-devel
* gmp-devel


## Usage

To install hue simply include the hue class, it will install it and configure
it to be pointing at a localhost cluster.
```
class {'hue': }
```

### There are several parameters you can use to customize the installation:

* **$hue_log_dir:** By default hue stores it's logs in the installation folder which
is not the most desirable option, and this parameter puts the log folder in the
location specified.

* **$hue_user:** User that will be runinng hue services (hue by default).

* **$hue_group:** Group for the hue user (hue by default).

* **$hue_install_dir:** Root path where hue will be installed (/home/$hue_user by default).
 **Note:** Hue will be installed in a "hue" subdir under $hue_install_dir folder.

* **$config_values:** Here you can set the config for the different services, the
default one is provided as an example
```
  $config_values = {
    'hadoop' => {
      'fs_defaultfs'            => 'hdfs://node-1.cluster:8020',
      'webhdfs_url'             => "http://${::fqdn}:50070/webhdfs/v1",
      'resourcemanager_host'    => $::fqdn,
      'resourcemanager_api_url' => "http://${::fqdn}:8088",
      'proxy_api_url'           => "http://${::fqdn}:8088",
      'history_server_api_url'  => "http://${::fqdn}:19888",
    },
    'desktop'   => {
      'app_blacklist' => 'impala ',
      'secret_key'    => 'GFDSKgf90i54opjge809t5uy4jogi9n9v9vp4528mv90pu459vgfd$',
    },
    'liboozie'  => { 'oozie_url'        => "http://${::fqdn}:11000/oozie", },
    'beeswax'   => { 'hive_server_host' => $::fqdn, },
    'sqoop'     => { 'server_url'       => "http://${::fqdn}:12000/sqoop", },
    'hbase'     => { 'hbase_clusters'   => "(${::fqdn}|${::ipaddress}:9090)", },
    'zookeeper' => { 'host_ports'       => "${::fqdn}:2181", },
    'spark'     => { 'livy_server_host' => "http://${::fqdn}:8090", },
  }
```
**The following parameters are provided just in case you want to install another
hue version in order to be able to "adapt" to that version changes (tarball name
, config directories, etc...):**

* **$hue_config_file:** Full path to the hue.ini file
("${hue_install_dir}/hue/desktop/conf/hue.ini" by default)

* **$hue_bin_dir:** Full path to the hue's bin folder ("${hue_install_dir}/hue/build/env/bin" by default)

* **$hue_releases_archive_url:** Hue release tarball's url

* **$hue_release_package_file:** Tarball filename

* **$hue_release_package_folder:** Subfolder created by the tarball's uncompression.

* **common_packages:**

* **os_specific_packages:**

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

Right now it works with CentOS7, but integration with other OS's should be
fairly simple, just using the appropriate packages for each OS.

## Development

Feel free to add any extra functionality to the module.
# puppet-hue
