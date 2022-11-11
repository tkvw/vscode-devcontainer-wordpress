#!/usr/bin/env bash
wait-for-it db:3306
wp db reset --yes
