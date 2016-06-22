#!/bin/sh

OUTFILE="plugins.txt"

ESC_SEQ="\033["
COL_RESET="${ESC_SEQ}0m"
COL_GREEN="${ESC_SEQ}1;32m"
COL_CYAN="${ESC_SEQ}36m"

if [ "$#" -ne 1 ]; then
    script=`basename ${0}`
    echo "Usage: ${script} <user:pass@jenkinshost.example.org>"
    exit 1
fi

list=$(curl -sSL "http://${1}/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" | perl -pe 's/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1 \2\n/g'|sed 's/ /:/' | sort -f)
if [ "$?" -ne 0 ] || [ "$list" == "" ]; then
    exit 1
fi

echo "Retrieved plugins:\n${COL_CYAN}${list}${COL_RESET}\n"

read -p "Overwrite ${OUTFILE}? [y/N] " -n 1 -r
echo
if [[ ${REPLY} =~ ^[Yy]$ ]]
then
    echo "${list}" > plugins.txt
    echo "\n${COL_GREEN}Updated ${OUTFILE}${COL_RESET}\n"
else
    exit 1
fi
