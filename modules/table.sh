#!/bin/bash

source utils.sh

# Function to display the table menu using Zenity
table_menu() {
    while true; do
        choice=$(zenity --list --title="Table Menu" --column="Menu Items" --width=300 --height=300 \
            "Create Table" \
            "List Tables" \
            "Drop Table" \
            "Insert into Table" \
            "Select From Table" \
            "Delete From Table" \
            "Update Table" \
            "Back to Main Menu")

        case $choice in
            "Create Table") create_table_dialog ;;
            "List Tables") list_tables_dialog ;;
            "Drop Table") drop_table_dialog ;;
            "Insert into Table") insert_into_table_dialog ;;
            "Select From Table") select_from_table_dialog ;;
            "Delete From Table") delete_from_table_dialog ;;
            "Update Table") update_table_dialog ;;
            "Back to Main Menu") break ;;
        esac
    done
}

# Function to create a table
create_table_dialog() {
    table_name=$(zenity --entry --title="Create Table" --text="Enter table name:")
    columns=$(zenity --entry --title="Define Columns" --text="Enter columns (format: col_name:col_type:pk, ...):")
    if [[ -n "$table_name" && -n "$columns" ]]; then
        create_table "$table_name" "$columns"
    fi
}

# Enhanced create table function with data types and primary keys
create_table() {
    table_name=$1
    columns=$2

    # Validate if table already exists
    if [[ -f "$table_name" ]]; then
        zenity --error --text="Table already exists!"
        return
    fi

    # Write columns with metadata to the table file
    echo "$columns" | sed 's/, /|/g' > "$table_name.meta"
    touch "$table_name"
    log_message "Created table: $table_name with columns: $columns"
}

# List tables function
list_tables_dialog() {
    tables=$(list_tables)
    zenity --info --title="List Tables" --text="$tables" --width=300 --height=250
}

# Drop table function
drop_table_dialog() {
    table_name=$(zenity --entry --title="Drop Table" --text="Enter table name to drop:")
    if [[ -n "$table_name" ]]; then
        drop_table "$table_name"
    fi
}

# Insert into table function
insert_into_table_dialog() {
    table_name=$(zenity --entry --title="Insert Into Table" --text="Enter table name:")
    values=$(zenity --entry --title="Insert Values" --text="Enter values (comma-separated):")
    if [[ -n "$table_name" && -n "$values" ]]; then
        insert_into_table "$table_name" "$values"
    fi
}

# Function to select from a table
select_from_table_dialog() {
    table_name=$(zenity --entry --title="Select From Table" --text="Enter table name:")
    if [[ -n "$table_name" ]]; then
        results=$(select_from_table "$table_name")
        zenity --info --title="Select From Table" --text="$results" --width=400 --height=300
    fi
}

# Function to delete from a table
delete_from_table_dialog() {
    table_name=$(zenity --entry --title="Delete From Table" --text="Enter table name:")
    condition=$(zenity --entry --title="Delete Condition" --text="Enter condition:")
    if [[ -n "$table_name" && -n "$condition" ]]; then
        delete_from_table "$table_name" "$condition"
    fi
}

# Function to update a table
update_table_dialog() {
    table_name=$(zenity --entry --title="Update Table" --text="Enter table name:")
    set_clause=$(zenity --entry --title="Set Clause" --text="Enter SET clause:")
    condition=$(zenity --entry --title="Update Condition" --text="Enter condition:")
    if [[ -n "$table_name" && -n "$set_clause" && -n "$condition" ]]; then
        update_table "$table_name" "$set_clause" "$condition"
    fi
}

# List tables function
list_tables() {
    ls -p | grep -v / | grep -v "logfile.txt" | grep -v ".meta"
}

# Drop table function
drop_table() {
    rm -f "$1" "$1.meta"
    log_message "Dropped table: $1"
}

# Insert into table function with data type and primary key validation
insert_into_table() {
    table_name=$1
    values=$2

    # Validate if table exists
    if [[ ! -f "$table_name" ]]; then
        zenity --error --text="Table does not exist!"
        return
    fi

    # Split columns and values into arrays
    IFS='|' read -r -a columns <<< "$(cat "$table_name.meta")"
    IFS=',' read -r -a values <<< "$values"

    # Check primary key constraint
    primary_key_index=$(awk -F '|' '{for (i=1; i<=NF; i++) if ($i ~ /:pk$/) print i}' "$table_name.meta")
    primary_key_value="${values[$primary_key_index-1]}"

    if grep -q "^$primary_key_value," "$table_name"; then
        zenity --error --text="Primary key constraint violated!"
        return
    fi

    # Validate data types
    for i in "${!columns[@]}"; do
        col="${columns[$i]}"
        value="${values[$i]}"

        col_name=$(echo "$col" | cut -d ':' -f 1)
        col_type=$(echo "$col" | cut -d ':' -f 2)

        case "$col_type" in
            int)
                if ! [[ "$value" =~ ^-?[0-9]+$ ]]; then
                    zenity --error --text="Data type error: $value is not an integer!"
                    return
                fi
                ;;
            str)
                if ! [[ "$value" =~ ^[a-zA-Z]+$ ]]; then
                    zenity --error --text="Data type error: $value is not a string!"
                    return
                fi
                ;;
        esac
    done

    # Append the new record
    echo "${values[*]}" >> "$table_name"
    log_message "Inserted into table: $table_name values: ${values[*]}"
}

# Select from table function
select_from_table() {
    table_name=$1

    # Validate if table exists
    if [[ ! -f "$table_name" ]]; then
        zenity --error --text="Table does not exist!"
        return
    fi

    # Display the table contents
    cat "$table_name" | column -s "," -t
}

# Delete from table function
delete_from_table() {
    table_name=$1
    condition=$2

    # Validate if table exists
    if [[ ! -f "$table_name" ]]; then
        zenity --error --text="Table does not exist!"
        return
    fi

    # Delete matching records
    awk -v cond="$condition" 'BEGIN {FS=OFS=","} {if ($0 !~ cond) print $0}' "$table_name" > temp && mv temp "$table_name"
    log_message "Deleted from table: $table_name where: $condition"
}

# Update table function
update_table() {
    table_name=$1
    set_clause=$2
    condition=$3

    # Validate if table exists
    if [[ ! -f "$table_name" ]]; then
        zenity --error --text="Table does not exist!"
        return
    fi

    # Update matching records
    awk -v set_clause="$set_clause" -v cond="$condition" 'BEGIN {FS=OFS=","; split(set_clause, set_arr, "=")} 
    {if ($0 ~ cond) {for (i=1; i<=NF; i++) if ($i ~ set_arr[1]) $i=set_arr[2]}}1' "$table_name" > temp && mv temp "$table_name"
    log_message "Updated table: $table_name set: $set_clause where: $condition"
}

