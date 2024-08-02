# Bash-Project

# Bash Shell Script Database Management System (DBMS)

## Project Description

The Project aims to develop a DBMS that will enable users to store and retrieve data from the hard disk.

## Features

The application is a CLI menu-based app that provides the following menu items:

### Main Menu

- Create Database
- List Databases
- Connect To Database
- Drop Database

### Database Menu

Upon user connection to a specific database, a new screen with the following menu appears:

- Create Table
- List Tables
- Drop Table
- Insert into Table
- Select From Table
- Delete From Table
- Update Table

## Hints

- The database is stored as a directory in the `databases` folder.
- The selection of rows is displayed on the screen/terminal in an accepted/good format.
- Ask about column data types when creating a table and check them in both insert and update.
- Ask about the primary key when creating a table and check for it in the insert into table.

## Bonus

- Make the app accept SQL code or use a GUI instead of the above menu-based interface.

## How to Run


```bash
chmod +x main.sh modules/*.sh
./main.sh

