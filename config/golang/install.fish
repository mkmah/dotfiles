#!/usr/bin/env fish
set -Ux GOPATH $GO_DIR
fish_add_path -a $GOPATH/bin /usr/local/go/bin

if command -qs go
    go install github.com/go-delve/delve/cmd/dlv@latest
end

alias --save gmt='go mod tidy'
alias --save grm='go run ./...'
