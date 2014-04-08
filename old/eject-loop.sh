#!/bin/bash

while true; do sleep $(( ( $RANDOM % 10 ) + 1 )); eject -T ; done
