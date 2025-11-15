# VS Coding Test

A Ruby application that counts files with identical content in a directory, along with SQL query examples and interview documentation.

## Overview

This project demonstrates:
- **File Content Analysis**: Ruby script to find and count files with duplicate content
- **Database Queries**: MySQL query examples for user and book management
- **Interview Documentation**: Technical and general interview answers

## Features

### Content Counter (`test_counter.rb`)

### Database Queries
- User mark aggregation queries (`test-db-1.sql`)
- Latest book per user queries (`test-db-2.sql`)

## Requirements

- Ruby 2.5+ (tested with Ruby 2.7+)
- MySQL (for SQL examples)

## Installation

1. Clone or download this repository
2. Ensure Ruby is installed:
   ```bash
   ruby --version
   ```

## Usage

### Content Counter

**Option 1: Using command-line argument**
```bash
ruby test_counter.rb /path/to/folder
```

**Option 2: Using configuration file**
1. Create a `config.txt` file in the project root
2. Add the path to scan (one line):
   ```
   /path/to/folder
   ```
3. Run the script:
   ```bash
   ruby test_counter.rb
   ```

**Example Output:**
```
abcdef 3
```
This means 3 files contain the content "abcdef", which is the highest duplicate count.

### Database Queries

Execute the SQL files in your MySQL database:
```bash
mysql -u username -p database_name < test-db-1.sql
mysql -u username -p database_name < test-db-2.sql
```

## Project Structure

```
.
├── README.md                 # This file
├── test_counter.rb          # Main Ruby application
├── config.txt               # Configuration file (optional)
├── testfile/                # Sample test files
│   ├── file_a.rb
│   ├── file_b.rb
│   ├── file_c.rb
│   ├── file_d.rb
│   └── file_e.rb
├── test-db-1.sql            # User mark aggregation queries
├── test-db-2.sql            # Latest book per user queries
├── general/                 # General interview answers
│   └── general-answer.md
└── technical/               # Technical interview answers
    └── technical-answer.md
```

## License

This is a coding test project for interview purposes.

