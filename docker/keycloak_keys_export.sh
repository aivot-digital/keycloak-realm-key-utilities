#!/bin/bash
output_file=$1

if [ -z "$output_file" ]; then
    echo "Usage: $0 <output_file>"
    exit 1
fi

read -p "Name of the Database Container [keycloak_database]: " db_container_name
read -p "Username for Database [keycloak]: " db_username
read -p "Name of the Database [keycloak]: " db_name
read -p "Target Realm [customer]: " target_realm

if [ -z "$db_container_name" ]; then
    db_container_name="keycloak_database"
fi

if [ -z "$db_username" ]; then
    db_username="keycloak"
fi

if [ -z "$db_name" ]; then
    db_name="keycloak"
fi

if [ -z "$target_realm" ]; then
    target_realm="customer"
fi

docker compose exec -T $db_container_name psql -U $db_username -d $db_name -t -A -F "," > $output_file <<EOF
select C.name, C.provider_id, CC.name, CC.value
from realm as R
         join component C on R.id = C.realm_id
         join component_config CC on C.id = CC.component_id
where R.name = '$target_realm'
  and C.provider_type = 'org.keycloak.keys.KeyProvider'
  and (CC.name = 'privateKey' or CC.name = 'certificate');
EOF

echo Keys have been exported to $output_file