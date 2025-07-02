#!/usr/bin/env bash

xcodebuild test \
  -project PapaTube.xcodeproj \
  -scheme PapaTube \
  -destination 'platform=macOS' \
  -only-testing:PapaTubeTests
