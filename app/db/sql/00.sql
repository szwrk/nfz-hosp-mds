CREATE SCHEMA IF NOT EXISTS hospital AUTHORIZATION sysdwh;
ALTER ROLE sysdwh SET search_path TO hospital, public;