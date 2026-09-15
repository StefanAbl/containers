CREATE USER "sample_user"@"localhost" IDENTIFIED BY "sample_password";
CREATE DATABASE syncstorage_rs;
CREATE DATABASE tokenserver_rs;

GRANT ALL PRIVILEGES on syncstorage_rs.* to sample_user@localhost;
GRANT ALL PRIVILEGES on tokenserver_rs.* to sample_user@localhost;
