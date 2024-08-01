#!/bin/bash

# Function to create a database (directory)
create_database() {
    mkdir -p "./$1"
    log_message "Created database: $1"  # log_message function Created in util
}

# Function to list databases (directories)
list_databases() {
    ls -d ./*/ 2>/dev/null | sed 's|^\./||; s|/$||'
}

