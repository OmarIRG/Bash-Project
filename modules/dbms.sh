#!/bin/bash

source ./modules/database.sh
source ./modules/utils.sh
source ./modules/table.sh  # Import table module for table operations

# Function to display the main menu using Zenity
main_menu() {
    while true; do
        choice=$(zenity --list --title="Bash DBMS" --column="Menu Items" --width=300 --height=250 \
            "Create Database" \
            "List Databases" \
            "Connect To Database" \
            "Drop Database" \
            "Exit")

        case $choice in
            "Create Database") create_database_dialog ;;
            "List Databases") list_databases_dialog ;;
            "Connect To Database") connect_database_dialog ;;
            "Drop Database") drop_database_dialog ;;
            "Exit")  ;;
        esac
    done
}


# Function to create a database
create_database_dialog() {
    db_name=$(zenity --entry --title="Create Database" --text="Enter database name:")
    if [[ -n "$db_name" ]]; then
        create_database "$db_name"
    fi
}

# Function to list databases
list_databases_dialog() {
    databases=$(list_databases)
    zenity --info --title="List Databases" --text="$databases" --width=300 --height=250
}

# Function to connect to a database
connect_database_dialog() {
    db_name=$(zenity --entry --title="Connect To Database" --text="Enter database name to connect:")
    if [[ -n "$db_name" ]]; then
        connect_to_database "$db_name"
    fi
}

# Function to drop a database
drop_database_dialog() {
    db_name=$(zenity --entry --title="Drop Database" --text="Enter database name to drop:")
    if [[ -n "$db_name" ]]; then
        drop_database "$db_name"
    fi
}
