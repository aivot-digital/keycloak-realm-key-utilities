This tool is used to export and import keys from Keycloak realms.
It is handy when updating realms or migrating them to another Keycloak instance and wanting to keep the same keys.
Especially useful when dealing with SAML2 Identity Providers like the German BundID or BayernID.

Currently, this project only supports a dockerized PostgreSQL Database containing the Keycloak data.
So run these utilities in the root folder of your docker compose setup for the keycloak database.

# Usage
1. Clone this Repo
   ```bash
   git clone git@github.com:aivot-digital/keycloak-realm-key-utilities.git key_utilities
   ```
2. Make the scripts executable
   ```bash
   chmod +x ./key_utilities/docker/keycloak_keys_export.sh
   chmod +x ./key_utilities/docker/keycloak_keys_import.sh
   ```
3. Run the export script
   ```bash
   ./key_utilities/docker/keycloak_keys_export.sh keys.out
   ```
4. Do your Keycloak stuff
5. Run the import script
   ```bash
   ./key_utilities/docker/keycloak_keys_import.sh keys.out
   ```