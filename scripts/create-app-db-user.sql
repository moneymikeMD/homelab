-- Create a dedicated user for pocketid
CREATE USER pocketid WITH PASSWORD 'bao-GIORGIO-jill1!';

-- Create a dedicated database for pocketid
CREATE DATABASE pocketid WITH OWNER pocketid;

-- Grant all privileges on the database to the user
GRANT ALL PRIVILEGES ON DATABASE pocketid TO pocketid;