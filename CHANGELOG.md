# CHANGELOG

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/) and [Keep a Changelog](http://keepachangelog.com/).



## Unreleased
---

### New

### Changes

### Fixes

### Breaks


## 0.1.1 (2023-06-28)

### New
Set the mysql backup/restore directory.

### Changes
Docker-compose up as daemon -d.
Docker-compose down with --remove-orphans.
Mysql container uses mysql:5.6 instead of 5.7 to avoid restore error: Invalid default value for 'scheduled_date_gmt'.


## 0.1.0 (2023-06-22)

### New
Initial development for a containerized LNMP stack to have a local dev and test environment.