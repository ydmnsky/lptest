#!bin/bash
docker network create testnetwork

docker run --name some-postgres \
--network testnetwork \
-e POSTGRES_USER="admin" \
-e POSTGRES_PASSWORD="1234" \
-e POSTGRES_DB="postgres" \
-p 5432:5432/udp \
-p 5432:5432/tcp \
-d postgres

docker exec some-postgres psql -h localhost postgres -U admin -c "CREATE TABLE IF NOT EXISTS \"User\"(\"UserID\" SERIAL PRIMARY KEY, \"FullName\" VARCHAR(255), \"Login\" VARCHAR(255), \"HashPassword\" VARCHAR(255), \"Email\" VARCHAR(255), \"PhoneNumber\" VARCHAR(255));"
docker exec some-postgres psql -h localhost postgres -U admin -c "CREATE TABLE IF NOT EXISTS \"Permission\"(\"PermissionID\" SERIAL PRIMARY KEY, \"Name\" VARCHAR(255));"
docker exec some-postgres psql -h localhost postgres -U admin -c "CREATE TABLE IF NOT EXISTS \"UserPermission\"(\"UserPermissionID\" SERIAL PRIMARY KEY, \"UserID\" INT REFERENCES \"User\"(\"UserID\"), \"PermissionID\" INT REFERENCES \"Permission\"(\"PermissionID\"));"
docker exec some-postgres psql -h localhost postgres -U admin -c "INSERT INTO \"User\"(\"FullName\", \"Login\", \"HashPassword\", \"Email\", \"PhoneNumber\") VALUES('Yar Domansky', 'ydmnsky', 'hashedpassword', 'y@dmnsky.ru', '1234567890');"
docker exec some-postgres psql -h localhost postgres -U admin -c "INSERT INTO \"Permission\"(\"Name\") VALUES('Read');"
docker exec some-postgres psql -h localhost postgres -U admin -c "INSERT INTO \"Permission\"(\"Name\") VALUES('Write');"
docker exec some-postgres psql -h localhost postgres -U admin -c "INSERT INTO \"UserPermission\"(\"UserID\", \"PermissionID\") SELECT u.\"UserID\", p.\"PermissionID\" FROM \"User\" u CROSS JOIN \"Permission\" p WHERE u.\"Login\" = 'ydmnsky' AND p.\"Name\" = 'Read';"
docker exec some-postgres psql -h localhost postgres -U admin -c "INSERT INTO \"UserPermission\"(\"UserID\", \"PermissionID\") SELECT u.\"UserID\", p.\"PermissionID\" FROM \"User\" u CROSS JOIN \"Permission\" p WHERE u.\"Login\" = 'ydmnsky' AND p.\"Name\" = 'Write';"

docker run --name myflaskappcontainer \
--network testnetwork \
-e DATABASE_NAME=postgres \
-e DATABASE_USER=admin \
-e DATABASE_PASSWORD=1234 \
-e DATABASE_HOST=some-postgres \
-e DATABASE_PORT=5432 \
-p 5000:5000/tcp \
-d webserver
