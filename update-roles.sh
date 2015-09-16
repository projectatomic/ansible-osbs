#!/bin/bash

set -ex

ROLESPATH="roles/"

ansible-galaxy install -p $ROLESPATH -r requirements.yml --force
