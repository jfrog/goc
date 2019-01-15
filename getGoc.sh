#!/bin/bash

GOC_OS="na"
GOC_UNAME="na"

if [ $# -eq 0 ]
  then
	VERSION=\$latest
	echo "Downloading the latest version of GOC..."
  else
	VERSION=$1
	echo "Downloading version $1 of GOC..."
fi

if $(echo "${OSTYPE}" | grep -q msys); then
    GOC_OS="windows"
    URL="https://api.bintray.com/content/jfrog/goc/${VERSION}/goc-windows-amd64/goc.exe?bt_package=goc-windows-amd64"
    FILE_NAME="goc.exe"
elif $(echo "${OSTYPE}" | grep -q darwin); then
    GOC_OS="mac"
    URL="https://api.bintray.com/content/jfrog/goc/${VERSION}/goc-mac-386/goc?bt_package=goc-mac-386"
    FILE_NAME="goc"
else
    GOC_OS="linux"
    if $(uname -m | grep -q 64); then
        GOC_UNAME="64"
        URL="https://api.bintray.com/content/jfrog/goc/${VERSION}/goc-linux-amd64/goc?bt_package=goc-linux-amd64"
        FILE_NAME="goc"
    else
        GOC_UNAME="32"
        URL="https://api.bintray.com/content/jfrog/goc/${VERSION}/goc-linux-386/goc?bt_package=goc-linux-386"
        FILE_NAME="goc"
    fi
fi

curl -XGET "$URL" -L -k > $FILE_NAME
chmod u+x $FILE_NAME