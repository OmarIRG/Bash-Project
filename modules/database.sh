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

# Function to connect to a database (change directory)
connect_to_database() {
    if [[ -d "./$1" ]]; then
        cd "./$1"
        table_menu
        cd ..
    else
        dialog --msgbox "Database does not exist!" 8 40
    fi
}

# Function to drop a database (remove directory)
drop_database() {
    rm -rf "./$1"
    log_message "Dropped database: $1"
}
