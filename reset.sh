#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

# Remove all values from the customers and appointments table
TRUNCATE_CUSTOMERS_APPOINTMENTS(){
  local query="TRUNCATE customers, appointments"
  $PSQL "$query"
}

# Restart customer_id SERIES
RESTART_SERIES_CUSTOMER_ID(){
  local query="ALTER SEQUENCE customers_customer_id_seq RESTART WITH 1"
  $PSQL "$query"
}

# Restart appointment_id SERIES
RESTART_SERIES_APPOINTMENT_ID(){
  local query="ALTER SEQUENCE appointments_appointment_id_seq RESTART WITH 1"
  $PSQL "$query"
}

TRUNCATE_CUSTOMERS_APPOINTMENTS
RESTART_SERIES_CUSTOMER_ID
RESTART_SERIES_APPOINTMENT_ID