# lnmp_in_docker

# LNMP Stack with Docker

This project sets up an LNMP (Linux, Nginx, MySQL, PHP) stack using Docker containers. It serves a website over HTTPS using a self-signed SSL certificate.

## Requirements

- Docker
- Docker Compose

## Directory Structure

```text
.
 ├── docker-compose.yml
 └── start_lnmp.sh (script to start the LNMP stack)
.
 ├── html
 │ └── ... (your HTML and PHP files)
 ├── mysql-conf
 │ └── ... (your custom MySQL configuration files)
 ├── mysql-data
 │ └── ... (MySQL data directory)
 ├── nginx-conf
 │ └── default.conf (Nginx configuration file)
 ├── ssl-certs
 │ ├── server.crt (SSL certificate)
 │ └── server.key (SSL private key)
```

## Usage

1. Clone this repository or copy the files to your desired directory.

2. copy the `.env-example` file to `.env`:

```bash
cp .env-example .env
```

3. edit the `.env` file. For instance, using `vi`:

```bash
vi .env
```

4. Set the `BASE_DIR` environment variable to the desired base directory path:

```bash
BASE_DIR="/path/to/your/base/directory"
```

4. Set the `MYSQL_*` environment variables. Use your own values... the ones shown here are just example values:

```bash
MYSQL_ROOT_PASSWORD=mysql_root_password
MYSQL_DATABASE=mysql_database
MYSQL_USER=mysql_user
MYSQL_PASSWORD=mysql_password
```

Run the start_lnmp.sh script to start the containers:

```bash
./start_lnmp.sh
```

This script will check for the presence of Docker and Docker Compose, generate a self-signed SSL certificate if it doesn't exist, and start the containers using the docker-compose.yml file in your project directory.

Access your website at https://localhost. Note that web browsers will display a warning about the certificate being untrusted since it's self-signed. To avoid this warning, you can obtain a trusted SSL certificate from a Certificate Authority like Let's Encrypt.

To stop the containers, run:

```bash
docker-compose down
```

## Customization

- Place your HTML and PHP files in the html directory.
- Add custom Nginx configuration files to the nginx-conf directory.
- Add custom MySQL configuration files to the mysql-conf directory.
- The MySQL data is stored in the mysql-data directory, which preserves the data even when the containers are destroyed.
