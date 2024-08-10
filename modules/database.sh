#!/bin/bash

# To able to use log_message funcion
source ./modules/utils.sh

# Directory to store all databases
DATABASES_DIR="./databases"


# Function to initialize the databases directory
initialize_databases_dir() {
    if [[ ! -d "$DATABASES_DIR" ]]; then
        mkdir -p "$DATABASES_DIR"
        log_message "Created databases directory: $DATABASES_DIR"
    fi
}

# Function to create a database (directory)
create_database() {
    local db_path="$DATABASES_DIR/$1"

    # Check for empty or invalid database name
    if [[ -z "$1" || ! "$1" =~ ^[a-zA-Z0-9_]+$ ]]; then
        zenity --error --text="Invalid database name! Use only alphanumeric characters and underscores."
        return
    fi

    # Check if the database already exists
    if [[ -d "$db_path" ]]; then
        zenity --error --text="Database '$1' already exists!"
        return
    fi

    mkdir -p "$db_path"
    log_message "Created database: $1"
    zenity --info --text="Database '$1' created successfully."
}

# Function to list databases (directories)
list_databases() {
    ls -d "$DATABASES_DIR"/* 2>/dev/null | sed "s|$DATABASES_DIR/||"
}

# Function to connect to a database (change directory)
connect_to_database() {
    local db_path="$DATABASES_DIR/$1"

    if [[ -d "$db_path" ]]; then
        cd "$db_path"
        table_menu
        cd - > /dev/null
    else
        zenity --error --text="Database does not exist!"
    fi
}

# Function to drop a database (remove directory)
drop_database() {
    local db_path="$DATABASES_DIR/$1"

    if [[ -d "$db_path" ]]; then
        rm -rf "$db_path"
        log_message "Dropped database: $1"
        zenity --info --text="Database '$1' dropped successfully."
    else
        zenity --error --text="Database does not exist!"
    fi
}

# Initialize databases directory
initialize_databases_dir
