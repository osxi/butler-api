#!/bin/bash

# Environment variables
export RAILS_ENV=test
export RACK_ENV=test
export ROOT_URL=localhost:3000

# Fresh runner
if [ ! -f ~/.runner_setup ]; then
  echo "Setting up runner..."

  # GPG Keys
  gpg --homedir ~/.gnupg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3

  # RVM
  unset RUBYLIB
  unset GEM_HOME
  \curl -sSL https://get.rvm.io | bash -s stable

  # Prerequisite packages
  sudo apt-get -y -q install nodejs postgresql

  # Create postgres user
  sudo -u postgres createuser --username=postgres --createdb --no-password gitlab_ci_runner

  # Skip setup for subsequent builds
  touch ~/.runner_setup
  echo "Done setting up runner."
fi

# Set Ruby version
source ~/.rvm/scripts/rvm
rvm use 2.1.2 --install

bundle
rake db:drop && rake db:create
rspec
