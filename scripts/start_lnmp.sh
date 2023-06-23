#!/bin/bash
# start_lnmp.sh
# 2023-06-22 | CR
#
ERROR_MSG=""
cd "`dirname "$0"`" ;
SCRIPTS_DIR="`pwd`" ;

RUN_CMD="$1"

if [ "${ERROR_MSG}" = "" ]; then
	if [ -f "${SCRIPTS_DIR}/.env" ]; then
		echo "Processing ${SCRIPTS_DIR}/.env file..."
		set -o allexport;
		if ! . "${SCRIPTS_DIR}/.env"
		then
			ERROR_MSG="ERROR: could not process .env file."
		fi
		set +o allexport ;
	fi
fi

if [ "${ERROR_MSG}" = "" ]; then
    # Check if Docker and Docker Compose are installed
    if ! command -v docker &> /dev/null || ! command -v docker-compose &> /dev/null; then
        ERROR_MSG="Docker and Docker Compose are required to run this script."
        # exit 1
    fi
fi

if [ "${ERROR_MSG}" = "" ]; then
    # Copy the nginx config file
    if [ ! -d ${BASE_DIR}/nginx-conf ] || [ ! -f ${BASE_DIR}/nginx-conf/default.conf ]; then
        echo "Generating Nginx config file... ${BASE_DIR}/nginx-conf/default.conf"
        mkdir -p ${BASE_DIR}/nginx-conf
        if ! cp ${SCRIPTS_DIR}/nginx-conf/default.conf ${BASE_DIR}/nginx-conf/default.conf
        then
            ERROR_MSG="ERROR: executing cp ${SCRIPTS_DIR}/nginx-conf/default.conf ${BASE_DIR}/nginx-conf/default.conf"
        fi
    fi
fi

if [ "${ERROR_MSG}" = "" ]; then
    # Generate SSL certificate if not already present
    if [ ! -f ${BASE_DIR}/ssl-certs/server.key ] || [ ! -f ${BASE_DIR}/ssl-certs/server.crt ]; then
        echo "Generating self-signed SSL certificate..."

        #Required
        domain="nginx-selfsigned"
        commonname="${domain}"

        #Change to your company details
        country="US"
        state="Pennsylvania"
        locality="Harrisburg"
        organization=${CERT_ORGANIZATION_DOMAIN}
        organizationalunit=IT
        email=info@${CERT_ORGANIZATION_DOMAIN}

        #Optional
        password="dummypassword"


        mkdir -p ${BASE_DIR}/ssl-certs
        # if ! openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${BASE_DIR}/ssl-certs/server.key -out ${BASE_DIR}/ssl-certs/server.crt
        if ! openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${BASE_DIR}/ssl-certs/server.key -out ${BASE_DIR}/ssl-certs/server.crt -passin pass:${password} -subj "/C=${country}/ST=${state}/L=${locality}/O=${organization}/OU=${organizationalunit}/CN=${commonname}/emailAddress=${email}"
        then
            ERROR_MSG="ERROR: running openssl to generate the self-signed SSL certificate"
        fi
    fi
fi

if [ "${ERROR_MSG}" = "" ]; then
    if [ "${RUN_CMD}" == "" ] || [ "${RUN_CMD}" == "run" ]; then
        # Start the containers
        echo "Starting LNMP stack containers..."
        if ! docker-compose up -d
        then
            ERROR_MSG="ERROR: running docker-compose up -d"
        else
            if ! docker ps
            then
                ERROR_MSG="ERROR: docker containers are not running"
            else
                if ! (docker ps | grep lnmp_nginx)
                then
                    ERROR_MSG="ERROR: docker containers are not running"
                else
                    echo ""
                    echo "LNMP stack is now running."
                    echo "Access the website with: https://localhost"
                fi
            fi
        fi
    fi
    if [ "${RUN_CMD}" == "down" ]; then
        echo "Stopping LNMP stack containers..."
        if ! docker-compose down    
        then
            ERROR_MSG="ERROR: running docker-compose down"
        fi
    fi
fi

echo ""
if [ "${ERROR_MSG}" = "" ]; then
    echo "Done!"
else
    echo "${ERROR_MSG}"
fi
echo ""
