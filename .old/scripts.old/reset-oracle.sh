#!/bin/bash
docker-compose stop oracle-hc 
docker-compose rm -f oracle-hc 
docker-compose up -d oracle-hc 
