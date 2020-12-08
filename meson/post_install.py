#!/usr/bin/env python3

import os
import subprocess

homedir = os.path.join(os.environ['HOME'])
map_file = os.path.join('../.weather-map.dat')

print('Install weather-map.dat...')
subprocess.call(['cp', '-pf', map_file, homedir])