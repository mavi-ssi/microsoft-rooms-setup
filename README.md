# RCBC EDB DOCUMENTATION REPO

This repository acts as documentation for the integration of RCBC's EDB PostgreSQL database. This document records various system integration processes such as artifact testing, troubleshooting, and MOP generation. It is created and maintained by SSI using mkdocs.

## How to View

### Using Virtual Environments (Recommended)
1. Install Python
2. Run `python -m venv .venv`
3. Run `source .venv/bin/activate`
4. Run `pip install -r requirements.txt`
5. Run `mkdocs serve`
6. Once done, run `deactivate`

### Using mkdocs
1. Install mkdocs
    - Using pip, run `pip install mkdocs`
2. Run `mkdocs serve`

### (ADVANCED - For Windows Only) - Generate Offline HTML or PDF
1. Install [GTK-for-Windows-Runtime-Environment-Installer](https://github.com/tschoonj/gtk-for-windows-runtime-environment-installer/releases)
2. Install mkdocs OR activate python venv
3. Run `build_docs.ps1 <options>`
    - `-all`: generate html and pdf files
    - `-html`: generate html files only
    - `-pdf`: generate light and dark themed pdfs
    - `-pdf -light`: generate light themed pdf only
    - `-pdf -dark`: generate dark themed pdf only