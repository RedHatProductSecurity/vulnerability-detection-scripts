#!/bin/bash

# Copyright (c) 2022  Red Hat, Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

VERSION="1.0"

# Warning! Be sure to download the latest version of this script from its primary source:

BULLETIN="https://access.redhat.com/security/vulnerabilities/RHSB-2022-001"

# DO NOT blindly trust any internet sources and NEVER do `curl something | bash`!

# This script is meant for simple detection of the vulnerability. Feel free to modify it for your
# environment or needs. For more advanced detection, consider Red Hat Insights:
# https://access.redhat.com/products/red-hat-insights#getstarted

# Checking against the list of vulnerable packages is necessary because of the way how features
# are back-ported to older versions of packages in various channels.


VULNERABLE_VERSIONS=(
    'polkit-0.112-5.ael7b'
    'polkit-0.112-13.p1.el7a'
    'polkit-0.96-2.el6'
    'polkit-0.96-2.el6_0.1'
    'polkit-0.96-5.el6_4'
    'polkit-0.96-7.el6'
    'polkit-0.96-7.el6_6.1'
    'polkit-0.96-11.el6'
    'polkit-0.96-11.el6_10.1'
    'polkit-0.112-1.el7'
    'polkit-0.112-5.el7'
    'polkit-0.112-6.el7_2'
    'polkit-0.112-7.el7_2.2'
    'polkit-0.112-7.el7_2.3'
    'polkit-0.112-7.el7_2'
    'polkit-0.112-9.el7'
    'polkit-0.112-11.el7_3'
    'polkit-0.112-12.el7_3'
    'polkit-0.112-12.el7_4.1'
    'polkit-0.112-14.el7'
    'polkit-0.112-14.el7_5.1'
    'polkit-0.112-17.el7'
    'polkit-0.112-18.el7'
    'polkit-0.112-18.el7_6.1'
    'polkit-0.112-18.el7_6.2'
    'polkit-0.112-22.el7'
    'polkit-0.112-22.el7_7.1'
    'polkit-0.112-26.el7'
    'polkit-0.115-6.el8'
    'polkit-0.115-9.el8'
    'polkit-0.115-9.el8_1.1'
    'polkit-0.115-11.el8'
    'polkit-0.115-11.el8_2.1'
    'polkit-0.115-11.el8_3.2'
    'polkit-0.115-11.el8_4.1'
    'polkit-0.115-12.el8'
)


get_installed_packages() {
    # Checks for installed packages. Compatible with RHEL5.
    #
    # Args:
    #     package_names - an array of package name strings
    #
    # Prints:
    #     Lines with N-V-R.A strings of the installed packages.

    local package_names=( "$@" )

    rpm -qa --queryformat="%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\n" "${package_names[@]}"
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
    GREEN="\\033[1;32m"
    BOLD="\\033[1m"
    RESET="\\033[0m"
    for parameter in "${parameters[@]}"; do
        if [[ "$parameter" == "-h" || "$parameter" == "--help" ]]; then
            echo "Usage: $( basename "$0" ) [-n | --no-colors] [-d | --debug]"
            exit 1
        elif [[ "$parameter" == "-n" || "$parameter" == "--no-colors" ]]; then
            RED=""
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
    if [[ "$running_kernel" != *".el"[6-8]* ]]; then
        echo -e "${RED}This script is meant to be used only on RHEL 6-8.${RESET}"
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
}


parse_facts() {
    # Gathers all available information and stores it in global variables. Only store facts and
    # do not draw conclusion in this function for better maintainability.
    #
    # Side effects:
    #     Sets many global boolean flags and content variables

    result_installed_packages=$( get_installed_packages "polkit" )
}


draw_conclusions() {
    # Draws conclusions based on available system data.
    #
    # Side effects:
    #     Sets many global boolean flags and content variables

    vulnerable_package=$( check_package "$result_installed_packages" "${VULNERABLE_VERSIONS[@]}" )

    if [[ "$vulnerable_package" ]]; then
        result=1
    fi
}


debug_print() {
    # Prints selected variables when debugging is enabled.

    variables=( running_kernel rhel result_installed_packages vulnerable_package result )
    for variable in "${variables[@]}"; do
        echo "$variable = *${!variable}*"
    done
    echo
}


if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    basic_args "$@"
    basic_reqs "CVE-2021-4034"
    running_kernel=$( uname -r )
    check_supported_kernel "$running_kernel"

    rhel=$( get_rhel "$running_kernel" )

    set_default_values
    parse_facts
    draw_conclusions

    # Debug prints
    if [[ "$debug" ]]; then
        debug_print
    fi

    if [[ ! "$result_installed_packages" ]]; then
        echo -e "${GREEN}'polkit' is not installed${RESET}."
        exit 0
    fi

    # Results
    echo -e "Detected 'polkit' package: ${BOLD}$result_installed_packages${RESET}"
    if (( result )); then
        echo -e "${RED}This polkit version is vulnerable.${RESET}"
        echo -e "Follow $BULLETIN for advice."
    else
        echo -e "${GREEN}This polkit version is not vulnerable.${RESET}"
    fi

    exit "$result"
fi
