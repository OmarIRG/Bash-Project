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
            "Exit") exit 0 ;;
        esac
    done
}
