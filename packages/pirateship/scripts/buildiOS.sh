#!/usr/bin/env bash

git diff --name-only $TRAVIS_COMMIT_RANGE | grep 'packages/pirateship' > /dev/null
PIRATESHIP_CHANGED=$?

if [[ ${PIRATESHIP_CHANGED} == "0" ]]; then
    set -e
    echo 'packages/pirateship has been updated, rebuilding binary'

    mkdir -p $HOME/Library/MobileDevice/Provisioning\ Profiles/
    security create-keychain -p travis $KEY_CHAIN
    security default-keychain -s $KEY_CHAIN
    security unlock-keychain -p travis $KEY_CHAIN
    security set-keychain-settings -t 3600 -u $KEY_CHAIN
    DISTRIBUTION_CERT_PASS="$DISTRIBUTION_CERT_PASS" FASTLANE_PASSWORD="$FASTLANE_PASSWORD" FASTLANE_USER="$FASTLANE_USER" yarn add-keys-ios
    security set-key-partition-list -S apple-tool:,apple: -s -k travis $KEY_CHAIN

    # script
    cd ./ios/
    if test "$TRAVIS_PULL_REQUEST" = "false" ; then fastlane beta ; else fastlane build ; fi
else
    echo 'build skipped because packages/pirateship was not modified'
    exit 0
fi
