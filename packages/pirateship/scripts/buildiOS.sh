#!/usr/bin/env bash

git diff --name-only $TRAVIS_COMMIT_RANGE | grep 'packages/pirateship' > /dev/null
PIRATESHIP_CHANGED=$?

if [[ ${PIRATESHIP_CHANGED} == "0" ]]; then
    set -e
    echo 'packages/pirateship has been updated, rebuilding binary'

    # get npm ready and node modules installed so we can init
    gem uninstall cocoapods -x
    gem install cocoapods -v 1.3.1
    pod --version
    pod repo update

    yarn prepare
    yarn ship:init ios

    mkdir -p $HOME/Library/MobileDevice/Provisioning\ Profiles/
    security create-keychain -p travis $KEY_CHAIN
    security default-keychain -s $KEY_CHAIN
    security unlock-keychain -p travis $KEY_CHAIN
    security set-keychain-settings -t 3600 -u $KEY_CHAIN
    yarn ship:add-keys-ios
    security set-key-partition-list -S apple-tool:,apple: -s -k travis $KEY_CHAIN

    # script
    cd ./packages/pirateship/ios/
    if test "$TRAVIS_PULL_REQUEST" = "false" ; then fastlane beta ; else fastlane build ; fi
else
    echo 'build skipped because packages/pirateship was not modified'
    exit 0
fi
