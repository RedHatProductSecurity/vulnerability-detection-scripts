#!/bin/bash

# Copyright (c) 2020  Red Hat, Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

VERSION="1.1"

# Warning! Be sure to download the latest version of this script from its primary source:

ARTICLE="https://access.redhat.com/security/vulnerabilities/grub2bootloader"

# DO NOT blindly trust any internet sources and NEVER do `curl something | bash`!

# This script is meant for simple detection of the vulnerability. Feel free to modify it for your
# environment or needs. For more advanced detection, consider Red Hat Insights:
# https://access.redhat.com/products/red-hat-insights#getstarted

# Checking against the list of vulnerable packages is necessary because of the way how features
# are back-ported to older versions of packages in various channels.

VULNERABLE_VERSIONS=(
    'shim-0.7-4.el7'
    'shim-0.7-5.2.el7'
    'shim-0.7-5.el7'
    'shim-0.7-8.el7_0'
    'shim-0.9-1.el7'
    'shim-0.9-2.el7'
    'shim-12-1.el7'
    'shim-15-1.el7'
    'shim-15-5.el7'
    'shim-15-5.el7'
    'shim-15-8'
    'shim-ia32-12-1.el7'
    'shim-ia32-15-1.el7'
    'shim-ia32-15-2.el7'
    'shim-ia32-15-5'
    'shim-ia32-15-8'
    'shim-ia32-15-11'
    'shim-x64-12-1.el7'
    'shim-x64-15-1.el7'
    'shim-x64-15-2.el7'
    'shim-x64-15-5'
    'shim-x64-15-8'
    'shim-x64-15-11'
    'grub2-2.02-0.16.ael7b'
    'grub2-2.02-0.17.ael7b_1.2'
    'grub2-2.02-0.17.ael7b_1.6'
    'grub2-2.02-0.2.10.el7'
    'grub2-2.02-0.16.el7'
    'grub2-2.02-0.17.el7_1.4'
    'grub2-2.02-0.17.el7_1.6'
    'grub2-2.02-0.29.el7'
    'grub2-2.02-0.33.el7_2'
    'grub2-2.02-0.34.el7_2'
    'grub2-2.02-0.34.el7_2.2'
    'grub2-2.02-0.44.el7'
    'grub2-2.02-0.64.el7'
    'grub2-2.02-0.65.el7_4.2'
    'grub2-2.02-0.65.el7_4.3'
    'grub2-2.02-0.65.el7_4.3'
    'grub2-2.02-0.65.el7_5.4'
    'grub2-2.02-0.75.el7'
    'grub2-2.02-0.76.el7'
    'grub2-2.02-0.76.el7.1'
    'grub2-2.02-0.76.el7_6.2'
    'grub2-2.02-0.80.el7'
    'grub2-2.02-0.81.el7'
    'grub2-2.02-0.82.el7'
    'grub2-2.02-66.el8'
    'grub2-2.02-66.el8_0.1'
    'grub2-2.02-78.el8'
    'grub2-2.02-78.el8_1.1'
    'grub2-2.02-81.el8'
    'grub2-2.02-82.el8_2.1'
    'grub2-pc-2.02-0.64.el7'
    'grub2-pc-2.02-0.65.el7_4.2'
    'grub2-pc-2.02-0.65.el7_4.3'
    'grub2-pc-2.02-0.65.el7_5.4'
    'grub2-pc-2.02-0.76.el7.1'
    'grub2-pc-2.02-0.76.el7'
    'grub2-pc-2.02-0.76.el7_6.2'
    'grub2-pc-2.02-0.80.el7'
    'grub2-pc-2.02-0.81.el7'
    'grub2-pc-2.02-0.82.el7'
    'grub2-pc-2.02-66.el8'
    'grub2-pc-2.02-66.el8_0.1'
    'grub2-pc-2.02-78.el8'
    'grub2-pc-2.02-78.el8_1.1'
    'grub2-pc-2.02-81.el8'
    'grub2-pc-2.02-82.el8_2.1'
    'grub2-pc-2.02-84.el8'
    'grub2-efi-2.02-0.2.10.el7'
    'grub2-efi-2.02-0.16.el7'
    'grub2-efi-2.02-0.17.el7_1.4'
    'grub2-efi-2.02-0.17.el7_1.6'
    'grub2-efi-2.02-0.29.el7'
    'grub2-efi-2.02-0.33.el7_2'
    'grub2-efi-2.02-0.34.el7_2'
    'grub2-efi-2.02-0.34.el7_2.2'
    'grub2-efi-2.02-0.44.el7'
    'grub2-efi-x64-2.02-0.64.el7'
    'grub2-efi-x64-2.02-0.65.el7_4.2'
    'grub2-efi-x64-2.02-0.65.el7_4.3'
    'grub2-efi-x64-2.02-0.65.el7_5.4'
    'grub2-efi-x64-2.02-0.76.el7'
    'grub2-efi-x64-2.02-0.76.el7.1'
    'grub2-efi-x64-2.02-0.76.el7_6.2'
    'grub2-efi-x64-2.02-0.80.el7'
    'grub2-efi-x64-2.02-0.81.el7'
    'grub2-efi-x64-2.02-0.82.el7'
    'grub2-efi-x64-2.02-66.el8'
    'grub2-efi-x64-2.02-66.el8_0.1'
    'grub2-efi-x64-2.02-78.el8'
    'grub2-efi-x64-2.02-78.el8_1.1'
    'grub2-efi-x64-2.02-81.el8'
    'grub2-efi-x64-2.02-82.el8_2.1'
    'grub2-efi-ia32-2.02-0.64.el7'
    'grub2-efi-ia32-2.02-0.65.el7_4.2'
    'grub2-efi-ia32-2.02-0.65.el7_4.3'
    'grub2-efi-ia32-2.02-0.65.el7_5.4'
    'grub2-efi-ia32-2.02-0.76.el7'
    'grub2-efi-ia32-2.02-0.76.el7.1'
    'grub2-efi-ia32-2.02-0.76.el7_6.2'
    'grub2-efi-ia32-2.02-0.80.el7'
    'grub2-efi-ia32-2.02-0.81.el7'
    'grub2-efi-ia32-2.02-0.82.el7'
    'grub2-efi-ia32-2.02-66.el8'
    'grub2-efi-ia32-2.02-66.el8_0.1'
    'grub2-efi-ia32-2.02-78.el8'
    'grub2-efi-ia32-2.02-78.el8_1.1'
    'grub2-efi-ia32-2.02-81.el8'
    'grub2-efi-ia32-2.02-82.el8_2.1'
    'grub2-efi-aa64-2.02-0.65.el7_4.2'
    'grub2-efi-aa64-2.02-0.75.el7'
    'grub2-efi-aa64-2.02-0.76.el7'
    'grub2-efi-aa64-2.02-0.76.el7.1'
    'grub2-efi-aa64-2.02-0.76.el7_6.2'
    'grub2-efi-aa64-2.02-66.el8'
    'grub2-efi-aa64-2.02-66.el8_0.1'
    'grub2-efi-aa64-2.02-78.el8'
    'grub2-efi-aa64-2.02-78.el8_1.1'
    'grub2-efi-aa64-2.02-81.el8'
    'grub2-efi-aa64-2.02-82.el8_2.1'
    'kernel-rt-3.10.0-229.rt56.141.el7'
    'kernel-rt-3.10.0-229.1.2.rt56.141.2.el7_1'
    'kernel-rt-3.10.0-229.4.2.rt56.141.6.el7_1'
    'kernel-rt-3.10.0-229.7.2.rt56.141.6.el7_1'
    'kernel-rt-3.10.0-229.11.1.rt56.141.11.el7_1'
    'kernel-rt-3.10.0-229.14.1.rt56.141.13.el7_1'
    'kernel-rt-3.10.0-229.20.1.rt56.141.14.el7_1'
    'kernel-rt-3.10.0-327.rt56.204.el7'
    'kernel-rt-3.10.0-327.4.5.rt56.206.el7_2'
    'kernel-rt-3.10.0-327.10.1.rt56.211.el7_2'
    'kernel-rt-3.10.0-327.13.1.rt56.216.el7_2'
    'kernel-rt-3.10.0-327.18.2.rt56.223.el7_2'
    'kernel-rt-3.10.0-327.22.2.rt56.230.el7_2'
    'kernel-rt-3.10.0-327.28.2.rt56.234.el7_2'
    'kernel-rt-3.10.0-327.28.3.rt56.235.el7'
    'kernel-rt-3.10.0-327.36.1.rt56.237.el7'
    'kernel-rt-3.10.0-327.36.3.rt56.238.el7'
    'kernel-rt-3.10.0-514.rt56.420.el7'
    'kernel-rt-3.10.0-514.2.2.rt56.424.el7'
    'kernel-rt-3.10.0-514.6.1.rt56.429.el7'
    'kernel-rt-3.10.0-514.6.1.rt56.430.el7'
    'kernel-rt-3.10.0-514.10.2.rt56.435.el7'
    'kernel-rt-3.10.0-514.16.1.rt56.437.el7'
    'kernel-rt-3.10.0-514.21.1.rt56.438.el7'
    'kernel-rt-3.10.0-514.26.1.rt56.442.el7'
    'kernel-rt-3.10.0-693.rt56.617.el7'
    'kernel-rt-3.10.0-693.2.1.rt56.620.el7'
    'kernel-rt-3.10.0-693.2.2.rt56.623.el7'
    'kernel-rt-3.10.0-693.5.2.rt56.626.el7'
    'kernel-rt-3.10.0-693.11.1.rt56.632.el7'
    'kernel-rt-3.10.0-693.11.1.rt56.639.el7'
    'kernel-rt-3.10.0-693.17.1.rt56.636.el7'
    'kernel-rt-3.10.0-693.21.1.rt56.639.el7'
    'kernel-rt-3.10.0-861.rt56.803.el7'
    'kernel-rt-3.10.0-862.rt56.804.el7'
    'kernel-rt-3.10.0-862.2.3.rt56.806.el7'
    'kernel-rt-3.10.0-862.3.2.rt56.808.el7'
    'kernel-rt-3.10.0-862.3.3.rt56.809.el7'
    'kernel-rt-3.10.0-862.6.3.rt56.811.el7'
    'kernel-rt-3.10.0-862.11.6.rt56.819.el7'
    'kernel-rt-3.10.0-862.14.4.rt56.821.el7'
    'kernel-rt-3.10.0-957.rt56.910.el7'
    'kernel-rt-3.10.0-957.1.3.rt56.913.el7'
    'kernel-rt-3.10.0-957.5.1.rt56.916.el7'
    'kernel-rt-3.10.0-957.10.1.rt56.921.el7'
    'kernel-rt-3.10.0-957.12.1.rt56.927.el7'
    'kernel-rt-3.10.0-957.12.2.rt56.929.el7'
    'kernel-rt-3.10.0-957.21.2.rt56.934.el7'
    'kernel-rt-3.10.0-957.21.3.rt56.935.el7'
    'kernel-rt-3.10.0-957.27.2.rt56.940.el7'
    'kernel-rt-3.10.0-1062.rt56.1022.el7'
    'kernel-rt-3.10.0-1062.1.1.rt56.1024.el7'
    'kernel-rt-3.10.0-1062.1.2.rt56.1025.el7'
    'kernel-rt-3.10.0-1062.4.1.rt56.1027.el7'
    'kernel-rt-3.10.0-1062.4.2.rt56.1028.el7'
    'kernel-rt-3.10.0-1062.4.3.rt56.1029.el7'
    'kernel-rt-3.10.0-1062.7.1.rt56.1030.el7'
    'kernel-rt-3.10.0-1062.9.1.rt56.1033.el7'
    'kernel-rt-3.10.0-1062.12.1.rt56.1042.el7'
    'kernel-rt-3.10.0-1062.18.1.rt56.1044.el7'
    'kernel-rt-3.10.0-1101.rt56.1061.el7'
    'kernel-rt-3.10.0-1127.rt56.1093.el7'
    'kernel-rt-3.10.0-1127.8.2.rt56.1103.el7'
    'kernel-rt-3.10.0-1127.10.1.rt56.1106.el7'
    'kernel-rt-3.10.0-1127.13.1.rt56.1110.el7'
    'kernel-rt-3.10.0-1136.rt56.1107.el7'
    'kernel-rt-4.18.0-80.rt9.138.el8'
    'kernel-rt-4.18.0-80.1.2.rt9.145.el8_0'
    'kernel-rt-4.18.0-80.4.2.rt9.152.el8_0'
    'kernel-rt-4.18.0-80.7.1.rt9.153.el8_0'
    'kernel-rt-4.18.0-80.7.2.rt9.154.el8_0'
    'kernel-rt-4.18.0-80.11.1.rt9.156.el8_0'
    'kernel-rt-4.18.0-80.11.2.rt9.157.el8_0'
    'kernel-rt-4.18.0-147.rt24.93.el8'
    'kernel-rt-4.18.0-147.0.2.rt24.94.el8_1'
    'kernel-rt-4.18.0-147.0.3.rt24.95.el8_1'
    'kernel-rt-4.18.0-147.3.1.rt24.96.el8_1'
    'kernel-rt-4.18.0-147.5.1.rt24.98.el8_1'
    'kernel-rt-4.18.0-147.8.1.rt24.101.el8_1'
    'kernel-rt-4.18.0-193.rt13.51.el8'
    'kernel-rt-4.18.0-193.1.2.rt13.53.el8_2'
    'kernel-rt-4.18.0-193.6.3.rt13.59.el8_2'
    'kernel-rt-4.18.0-193.12.1.rt13.63.el8_2'
    'kernel-rt-4.18.0-193.13.2.rt13.65.el8_2'
    'kernel-rt-4.18.0-193.13.2.rt13.65.el8_2'
    'kernel-3.10.0-229.ael7b'
    'kernel-3.10.0-229.1.2.ael7b'
    'kernel-3.10.0-229.4.2.ael7b'
    'kernel-3.10.0-229.7.2.ael7b'
    'kernel-3.10.0-229.11.1.ael7b'
    'kernel-3.10.0-229.14.1.ael7b'
    'kernel-3.10.0-229.20.1.ael7b'
    'kernel-3.10.0-229.24.2.ael7b'
    'kernel-3.10.0-229.26.2.ael7b'
    'kernel-3.10.0-229.28.1.ael7b'
    'kernel-3.10.0-229.30.1.ael7b'
    'kernel-3.10.0-229.34.1.ael7b'
    'kernel-3.10.0-229.38.1.ael7b'
    'kernel-3.10.0-229.40.1.ael7b'
    'kernel-3.10.0-229.42.1.ael7b'
    'kernel-3.10.0-229.42.2.ael7b'
    'kernel-3.10.0-229.44.1.ael7b'
    'kernel-3.10.0-229.46.1.ael7b'
    'kernel-3.10.0-229.48.1.ael7b'
    'kernel-3.10.0-229.49.1.ael7b'
    'kernel-3.10.0-121.el7'
    'kernel-3.10.0-123.el7'
    'kernel-3.10.0-123.1.2.el7'
    'kernel-3.10.0-123.4.2.el7'
    'kernel-3.10.0-123.4.4.el7'
    'kernel-3.10.0-123.6.3.el7'
    'kernel-3.10.0-123.8.1.el7'
    'kernel-3.10.0-123.9.2.el7'
    'kernel-3.10.0-123.9.3.el7'
    'kernel-3.10.0-123.13.1.el7'
    'kernel-3.10.0-123.13.2.el7'
    'kernel-3.10.0-123.20.1.el7'
    'kernel-3.10.0-229.el7'
    'kernel-3.10.0-229.1.2.el7'
    'kernel-3.10.0-229.4.2.el7'
    'kernel-3.10.0-229.7.2.el7'
    'kernel-3.10.0-229.11.1.el7'
    'kernel-3.10.0-229.14.1.el7'
    'kernel-3.10.0-229.20.1.el7'
    'kernel-3.10.0-229.24.2.el7'
    'kernel-3.10.0-229.26.2.el7'
    'kernel-3.10.0-229.28.1.el7'
    'kernel-3.10.0-229.30.1.el7'
    'kernel-3.10.0-229.34.1.el7'
    'kernel-3.10.0-229.38.1.el7'
    'kernel-3.10.0-229.40.1.el7'
    'kernel-3.10.0-229.42.1.el7'
    'kernel-3.10.0-229.42.2.el7'
    'kernel-3.10.0-229.44.1.el7'
    'kernel-3.10.0-229.46.1.el7'
    'kernel-3.10.0-229.48.1.el7'
    'kernel-3.10.0-229.49.1.el7'
    'kernel-3.10.0-327.el7'
    'kernel-3.10.0-327.3.1.el7'
    'kernel-3.10.0-327.4.4.el7'
    'kernel-3.10.0-327.4.5.el7'
    'kernel-3.10.0-327.10.1.el7'
    'kernel-3.10.0-327.13.1.el7'
    'kernel-3.10.0-327.18.2.el7'
    'kernel-3.10.0-327.22.2.el7'
    'kernel-3.10.0-327.28.2.el7'
    'kernel-3.10.0-327.28.3.el7'
    'kernel-3.10.0-327.36.1.el7'
    'kernel-3.10.0-327.36.2.el7'
    'kernel-3.10.0-327.36.3.el7'
    'kernel-3.10.0-327.41.3.el7'
    'kernel-3.10.0-327.41.4.el7'
    'kernel-3.10.0-327.44.2.el7'
    'kernel-3.10.0-327.46.1.el7'
    'kernel-3.10.0-327.49.2.el7'
    'kernel-3.10.0-327.53.1.el7'
    'kernel-3.10.0-327.55.1.el7'
    'kernel-3.10.0-327.55.2.el7'
    'kernel-3.10.0-327.55.3.el7'
    'kernel-3.10.0-327.58.1.el7'
    'kernel-3.10.0-327.59.1.el7'
    'kernel-3.10.0-327.59.2.el7'
    'kernel-3.10.0-327.59.3.el7'
    'kernel-3.10.0-327.61.3.el7'
    'kernel-3.10.0-327.62.1.el7'
    'kernel-3.10.0-327.62.4.el7'
    'kernel-3.10.0-327.62.4.el7'
    'kernel-3.10.0-327.62.4.el7'
    'kernel-3.10.0-327.64.1.el7'
    'kernel-3.10.0-327.64.1.el7'
    'kernel-3.10.0-327.64.1.el7'
    'kernel-3.10.0-327.66.1.el7'
    'kernel-3.10.0-327.66.1.el7'
    'kernel-3.10.0-327.66.1.el7'
    'kernel-3.10.0-327.66.3.el7'
    'kernel-3.10.0-327.66.3.el7'
    'kernel-3.10.0-327.66.3.el7'
    'kernel-3.10.0-327.66.5.el7'
    'kernel-3.10.0-327.66.5.el7'
    'kernel-3.10.0-327.66.5.el7'
    'kernel-3.10.0-327.70.1.el7'
    'kernel-3.10.0-327.70.1.el7'
    'kernel-3.10.0-327.70.1.el7'
    'kernel-3.10.0-327.71.1.el7'
    'kernel-3.10.0-327.71.1.el7'
    'kernel-3.10.0-327.71.1.el7'
    'kernel-3.10.0-327.71.4.el7'
    'kernel-3.10.0-327.71.4.el7'
    'kernel-3.10.0-327.71.4.el7'
    'kernel-3.10.0-327.73.1.el7'
    'kernel-3.10.0-327.73.1.el7'
    'kernel-3.10.0-327.73.1.el7'
    'kernel-3.10.0-327.76.1.el7'
    'kernel-3.10.0-327.76.1.el7'
    'kernel-3.10.0-327.76.1.el7'
    'kernel-3.10.0-327.77.1.el7'
    'kernel-3.10.0-327.77.1.el7'
    'kernel-3.10.0-327.77.1.el7'
    'kernel-3.10.0-327.78.2.el7'
    'kernel-3.10.0-327.78.2.el7'
    'kernel-3.10.0-327.78.2.el7'
    'kernel-3.10.0-327.79.2.el7'
    'kernel-3.10.0-327.79.2.el7'
    'kernel-3.10.0-327.79.2.el7'
    'kernel-3.10.0-327.80.1.el7'
    'kernel-3.10.0-327.80.1.el7'
    'kernel-3.10.0-327.80.1.el7'
    'kernel-3.10.0-327.82.1.el7'
    'kernel-3.10.0-327.82.1.el7'
    'kernel-3.10.0-327.82.1.el7'
    'kernel-3.10.0-327.82.2.el7'
    'kernel-3.10.0-327.82.2.el7'
    'kernel-3.10.0-327.82.2.el7'
    'kernel-3.10.0-327.83.1.el7'
    'kernel-3.10.0-327.83.1.el7'
    'kernel-3.10.0-327.83.1.el7'
    'kernel-3.10.0-327.84.1.el7'
    'kernel-3.10.0-327.85.1.el7'
    'kernel-3.10.0-327.86.1.el7'
    'kernel-3.10.0-327.88.1.el7'
    'kernel-3.10.0-327.89.1.el7'
    'kernel-3.10.0-514.el7'
    'kernel-3.10.0-514.2.2.el7'
    'kernel-3.10.0-514.6.1.el7'
    'kernel-3.10.0-514.6.2.el7'
    'kernel-3.10.0-514.10.2.el7'
    'kernel-3.10.0-514.16.1.el7'
    'kernel-3.10.0-514.16.2.p7ih.el7'
    'kernel-3.10.0-514.21.1.el7'
    'kernel-3.10.0-514.21.2.el7'
    'kernel-3.10.0-514.26.1.el7'
    'kernel-3.10.0-514.26.2.el7'
    'kernel-3.10.0-514.28.1.el7'
    'kernel-3.10.0-514.28.2.el7'
    'kernel-3.10.0-514.32.2.el7'
    'kernel-3.10.0-514.32.3.el7'
    'kernel-3.10.0-514.35.1.el7'
    'kernel-3.10.0-514.36.1.el7'
    'kernel-3.10.0-514.36.5.el7'
    'kernel-3.10.0-514.41.1.el7'
    'kernel-3.10.0-514.44.1.el7'
    'kernel-3.10.0-514.48.1.el7'
    'kernel-3.10.0-514.48.3.el7'
    'kernel-3.10.0-514.48.5.el7'
    'kernel-3.10.0-514.51.1.el7'
    'kernel-3.10.0-514.53.1.el7'
    'kernel-3.10.0-514.55.4.el7'
    'kernel-3.10.0-514.58.1.el7'
    'kernel-3.10.0-514.61.1.el7'
    'kernel-3.10.0-514.62.1.el7'
    'kernel-3.10.0-514.62.1.el7'
    'kernel-3.10.0-514.62.1.el7'
    'kernel-3.10.0-514.63.1.el7'
    'kernel-3.10.0-514.63.1.el7'
    'kernel-3.10.0-514.63.1.el7'
    'kernel-3.10.0-514.64.2.el7'
    'kernel-3.10.0-514.64.2.el7'
    'kernel-3.10.0-514.64.2.el7'
    'kernel-3.10.0-514.66.2.el7'
    'kernel-3.10.0-514.66.2.el7'
    'kernel-3.10.0-514.66.2.el7'
    'kernel-3.10.0-514.69.1.el7'
    'kernel-3.10.0-514.69.1.el7'
    'kernel-3.10.0-514.69.1.el7'
    'kernel-3.10.0-514.70.1.el7'
    'kernel-3.10.0-514.70.1.el7'
    'kernel-3.10.0-514.70.1.el7'
    'kernel-3.10.0-514.70.2.el7'
    'kernel-3.10.0-514.70.2.el7'
    'kernel-3.10.0-514.70.2.el7'
    'kernel-3.10.0-514.70.3.el7'
    'kernel-3.10.0-514.70.3.el7'
    'kernel-3.10.0-514.70.3.el7'
    'kernel-3.10.0-514.71.1.el7'
    'kernel-3.10.0-514.71.1.el7'
    'kernel-3.10.0-514.71.1.el7'
    'kernel-3.10.0-514.72.1.el7'
    'kernel-3.10.0-514.72.1.el7'
    'kernel-3.10.0-514.72.1.el7'
    'kernel-3.10.0-514.73.1.el7'
    'kernel-3.10.0-514.73.1.el7'
    'kernel-3.10.0-514.73.1.el7'
    'kernel-3.10.0-514.74.1.el7'
    'kernel-3.10.0-514.74.1.el7'
    'kernel-3.10.0-514.74.1.el7'
    'kernel-3.10.0-514.76.1.el7'
    'kernel-3.10.0-514.76.1.el7'
    'kernel-3.10.0-514.76.1.el7'
    'kernel-3.10.0-514.78.1.el7'
    'kernel-3.10.0-514.78.1.el7'
    'kernel-3.10.0-514.78.1.el7'
    'kernel-3.10.0-693.el7'
    'kernel-3.10.0-693.1.1.el7'
    'kernel-3.10.0-693.2.1.el7'
    'kernel-3.10.0-693.2.2.el7'
    'kernel-3.10.0-693.5.2.el7'
    'kernel-3.10.0-693.5.2.p7ih.el7'
    'kernel-3.10.0-693.11.1.el7'
    'kernel-3.10.0-693.11.6.el7'
    'kernel-3.10.0-693.17.1.el7'
    'kernel-3.10.0-693.21.1.el7'
    'kernel-3.10.0-693.25.2.el7'
    'kernel-3.10.0-693.25.4.el7'
    'kernel-3.10.0-693.25.7.el7'
    'kernel-3.10.0-693.33.1.el7'
    'kernel-3.10.0-693.35.1.el7'
    'kernel-3.10.0-693.37.4.el7'
    'kernel-3.10.0-693.39.1.el7'
    'kernel-3.10.0-693.43.1.el7'
    'kernel-3.10.0-693.44.1.el7'
    'kernel-3.10.0-693.46.1.el7'
    'kernel-3.10.0-693.47.2.el7'
    'kernel-3.10.0-693.50.3.el7'
    'kernel-3.10.0-693.55.1.el7'
    'kernel-3.10.0-693.58.1.el7'
    'kernel-3.10.0-693.59.1.el7'
    'kernel-3.10.0-693.59.1.el7'
    'kernel-3.10.0-693.59.1.el7'
    'kernel-3.10.0-693.60.1.el7'
    'kernel-3.10.0-693.60.1.el7'
    'kernel-3.10.0-693.60.1.el7'
    'kernel-3.10.0-693.60.2.el7'
    'kernel-3.10.0-693.60.2.el7'
    'kernel-3.10.0-693.60.2.el7'
    'kernel-3.10.0-693.60.3.el7'
    'kernel-3.10.0-693.60.3.el7'
    'kernel-3.10.0-693.60.3.el7'
    'kernel-3.10.0-693.61.1.el7'
    'kernel-3.10.0-693.61.1.el7'
    'kernel-3.10.0-693.61.1.el7'
    'kernel-3.10.0-693.62.1.el7'
    'kernel-3.10.0-693.62.1.el7'
    'kernel-3.10.0-693.62.1.el7'
    'kernel-3.10.0-693.64.1.el7'
    'kernel-3.10.0-693.64.1.el7'
    'kernel-3.10.0-693.64.1.el7'
    'kernel-3.10.0-693.65.1.el7'
    'kernel-3.10.0-693.65.1.el7'
    'kernel-3.10.0-693.65.1.el7'
    'kernel-3.10.0-693.67.1.el7'
    'kernel-3.10.0-693.67.1.el7'
    'kernel-3.10.0-693.67.1.el7'
    'kernel-3.10.0-693.69.1.el7'
    'kernel-3.10.0-693.69.1.el7'
    'kernel-3.10.0-693.69.1.el7'
    'kernel-3.10.0-861.el7'
    'kernel-3.10.0-862.el7'
    'kernel-3.10.0-862.2.3.el7'
    'kernel-3.10.0-862.3.2.el7'
    'kernel-3.10.0-862.3.3.el7'
    'kernel-3.10.0-862.6.3.el7'
    'kernel-3.10.0-862.9.1.el7'
    'kernel-3.10.0-862.11.6.el7'
    'kernel-3.10.0-862.14.4.el7'
    'kernel-3.10.0-862.20.2.el7'
    'kernel-3.10.0-862.25.3.el7'
    'kernel-3.10.0-862.27.1.el7'
    'kernel-3.10.0-862.29.1.el7'
    'kernel-3.10.0-862.32.1.el7'
    'kernel-3.10.0-862.32.2.el7'
    'kernel-3.10.0-862.34.1.el7'
    'kernel-3.10.0-862.34.2.el7'
    'kernel-3.10.0-862.37.1.el7'
    'kernel-3.10.0-862.41.1.el7'
    'kernel-3.10.0-862.41.2.el7'
    'kernel-3.10.0-862.43.1.el7'
    'kernel-3.10.0-862.43.2.el7'
    'kernel-3.10.0-862.43.3.el7'
    'kernel-3.10.0-862.44.2.el7'
    'kernel-3.10.0-862.46.1.el7'
    'kernel-3.10.0-862.48.1.el7'
    'kernel-3.10.0-862.51.1.el7'
    'kernel-3.10.0-957.el7'
    'kernel-3.10.0-957.1.3.el7'
    'kernel-3.10.0-957.5.1.el7'
    'kernel-3.10.0-957.10.1.el7'
    'kernel-3.10.0-957.12.1.el7'
    'kernel-3.10.0-957.12.1.el7'
    'kernel-3.10.0-957.12.2.el7'
    'kernel-3.10.0-957.21.2.el7'
    'kernel-3.10.0-957.21.3.el7'
    'kernel-3.10.0-957.27.2.el7'
    'kernel-3.10.0-957.27.4.el7'
    'kernel-3.10.0-957.35.1.el7'
    'kernel-3.10.0-957.35.2.el7'
    'kernel-3.10.0-957.38.1.el7'
    'kernel-3.10.0-957.38.2.el7'
    'kernel-3.10.0-957.38.3.el7'
    'kernel-3.10.0-957.41.1.el7'
    'kernel-3.10.0-957.43.1.el7'
    'kernel-3.10.0-957.46.1.el7'
    'kernel-3.10.0-957.48.1.el7'
    'kernel-3.10.0-957.54.1.el7'
    'kernel-3.10.0-957.56.1.el7'
    'kernel-3.10.0-1062.el7'
    'kernel-3.10.0-1062.1.1.el7'
    'kernel-3.10.0-1062.1.2.el7'
    'kernel-3.10.0-1062.4.1.el7'
    'kernel-3.10.0-1062.4.2.el7'
    'kernel-3.10.0-1062.4.3.el7'
    'kernel-3.10.0-1062.7.1.el7'
    'kernel-3.10.0-1062.9.1.el7'
    'kernel-3.10.0-1062.12.1.el7'
    'kernel-3.10.0-1062.18.1.el7'
    'kernel-3.10.0-1062.21.1.el7'
    'kernel-3.10.0-1062.26.1.el7'
    'kernel-3.10.0-1062.30.1.el7'
    'kernel-3.10.0-1101.el7'
    'kernel-3.10.0-1111.el7'
    'kernel-3.10.0-1118.el7'
    'kernel-3.10.0-1127.el7'
    'kernel-3.10.0-1127.8.2.el7'
    'kernel-3.10.0-1127.10.1.el7'
    'kernel-3.10.0-1127.13.1.el7'
    'kernel-3.10.0-1136.el7'
    'kernel-3.10.0-1149.el7'
    'kernel-3.10.0-1152.el7'
    'kernel-4.18.0-80.el8'
    'kernel-4.18.0-80.1.2.el8_0'
    'kernel-4.18.0-80.4.2.el8_0'
    'kernel-4.18.0-80.7.1.el8_0'
    'kernel-4.18.0-80.7.2.el8_0'
    'kernel-4.18.0-80.11.1.el8_0'
    'kernel-4.18.0-80.11.2.el8_0'
    'kernel-4.18.0-80.15.1.el8_0'
    'kernel-4.18.0-80.16.1.el8_0'
    'kernel-4.18.0-80.18.1.el8_0'
    'kernel-4.18.0-80.23.2.el8_0'
    'kernel-4.18.0-147.el8'
    'kernel-4.18.0-147.0.2.el8_1'
    'kernel-4.18.0-147.0.3.el8_1'
    'kernel-4.18.0-147.3.1.el8_1'
    'kernel-4.18.0-147.5.1.el8_1'
    'kernel-4.18.0-147.8.1.el8_1'
    'kernel-4.18.0-147.13.2.el8_1'
    'kernel-4.18.0-147.20.1.el8_1'
    'kernel-4.18.0-147.20.1.el8_1'
    'kernel-4.18.0-193.el8'
    'kernel-4.18.0-193.1.2.el8_2'
    'kernel-4.18.0-193.6.3.el8_2'
    'kernel-4.18.0-193.12.1.el8_2'
    'kernel-4.18.0-193.13.2.el8_2'
    'kernel-4.18.0-193.13.2.el8_2'
    'kernel-4.18.0-193.13.2.el8_2'
    'dbxtool-7-1.el7'
    'dbxtool-8-5.el8'
    'fwupd-0.8.2-3.el7'
    'fwupd-1.0.1-4.el7'
    'fwupd-1.0.8-3.el7'
    'fwupd-1.0.8-4.el7'
    'fwupd-1.0.8-5.el7'
    'fwupd-1.1.4-1.el8'
    'fwupd-1.1.4-6.el8'
    'fwupdate-9-8.el7'
    'fwupdate-12-5.el7'
    'fwupdate-11-3.el8'
)

PKG_NAMES_SHIM=(
    'shim' 'shim-ia32' 'shim-x64'
)
PKG_NAMES_GRUB=(
    'grub2' 'grub2-pc' 'grub2-efi' 'grub2-efi-x64' 'grub2-efi-ia32' 'grub2-efi-aa64'
)
PKG_NAMES_GRUB_EFI=(
    'grub2-efi' 'grub2-efi-x64' 'grub2-efi-ia32' 'grub2-efi-aa64'
)
PKG_NAMES_KERNEL=(
    'kernel' 'kernel-rt'
)


basic_args() {
    # Parses basic commandline arguments and sets basic environment.
    #
    # Args:
    #     parameters - an array of commandline arguments
    #
    # Side effects:
    #     Exits if --help parameters is used
    #     Sets COLOR constants and debug variable

    local parameters=( "$@" )

    RED="\\033[1;31m"
    YELLOW="\\033[1;33m"
    GREEN="\\033[1;32m"
    BOLD="\\033[1m"
    RESET="\\033[0m"
    for parameter in "${parameters[@]}"; do
        if [[ "$parameter" == "-h" || "$parameter" == "--help" ]]; then
            echo "Usage: $( basename "$0" ) [-n | --no-colors] [-d | --debug]"
            exit 1
        elif [[ "$parameter" == "-n" || "$parameter" == "--no-colors" ]]; then
            RED=""
            YELLOW=""
            GREEN=""
            BOLD=""
            RESET=""
        elif [[ "$parameter" == "-d" || "$parameter" == "--debug" ]]; then
            debug=true
        fi
    done
}


basic_reqs() {
    # Prints common disclaimer and checks basic requirements.
    #
    # Args:
    #     CVE - string printed in the disclaimer
    #
    # Side effects:
    #     Exits when 'rpm' command is not available

    local CVE="$1"

    # Disclaimer
    echo
    echo -e "${BOLD}This script (v$VERSION) is primarily designed to detect $CVE on supported"
    echo -e "Red Hat Enterprise Linux systems and kernel packages."
    echo -e "Result may be inaccurate for other RPM based systems.${RESET}"
    echo

    # RPM is required
    if ! command -v rpm &> /dev/null; then
        echo "'rpm' command is required, but not installed. Exiting."
        exit 1
    fi
}


check_supported_kernel() {
    # Checks if running kernel is supported.
    #
    # Args:
    #     running_kernel - kernel string as returned by 'uname -r'
    #
    # Side effects:
    #     Exits when running kernel is obviously not supported

    local running_kernel="$1"

    # Check supported platform
    if [[ "$running_kernel" != *".el"[5-8]* ]]; then
        echo -e "${RED}This script is meant to be used only on RHEL 5-8.${RESET}"
        exit 1
    fi
}


get_rhel() {
    # Gets RHEL number.
    #
    # Args:
    #     running_kernel - kernel string as returned by 'uname -r'
    #
    # Prints:
    #     RHEL number, e.g. '5', '6', '7', or '8'

    local running_kernel="$1"

    local rhel
    rhel=$( sed -r -n 's/^.*el([[:digit:]]).*$/\1/p' <<< "$running_kernel" )
    echo "$rhel"
}


set_default_values() {
    result=0
    lowvuln=0
    vulnerable=0
    bootproblem=0
    grubonly=0
    reason=""
    secure_boot_active=0
}


check_dmesg() {
    # Checks if dmesg log or dmesg command contains the given string.
    #
    # Args:
    #     search_string - string to look for in dmesg and dmesg log
    #
    # Returns:
    #     1 if given string present, otherwise 0
    #
    # Notes:
    #     MOCK_DMESG_PATH can be used to mock /var/log/dmesg file

    local search_string="$1"
    local dmesg_log=${MOCK_DMESG_PATH:-/var/log/dmesg}
    local dmesg_cmd
    dmesg_cmd=$( dmesg )
    local journalctl_output
    local journalctl_success


    if grep --quiet -F "$search_string" "$dmesg_log" 2>/dev/null ; then
        return 1
    fi
    if grep --quiet -F "$search_string" <<< "$dmesg_cmd"; then
        return 1
    fi

    if command -v journalctl &> /dev/null; then
        journalctl_output="$( journalctl -k 2>/dev/null )"
        # Store inverted output value as a flag that is true when the command ended with a zero return value.
        # shellcheck disable=SC2181
        journalctl_success=$(( ! $? ))
        if (( journalctl_success )) ; then
            if grep --quiet -F "$search_string" <<< "$journalctl_output"; then
                return 1
            fi
        fi
    fi

    return 0
}


secure_boot_dmesg() {
    # Uses dmesg to detect whether secure boot is active.
    #
    # Side effects:
    #     Sets the `secure_boot_active_dmesg` variable to 1 if secure boot is active
    #     according to dmesg, or to 0 if it is not.

    check_dmesg "Secure boot enabled"
    # Store result as a flag, 1 as True, 0 as False
    # shellcheck disable=SC2181
    secure_boot_active_dmesg=$(( $? ))
}


secure_boot_mokutil() {
    # Uses mokutil to detect whether secure boot is active.
    #
    # Side effects:
    #     Sets the `secure_boot_active_mokutil` variable to 1 if secure boot is active
    #     according to mokutil, or to 0 if it is not or if mokutil is not installed.

    secure_boot_active_mokutil=0
    if command -v mokutil &> /dev/null; then
        if [[ "$( mokutil --sb-state )" == "SecureBoot enabled" ]]; then
            secure_boot_active_mokutil=1
        fi
    fi
}


secure_boot_firmware() {
    # Uses /sys/firmware/efi/efivars/SecureBoot-* to detect whether secure boot is active.
    #
    # Side effects:
    #     Sets the `secure_boot_active_firmware` variable to 1 if secure boot is active
    #     according to /sys/firmware/efi/efivars/SecureBoot-*, or to 0 if it is not or
    #     if the path is not available.
    #
    # Notes:
    #     MOCK_EFI_PATH can be used to mock /sys/firmware/efi/efivars directory

    secure_boot_active_firmware=0
    # See https://github.com/koalaman/shellcheck/wiki/SC2144 for the reason of this for/if/break type of file existence check
    for sb_efivar in "${MOCK_EFI_PATH:-/sys/firmware/efi/efivars}"/SecureBoot-*; do
        if [[ -f "$sb_efivar" ]]; then
            if [[ "$(od --address-radix=n --format=u1 "$sb_efivar" | awk '{print $5}')" == "1" ]]; then
                secure_boot_active_firmware=1
            fi
            break
        fi
    done
}


check_package() {
    # Checks if installed package is in list of vulnerable packages.
    #
    # Args:
    #     installed_packages - installed packages string as returned by 'rpm -qa package'
    #                          (may be multiline)
    #     vulnerable_versions - an array of vulnerable versions
    #
    # Prints:
    #     First vulnerable package string as returned by 'rpm -qa package', or nothing

    # Convert to array, use word splitting on purpose
    # shellcheck disable=SC2206
    local installed_packages=( $1 )
    shift
    local vulnerable_versions=( "$@" )

    for tested_package in "${vulnerable_versions[@]}"; do
        for installed_package in "${installed_packages[@]}"; do
            installed_package_without_arch="${installed_package%.*}"
            if [[ "$installed_package_without_arch" == "$tested_package" ]]; then
                echo "$installed_package"
                return 0
            fi
        done
    done
}


get_installed_packages() {
    # Checks for installed packages. Compatible with RHEL5.
    #
    # Args:
    #     package_names - an array of package name strings
    #
    # Prints:
    #     Liness with N-V-R.A strings of the installed packages.

    local package_names=( "$@" )

    rpm -qa --queryformat="%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\n" "${package_names[@]}"
}


get_installed_package_names() {
    # Checks for installed packages and returns the names if installed. Compatible with RHEL5.
    #
    # Args:
    #     package_names - an array of package name strings
    #
    # Prints:
    #     Lines with the names of the installed packages.

    local package_names=( "$@" )

    rpm -qa --queryformat="%{NAME}\n" "${package_names[@]}" | uniq
}


installed_rpms_shim() {
    # Prints installed package versions for all the relevant packages.

    get_installed_packages "${PKG_NAMES_SHIM[@]}"
}


installed_rpms_grub() {
    # Prints installed package versions for all the relevant packages.

    get_installed_packages "${PKG_NAMES_GRUB[@]}"
}


installed_rpms_grub_efi() {
    # Prints installed package versions for all the relevant packages.

    get_installed_packages "${PKG_NAMES_GRUB_EFI[@]}"
}


installed_rpms_kernel() {
    # Prints installed package versions for all the relevant packages.

    get_installed_packages "${PKG_NAMES_KERNEL[@]}"
}


installed_rpm_names_shim() {
    # Prints installed package versions for all the relevant packages.

    get_installed_package_names "${PKG_NAMES_SHIM[@]}"
}


installed_rpm_names_grub() {
    # Prints installed package versions for all the relevant packages.

    get_installed_package_names "${PKG_NAMES_GRUB[@]}"
}


installed_rpm_names_grub_efi() {
    # Prints installed package versions for all the relevant packages.

    get_installed_package_names "${PKG_NAMES_GRUB_EFI[@]}"
}


installed_rpm_names_kernel() {
    # Prints installed package versions for all the relevant packages.

    get_installed_package_names "${PKG_NAMES_KERNEL[@]}"
}


check_fixed_rpms_any() {
    # Detects if at least one of the installed packages is non-vulnerable
    #
    # Args:
    #     installed_packages - installed packages string as returned by 'rpm -qa package'
    #                          (may be multiline)
    #
    # Returns:
    #     - 1 if no RPM from the group is installed at all
    #     - 1 if at least one RPM of the group that is installed is in a non-vulnerable version
    #     - 0 if all RPMs of the group that are installed are in a vulnerable version

    # Convert to array, use word splitting on purpose
    # shellcheck disable=SC2206
    local installed_packages=( $1 )
    local vulnerable_package
    local ret=1
    if [[ "${installed_packages[*]}" ]]; then
        ret=0  # considered vulnerable until at least one fixed kernel is found
        for nvra in "${installed_packages[@]}"; do
            vulnerable_package=$( check_package "$nvra" "${VULNERABLE_VERSIONS[@]}" )
            if [[ ! "$vulnerable_package" ]] ; then
                ret=1  # a single non-vulnerable package flips the flag back to 1
                break
            fi
        done
    fi
    return "$ret"
}


check_fixed_rpms_all() {
    # Detects if all installed packages are non-vulnerable
    #
    # Args:
    #     installed_packages - installed packages string as returned by 'rpm -qa package'
    #                          (may be multiline)
    #
    # Returns:
    #     - 1 if no RPM from the group is installed at all
    #     - 1 if all RPMs of the group that are installed are in non-vulnerable versions
    #     - 0 if at least one RPM of the group that is installed is in a vulnerable version

    # Convert to array, use word splitting on purpose
    # shellcheck disable=SC2206
    local installed_packages=( $1 )
    local vulnerable_package
    local ret=1
    if [[ "${installed_packages[*]}" ]]; then
        for nvra in "${installed_packages[@]}"; do
            vulnerable_package=$( check_package "$nvra" "${VULNERABLE_VERSIONS[@]}" )
            if [[ "$vulnerable_package" ]] ; then
                ret=0  # a single vulnerable package flips the flag to 0
                break
            fi
        done
    fi
    return "$ret"
}


fixed_rpm_shim() {
    # Detects if a fixed version of the RPM is installed.
    #
    # Side effects:
    #     Sets the `fixed_shim` variable to 1 or 0.
    #         - 1 if no RPM from the group is installed at all
    #         - 1 if all RPMs of the group that are installed are in non-vulnerable versions
    #         - 0 if at least one RPM of the group that is installed is in a vulnerable version

    check_fixed_rpms_all "$installed_shim"
    # Store result as a flag, 1 as True, 0 as False
    # shellcheck disable=SC2181
    fixed_shim=$(( $? ))
}


fixed_rpm_grub() {
    # Detects if a fixed version of the RPM is installed.
    #
    # Side effects:
    #     Sets the `fixed_grub` variable to 1 or 0.
    #         - 1 if no RPM from the group is installed at all
    #         - 1 if all RPMs of the group that are installed are in non-vulnerable versions
    #         - 0 if at least one RPM of the group that is installed is in a vulnerable version

    check_fixed_rpms_all "$installed_grub"
    # Store result as a flag, 1 as True, 0 as False
    # shellcheck disable=SC2181
    fixed_grub=$(( $? ))
}


fixed_rpm_kernel() {
    # Detects if a fixed version of the RPM is installed.
    #
    # Side effects:
    #     Sets the `fixed_kernel` variable to 1 or 0.
    #         - 1 if no RPM from the group is installed at all
    #         - 1 if at least one RPM of the group that is installed is in a non-vulnerable version
    #         - 0 if all RPMs of the group that are installed are in a vulnerable version

    check_fixed_rpms_any "$installed_kernel"
    # Store result as a flag, 1 as True, 0 as False
    # shellcheck disable=SC2181
    fixed_kernel=$(( $? ))
}


parse_facts() {
    # Gathers all available information and stores it in global variables. Only store facts and
    # do not draw conclusion in this function for better maintainability.
    #
    # Side effects:
    #     Sets many global boolean flags and content variables

    installed_shim=$(installed_rpms_shim)
    installed_grub=$(installed_rpms_grub)
    installed_grub_efi=$(installed_rpms_grub_efi)
    installed_kernel=$(installed_rpms_kernel)

    fixed_rpm_shim        # sets flag fixed_shim
    fixed_rpm_grub        # sets flag fixed_grub
    fixed_rpm_kernel      # sets flag fixed_kernel
    secure_boot_dmesg     # sets flag secure_boot_active_dmesg
    secure_boot_mokutil   # sets flag secure_boot_active_mokutil
    secure_boot_firmware  # sets flag secure_boot_active_firmware
}


draw_conclusions() {
    # Draws conclusions based on available system data.
    #
    # Side effects:
    #     Sets many global boolean flags and content variables

    # All three work the same. They are all used here because relying only on
    # one way of detection might break on some non-standard configurations, e.g.:
    # * all dmesg logging is disabled and the system runs long enough so that dmesg wraps
    # * mokutil on an UEFI system is uninstalled
    # * efivars on an UEFI system is unmounted
    secure_boot_active=$(( secure_boot_active_dmesg || secure_boot_active_mokutil || secure_boot_active_firmware ))

    local flag_installed_shim=0
    local flag_installed_grub=0
    local flag_installed_grub_efi=0
    if [[ "$installed_shim" ]]; then
        flag_installed_shim=1
    fi
    if [[ "$installed_grub" ]]; then
        flag_installed_grub=1
    fi
    if [[ "$installed_grub_efi" ]]; then
        flag_installed_grub_efi=1
    fi

    if (( ! secure_boot_active )); then
        # secure boot is not active -> the vulnerability is less important
        lowvuln=1
        (( result |= 1 ))
    else
        lowvuln=0
    fi
    if (( ( ! flag_installed_shim || fixed_shim ) && fixed_grub && fixed_kernel )); then
        vulnerable=0
        bootproblem=0
        result=0
        reason="Vulnerable package versions not installed."
    elif (( ! flag_installed_grub )); then
        vulnerable=0
        bootproblem=0
        result=0
        reason="This system is not affected because grub2 is not installed."
    elif (( flag_installed_grub && ! flag_installed_grub_efi && fixed_grub )); then
        vulnerable=0
        bootproblem=0
        grubonly=1
        result=0
        reason="Vulnerable package grub2 not installed. This system doesn't use grub2 for UEFI. No other packages listed in the vulnerability article are applicable for this system."
    elif (( flag_installed_grub && ! flag_installed_grub_efi && ! fixed_grub )); then
        vulnerable=1
        bootproblem=0
        grubonly=1
        (( result |= 16 ))
        reason="Vulnerable version of grub2 installed. This system doesn't use grub2 for UEFI. No other packages listed in the vulnerability article are applicable for this system."
    elif (( ( flag_installed_shim && fixed_shim ) || fixed_grub || fixed_kernel )); then
        vulnerable=1
        bootproblem=1
        (( result |= 4 ))
        reason="Only a partial update of the affected packages has been applied."
    else
        vulnerable=1
        bootproblem=0
        (( result |= 8 ))
        reason="Vulnerable versions of the affected packages are installed."
    fi
}


debug_print() {
    # Prints selected variables when debugging is enabled.

    variables=( running_kernel rhel fixed_shim fixed_grub fixed_kernel secure_boot_active_dmesg secure_boot_active_mokutil secure_boot_active_firmware vulnerable bootproblem grubonly result )
    for variable in "${variables[@]}"; do
        echo "$variable = *${!variable}*"
    done
    echo
}


if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    basic_args "$@"
    basic_reqs "CVE-2020-10713"
    running_kernel=$( uname -r )
    check_supported_kernel "$running_kernel"

    rhel=$( get_rhel "$running_kernel" )
    if (( rhel == 5 )); then
        export PATH="/sbin:/usr/sbin:$PATH"
    fi

    set_default_values
    parse_facts
    draw_conclusions

    # Debug prints
    if [[ "$debug" ]]; then
        debug_print
    fi

    echo
    echo "Installed shim:"
    if [[ "$installed_shim" ]]; then
        echo "$installed_shim"
    else
        echo "(applicable shim not installed)"
    fi

    echo "Installed grub2:"
    if [[ "$installed_grub" ]]; then
        echo "$installed_grub"
    else
        echo "(no grub2 installed)"
    fi

    if [[ "$installed_kernel" ]]; then
        echo "Installed kernel:"
        echo "$installed_kernel"
    else
        echo "Running kernel:"
        uname -rsvm
    fi
    echo

    # Results
    if (( vulnerable )); then
        if (( lowvuln )); then
            echo -e "${YELLOW}This system is vulnerable.${RESET}"
        else
            echo -e "${RED}This system is vulnerable.${RESET}"
        fi
        echo
        echo "* $reason"
        if (( lowvuln )); then
            echo "* Secure boot is DISABLED."
        else
            echo "* Secure boot is ENABLED."
        fi
        echo
        echo -e "Update the following packages:"
        echo
        if (( ! fixed_grub )); then
            installed_rpm_names_grub
        fi
        if (( ! grubonly )); then
            if (( ! fixed_shim )); then
                installed_rpm_names_shim
            fi
            if (( ! fixed_kernel )); then
                installed_rpm_names_kernel
            fi
        fi
        echo
        if (( bootproblem && secure_boot_active )); then
            echo -e "${RED}Additionally, the system might be unable to boot correctly in its current configuration.${RESET} To resolve the issue, update all the listed packages."
            echo
        elif (( bootproblem )); then
            echo -e "${YELLOW}Additionally, the system might be unable to boot correctly if Secure boot becomes enabled.${RESET} To resolve the issue, update all the listed packages."
            echo
        fi
        echo -e "For more information about this vulnerability, see:"
        echo -e "${ARTICLE}"

    else
        echo -e "${GREEN}This system is not vulnerable.${RESET}"
        echo
        echo "$reason"
    fi

    exit "$result"
fi
