# Directory JSON Indexer

A Bash utility that recursively walks a directory tree and generates a per‐directory `index.json` manifest. Each manifest lists:

- **files**: regular files (sorted alphabetically)  
- **directory**: subdirectories (sorted alphabetically)  
- **special_files** & **special_directory**: entries declared in a `_special` file  
- **outer**: relative path back to the root directory

## Features

- **Recursive traversal**: processes all nested subdirectories  
- **Blacklist support**: skip entries listed in a `_blacklist` file  
- **Special entries**: promote files or folders listed in a `_special` file into separate arrays  
- **Deterministic output**: sorts each list alphabetically for consistency  
- **Self‑contained**: pure Bash, zero external dependencies beyond GNU coreutils  
- **Easy integration**: drop into any project tree to auto‑generate JSON indexes  

## Prerequisites

- Bash (≥ 4.0)  
- `realpath`, `grep`, `wc`, `sort` (part of GNU coreutils)  

## Installation

1. Clone or copy the script into your project:  
   ```bash
   curl -O https://example.com/indexer.sh
   chmod +x indexer.sh
