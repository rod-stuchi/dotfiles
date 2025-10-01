#!/usr/bin/env bash

rg '"signal":' | sort -n -k3,3
