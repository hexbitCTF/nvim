#!/bin/bash

# Force the shell to ignore everything and use the system binary
GIT="command git"

if ! $GIT pull origin main; then
    echo "Error: Pull failed."
    exit 1
fi

$GIT add .

if ! $GIT diff-index --quiet HEAD --; then
    $GIT commit -m "Auto-sync: $(date)"
    $GIT push origin main
    echo "Changes synced successfully!"
else
    echo "No changes detected."
fi
