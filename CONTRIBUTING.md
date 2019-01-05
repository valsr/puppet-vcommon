# How to contribute

You want to contribute? Awesome. Lets get through the gritty details so that we can get your code home! This guide
should help you at least a little bit in getting there, you might need to add some elbow-grease and some brain as well.

#### TOC

1. [Getting Started](#getting-started)
1. [Making Changes](#making-changes)
1. [Testing Changes](#testing-changes)
1. [Submitting Changes](#submitting-changes)
1. [Get Help](#get-help)

## Getting Started

Submitting changes(code) follows a simple process can be summarized in the following diagram:

> fork - commit - test - pull request

Your first step will be to fork the repository, which means you will need a [github account](https://github.com/). Once
you fork the repository you can begin making your changes.

## Making Changes

- Create a topic branch from where you want to base your work
  - This is usually the master branch.
  - Only target release branches if you are certain your fix must be on that branch.
- Make commits of logical and atomic units.
- Make sure your commit messages are in the proper format.
- Make sure you have added the necessary tests for your changes.
- Make sure you have updated relevant documentation.

Follow the project standards - at the moment this are as follow:

- use pupept coding style guidelines
- use only unix line ending (\n)
- max line length of 120 charactres
- use 2 spaces instead of tab (\t)

### Making Trivial Changes

For trivial changes (documentation updates, typo corrections, any small non-code changes) you can omit most of the
requirements - just fork-commit-pull request will suffice. If the change is not minor, then your pull request will be
rejected and you will need to resubmit using the standard process.

## Testing Changes

With any project change we are aiming to produce top quality works. To accomplish this we are using unit tests to
guarantee that all project changes don't negatively impact other parts of the module/APIs. And so will you - all changes
except trivial ones need to be tested and tested well. There are three metrics you will need to meet before we are ready
to accept your changes and these are:

1. your tests run cleanly (no issues)
1. all other tests run cleanly (no issues)
1. you have sufficient test coverage on your changes (around 80% or higher)

To test code we are using the puppet standard unit testing procedures as outlined in the
[Puppet Development Kit (PDK)](https://puppet.com/docs/pdk/1.x/pdk.html). You will need to setup your testing
infrastructure:

1. installing the [PDK](https://puppet.com/docs/pdk/1.x/pdk_install.html)
1. run `bundle install --path /vendor/bundle` to install other gems

For information on how to test your code refer to the PDK documentation as well as the
[puppet-rspec](https://rspec-puppet.com/) module documentation.

### Running Tests

Simple issue at the project root

```sh
bundle exec rake spec
```

This will do two things:

1. execute all unit tests found under spec
1. generate coverage report under coverage

## Submitting Changes

Once your changes are ready to go you will need to do the following:

1. rebase your changes on top of the most recent version of the branch you want to merge to
1. create a pull request and follow the request template
1. once your changes have been reviewed you might need to perform corrections to them, re-run tests and update the pull
   request

## Get Help

If you need more help with any aspect of the project or how to submit your work you can ask a question to the issues
page!
