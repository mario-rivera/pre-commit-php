#!/usr/bin/env bash

# Bash PHP Mess Detector
# This script fails if the PHP Mess Detector output has the word "ERROR" in it.
# Does not support failing on WARNING AND ERROR at the same time.
#
# Exit 0 if no errors found
# Exit 1 if errors were found
#
# Requires
# - php
#
# Arguments
# - None

# Echo Colors
msg_color_magenta='\e[1;35m'
msg_color_yellow='\e[0;33m'
msg_color_none='\e[0m' # No Color

# Loop through the list of paths to run PHP Mess Detector against
echo -en "${msg_color_yellow}Begin PHP Mess Detector ...${msg_color_none} \n"
phpmd_local_exec="phpmd.phar"
phpmd_command="php $phpmd_local_exec"

# Check vendor/bin/phpunit
phpmd_vendor_command="vendor/bin/phpmd"
phpmd_global_command="phpmd"
if [ -f "$phpmd_vendor_command" ]; then
	phpmd_command=$phpmd_vendor_command
else
    if hash phpmd 2>/dev/null; then
        phpmd_command=$phpmd_global_command
    else
        if [ -f "$phpmd_local_exec" ]; then
            phpmd_command=$phpmd_command
        else
            echo "No valid PHP Mess Detector executable found! Please have one available as either $phpmd_vendor_command, $phpmd_global_command or $phpmd_local_exec"
            exit 1
        fi
    fi
fi

phpmd_files_to_check="${@:2}"
phpmd_args=$1
# Without this escape field, the parameters would break if there was a comma in it
phpmd_command="$phpmd_command $phpmd_args $phpmd_files_to_check"

echo "Running command $phpmd_command"
command_result=`eval $phpmd_command`
if [[ $command_result =~ ERROR ]]
then
    echo -en "${msg_color_magenta}Errors detected by PHP Mess Detector ... ${msg_color_none} \n"
    echo "$command_result"
    exit 1
fi

exit 0
