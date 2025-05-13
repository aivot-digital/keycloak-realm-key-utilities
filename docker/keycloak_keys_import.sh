#!/bin/bash
input_file=$1

if [ -z "$input_file" ]; then
    echo "Usage: $0 <input_file>"
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

while IFS= read -r line; do
  component_name=$(echo $line | cut -d "," -f 1)
  component_provider_id=$(echo $line | cut -d "," -f 2)
  component_config_name=$(echo $line | cut -d "," -f 3)
  component_config_value=$(echo $line | cut -d "," -f 4)

  docker compose exec -T $db_container_name psql -U $db_username -d $db_name <<EOF
  update component_config
  set value = '$component_config_value'
  where id = (select CC.id
              from component_config CC
                       join component C on CC.component_id = C.id
                       join realm R on C.realm_id = R.id
              where R.name = '$target_realm'
                and C.name = '$component_name'
                and C.provider_id = '$component_provider_id'
                and C.provider_type = 'org.keycloak.keys.KeyProvider'
                and CC.name = '$component_config_name');
EOF
done < $input_file
