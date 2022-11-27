#!/bin/bash

# Free up our hugepages RAM
echo 0 > /proc/sys/vm/nr_hugepages
