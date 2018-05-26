#!/usr/bin/env bash

openssl rsautl -decrypt -inkey ~/.ssh/github_rsa -in /tmp/encrypt.dat -out /tmp/decrypt.txt
cat /tmp/decrypt.txt
