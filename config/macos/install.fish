#!/usr/bin/env fish
if test (uname) != Darwin
    exit
end

alias --save airport=/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport
alias --save afk='open -a /System/Library/CoreServices/ScreenSaverEngine.app'
alias --save showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias --save hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

fish_add_path -a /usr/local/sbin /opt/homebrew/bin || true
