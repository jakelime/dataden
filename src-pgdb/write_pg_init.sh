#!/bin/bash

# load .env
if [ ! -f ".env" ]; then
    echo "EnvironmentVarError(.env not found)."
    exit 1
fi
source .env

# Read the template file
template=$(<init_template.sql)

# Replace environment variables in the template
template=${template//\$\{POSTGRES_DB\}/$POSTGRES_DB}
template=${template//\$\{PGDB_USER1\}/$PGDB_USER1}
template=${template//\$\{PGDB_USER1_PASSWORD\}/$PGDB_USER1_PASSWORD}
template=${template//\$\{PGDB_USER2\}/$PGDB_USER2}
template=${template//\$\{PGDB_USER2_PASSWORD\}/$PGDB_USER2_PASSWORD}

# Write the processed template to the init.sql file
echo "$template" >/docker-entrypoint-initdb.d/init.sql
