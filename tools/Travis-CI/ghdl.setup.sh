#! /bin/bash

# configure variables in the section below
GHDL_BACKEND="llvm"
GHDL_VERSION="0.34dev"
RELEASE_DATE="2016.04.20"

GITHUB_SERVER="https://github.com"
GITHUB_SLUG="Paebbels/ghdl"

TRAVIS_DIR="temp/Travis-CI"


# assemble the GitHub URL
# --------------------------------------
# example: v0.34dev-2016.04.19
GITHUB_TAGNAME="v$GHDL_VERSION-$RELEASE_DATE"

# example: ghdl-llvm-0.34dev.tar.gz
GITHUB_RELEASE_FILE="ghdl-$GHDL_BACKEND-$GHDL_VERSION.tar.gz"

# example: https://github.com/Paebbels/ghdl/releases/download/v0.34dev-2016.04.19/ghdl-llvm-0.34dev.tar.gz
GITHUB_URL="$GITHUB_SERVER/$GITHUB_SLUG/releases/download/$GITHUB_TAGNAME/$GITHUB_RELEASE_FILE"


# other variables
# --------------------------------------
GITROOT=$(pwd)
POCROOT=$(pwd)
GHDL_TARBALL="ghdl.tar.gz"

# define color escape codes
RED='\e[0;31m'			# Red
GREEN='\e[1;32m'		# Green
YELLOW='\e[1;33m'		# Yellow
MAGENTA='\e[1;35m'	# Magenta
CYAN='\e[1;36m'			# Cyan
NOCOLOR='\e[0m'			# No Color


echo -e "${MAGENTA}========================================${NOCOLOR}"
echo -e "${MAGENTA}     Downloading and installing GHDL    ${NOCOLOR}"
echo -e "${MAGENTA}========================================${NOCOLOR}"
echo -e "${CYAN}mkdir -p $TRAVIS_DIR${NOCOLOR}"
mkdir -p $TRAVIS_DIR
cd $TRAVIS_DIR

# downloading GHDL
echo -e "${CYAN}Downloading ghdl.tar.gz from $GITHUB_URL...${NOCOLOR}"
wget -q --show-progress $GITHUB_URL -O $GHDL_TARBALL
if [ $? -eq 0 ]; then
	echo -e "${GREEN}Download [SUCCESSFUL]${NOCOLOR}"
else
	echo 1>&2 -e "${RED}Download of $GITHUB_RELEASE_FILE [FAILED]${NOCOLOR}"
	exit 1
fi

# unpack GHDL
if [ -e $GHDL_TARBALL ]; then
	echo -e "${CYAN}Unpacking $GHDL_TARBALL... ${NOCOLOR}"
	tar -xzf ghdl.tar.gz
	if [ $? -eq 0 ]; then
		echo -e "${GREEN}Unpack [SUCCESSFUL]${NOCOLOR}"
	else
		echo 1>&2 -e "${RED}Unpack [FAILED]${NOCOLOR}"
		exit 1
	fi
fi

# remove downloaded files
rm $GHDL_TARBALL

# test ghdl version
echo -e "${CYAN}Testing GHDL version...${NOCOLOR}"
./bin/ghdl -v
if [ $? -eq 0 ]; then
	echo -e "${GREEN}GHDL test [SUCCESSFUL]${NOCOLOR}"
else
	echo 1>&2 -e "${RED}GHDL test [FAILED]${NOCOLOR}"
	exit 1
fi
