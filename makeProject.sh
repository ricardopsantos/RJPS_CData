#!/bin/bash

clear

displayCompilerInfo() {
    printf "\n"
    printf "\n"
    echo -n "### Current Compiler"
    printf "\n"
    eval xcrun swift -version
    eval xcode-select --print-path
}

################################################################################

echo "### Brew"
echo " [1] : Install"
echo " [2] : Update"
echo " [3] : Skip"
echo -n "Option? "
read option
case $option in
    [1] ) /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" ;;
    [2] ) eval brew update ;;
   *) echo "Ignored...."
;;
esac

################################################################################

printf "\n"

echo "### Xcodegen"
echo " [1] : Install"
echo " [2] : Upgrade"
echo " [3] : No/Skip"
echo -n "Option? "
read option
case $option in
    [1] ) brew install xcodegen ;;
    [2] ) brew upgrade xcodegen ;;
   *) echo "Ignored...."
;;
esac

################################################################################

displayCompilerInfo

printf "\n"
printf "\n"

################################################################################

echo "### Clean DerivedData?"
echo " [1] : Yes"
echo " [2] : No/Skip"
echo -n "Option? "
read option
case $option in
    [1] ) rm -rf ~/Library/Developer/Xcode/DerivedData/* ;;
   *) echo "Ignored...."
;;
esac

################################################################################

printf "\n"
printf "\n"

echo "### Perform Xcodegen?"
echo " [1] : Yes"
echo " [2] : No/Skip"
echo -n "Option? "
read option
case $option in
    [1] ) xcodegen -s ./XcodeGen/iOSSampleApp.yml -p ./ ;;
   *) echo "Ignored...."
;;
esac

################################################################################

echo "Opening project...."
open iOSSampleApp.xcodeproj

################################################################################

echo "Generating graphviz...."
cd XcodeGen
xcodegen dump --spec ./iOSSampleApp.yml --type graphviz --file ../_Documents/Graph.viz
xcodegen dump --spec ./iOSSampleApp.yml --type json     --file ../_Documents/Graph.json

################################################################################

echo " ╔═══════════════════════╗"
echo " ║ Done! You're all set! ║"
echo " ╚═══════════════════════╝"
