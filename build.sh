#!/bin/bash

# Go to the hashcat directory
cd hashcat

# Get a copy of the OpenCL Headers repository if not already acquired
git submodule update --init

# Detect OS and configure accordingly
case "$OSTYPE" in
  linux*)   make ;;
  msys*)    make win32 win64 ;;
esac

# Install
sudo make install

# I don't know if sudo is necessary, but it solved a permissions error I was getting:
# https://hastebin.com/acucuvocup.sql
