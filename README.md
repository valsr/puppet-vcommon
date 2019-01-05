# vcommon

#### Table of Contents

1. [Description](#description)
1. [Build Status](#build-status)
1. [Setup - The basics of getting started with vcommon](#setup)
   - [What vcommon affects](#what-vcommon-affects)
   - [Setup requirements](#setup-requirements)
   - [Beginning with vcommon](#beginning-with-vcommon)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)
1. [Release Notes](#release-notes)

## Description

Common functions/codes used throughout the entire v\* module infrastructures. Functions/code here is of the small kind
(i.e. solves a very specific few lines of code type of functions) that constantly pop up during development (i.e.
overwriting for the printf function).

Note functions are entirely self-contained and don't depend on any non-forge modules.

## Build Status

| Branch      | [Travis-CI](https://travis-ci.org/valsr/puppet-vcommon/branches)                      |
| ----------- | ------------------------------------------------------------------------------------- |
| stable      | ![latest stable status](https://travis-ci.org/valsr/puppet-vcommon.svg?branch=stable) |
| master      | ![master build status](https://travis-ci.org/valsr/puppet-vcommon.svg?branch=master)  |
| development | N/A                                                                                   |

## Setup

### What vcommon affects **OPTIONAL**

Generic code/functions used during development/catalogue application.

### Setup Requirements **OPTIONAL**

Install depended modules as mentioned in the dependencies.

### Beginning with vcommon

No setup. Each function/manifest file holds the description on how to use it. You can find more information in the
[Usage](#usage) section.

## Usage

### v_ensure_packages

Ensures packages are installed according to specified policy (policy::software::install). This methods run in the same
manner as ensure*packages (in fact it copies most of it) with the exception that it also performs a hiera lookup for
the policy and adds as the ensure value. Note that this is overridden if you specify a \_ensure* value.

The general call for this function is as follow: v*ensure_packages(\_Packages*[, *Options*]), where

- _Packages_ can be a string (package name), array of strings (packages names), or a hash with package name being the
  key and options being the a hash object
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

You can also specify a hash to apply to all packages to override settings. Note that in the case of using hashes, then
the options will be treated as defaults and will be overriden by whatever is specified in the package hash.

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

### vcommon::policy

Returns the policy under given policy name. This function works a bit like a registry using hiera to figure out the
policy and return its value. Policies are stored under the hiera **policy** key as dictionary. Note that here is no
data type checking.

```yaml
policy:
  my::dummy::policy: "install"
```

```puppet
vcommon::policy('my::dummy::policy') # will return install
```

An optional (second) parameter may be provided when checking if a policy is overridden in specific case. A classic
example is having a policy for installing all software (i.e. latest), but a specific override when installing a specific
package. The second parameter is used to specify the context (if set to undef then it will be ignored). This makes a
check at the **policy::overrride** dictionary. Note that a policy may have multiple overrides and for that reason the
override is a dictionary. If context is not found then the policy value will be return.

```yaml
policy:
  my::dummy::policy: "install"

policy::override:
  my::dummy::policy:
    context: "default"
    context::another: "test"
    some::other::value: "testing"
```

```puppet
vcommon::policy('my::dummy::policy') # will return install
vcommon::policy('my::dummy::policy', 'context') # will return default
vcommon::policy('my::dummy::policy', 'context::another') # will return test
vcommon::policy('my::dummy::policy', 'notfound') # will return install
```

The last parameter provides a return value if a policy or an override is not found. By default undef is returned.

```yaml
policy:
  my::dummy::policy: "install"
```

```puppet
vcommon::policy('my::none::policy', undef, 'test') # will return test
```

## Limitations

Currently only works/tested on:

- Debian 8
- Ubuntu 18.04
- LinuxMint 19

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md)

## Release Notes

See [CHANGELOG.md](CHANGELOG.md)
