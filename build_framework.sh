#!/bin/bash

# there is a path issue building through Xcode that i cant quite figure out re: ruby so when building from xcode the XCP var is emptied.

if [ "$1" == "NOXCP" ]; then
    XCP=""

else
	# search for 'xcpretty' will make the build output much tinier and easier to read / digest.
	XCP=$(which xcpretty)
	echo $XCP
fi

TARGET=$1

if [ ! -z $TARGET ]; then
    TARGET="-target $TARGET"
fi

# clear previous build folder if it exist
rm -rf build

# build simulator and iphoneos frameworks

# -z checks to see if a value is empty, if xcpretty is not found, build normally, if it is found then use it to clean up our output.
if [ -z $XCP ]; then
    xcodebuild -sdk iphonesimulator $TARGET
    xcodebuild -sdk iphoneos $TARGET
else
    xcodebuild -sdk iphonesimulator $TARGET | $XCP
    xcodebuild -sdk iphoneos $TARGET | $XCP
fi

# keep track of our current working directory
pwd=$(pwd)

# change to the release-iphoneos folder to get the name of the framework (this is to make this script more universal)

pushd build/Release-iphoneos || exit

# find the name of the framework, in our case 'FontAwesomeKit'

for i in $(find * -name "*.framework"); do

    name=${i%\.*}
    echo "$name"

done

# remove the old copy of the xcframework if it already exists

rm -rf ../../"$name".xcframework

# pop back to the FontAwesomeKit folder

popd || exit

# create variables for the path to each respective framework

ios_fwpath=$pwd/build/Release-iphoneos/$name.framework

sim_fwpath=$pwd/build/Release-iphonesimulator/$name.framework

# create the xcframework

xcodebuild -create-xcframework -framework "$ios_fwpath" -framework "$sim_fwpath" -output "$name".xcframework


open $pwd

