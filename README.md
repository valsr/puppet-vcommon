# vcommon

#### Table of Contents

1. [Description](#description)
2. [Build Status](#build-status)
3. [Setup - The basics of getting started with vcommon](#setup)
   - [What vcommon affects](#what-vcommon-affects)
   - [Setup requirements](#setup-requirements)
   - [Beginning with vcommon](#beginning-with-vcommon)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

Common functions/codes used throughout the entire v\* module infrastructures. Functions/code here is of the small kind (i.e. solves a very specific few lines of code type of functions) that constantly pop up during development (i.e. overwriting for the printf function).

Note functions are entirely self-contained and don't depend on any non-forge modules.

## Build Status

| Branch      | [Travis-CI](https://travis-ci.org/valsr/puppet-vcommon/branches)                     |
| ----------- | ------------------------------------------------------------------------------------ |
| stable      | ![latest stable status](https://travis-ci.org/valsr/puppet-vcommon.svg?branch=0.1.1) |
| master      | ![master build status](https://travis-ci.org/valsr/puppet-vcommon.svg?branch=master) |
| development | N/A                                                                                  |

## Setup

### What vcommon affects **OPTIONAL**

Generic code/functions used during development/catalogue application.

### Setup Requirements **OPTIONAL**

Install depended modules as mentioned in the dependencies.

### Beginning with vcommon

No setup. Each function/manifest file holds the description on how to use it. You can find more information in the [Usage](#usage) section.

## Usage

### v_ensure_packages

Ensures packages are installed according to specified policy (policy::software::install). This methods run in the same manner as ensure*packages (in fact it copies most of it) with the exception that it also performs a hiera lookup for the policy and adds as the ensure value. Note that this is overridden if you specify a \_ensure* value.

The general call for this function is as follow: v*ensure_packages(\_Packages*[, *Options*]), where

- _Packages_ can be a string (package name), array of strings (packages names), or a hash with package name being the key and options being the a hash object
- _Options_ (optional) a hash parameter specifying options to use for package installation

The simplest way to install a package are as follow:

```puppet
  v_ensure_packages('nginx') # will install nginx packages
  v_ensure_packages(['vim', 'gvim']) # will install vim and gvim packages
  v_ensure_packages({'vim', 'gvim'}) # will install vim and gvim packages

  # will uninstall ruby as a package and install ruby_gem using gem provider
  v_ensure_packages({
    'ruby' => {
      ensure => 'absent'
    },
    'gvim' => {
      provider => 'gem'
    }
  })
```

You can also specify a hash to apply to all packages to override settings. Note that in the case of using hashes, then the options will be treated as defaults and will be overriden by whatever is specified in the package hash.

```puppet
  v_ensure_packages(['vim', 'gvim'], { provider => 'rpm' }) # will install vim and gvim packages using rpm as provider

  # will install ruby version 2.4 using rpm as provider and install ruby_gem using gem provider
  v_ensure_packages({
    'ruby' => {
      ensure => '2.4'
    },
    'gvim' => {
      provider => 'gem'
    }
  }, {provider => 'rpm' })
```

## Limitations

Currently only works/tested on:

- Debian 8
- Ubuntu 18.04
- LinuxMint 19

## Development

In most cases follow puppet standards/guidelines. In short:

- Make sure code is style according puppet [coding styles](https://puppet.com/docs/puppet/5.5/style_guide.html)
- Each new addition should have a unit test covering most of its functionality (aim for 85% or more)
- Make sure everything is properly documented (what it does, how it does it, parameters) and has plenty of examples

If so, submit a pull request and if it builds and runs well it will be merged (eventually).
