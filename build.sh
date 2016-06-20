#!/bin/sh

# Tag name to use
TAG_NAME=konnektid/jenkins

# Utilities
ESC_SEQ="\033["
COL_RESET="${ESC_SEQ}0m"
COL_CYAN="${ESC_SEQ}36m"
COL_UL="${ESC_SEQ}04m"
COL_RED="${ESC_SEQ}1;31m"
COL_GREEN="${ESC_SEQ}1;32m"
COL_GREY="${ESC_SEQ}1;30m" 
ARROW="${COL_CYAN} => ${COL_RESET}"

function must {
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
	echo "${COL_RED} => Failed!${COL_RESET}"
        exit 1;
    fi
}

# Determine Jenkins version to use
echo "${ARROW}Determining Jenkins version"
JENKINS_VERSION=`curl -s https://api.github.com/repos/jenkinsci/jenkins/tags | grep '"name":' | grep -o '[0-9]\.[0-9]*'  | uniq | sort | tail -1`
echo "    ${COL_GREY}Latest is $JENKINS_VERSION${COL_RESET}"

# Build the image
echo "${ARROW}Building image"
must docker build \
	     --no-cache \
             --pull \
             --tag $TAG_NAME:$JENKINS_VERSION .

# Push new tag
echo "${ARROW}Pushing $COL_UL$TAG_NAME:$JENKINS_VERSION$COL_RESET to Docker Hub"
must docker push $TAG_NAME:$JENKINS_VERSION

# Update latest
echo "${ARROW}Updating ${COL_UL}latest${COL_RESET} tag"
must docker tag $TAG_NAME:$JENKINS_VERSION $TAG_NAME:latest && \
must docker push $TAG_NAME:latest

# All done
echo "${COL_GREEN} => All done!${COL_RESET}"
