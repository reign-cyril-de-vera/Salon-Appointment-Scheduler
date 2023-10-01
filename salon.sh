#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"



# FUNCTIONS

# Get all rows from the services table
GET_SERVICES() {
  local query="SELECT service_id, name FROM services"
  $PSQL "$query"
}

# Function to get service name using service_id
GET_SERVICE_NAME() {
  local service_id="$1"
  local query="SELECT name FROM services WHERE service_id=$service_id"
  $PSQL "$query"
}

# Function to get customer name using customer phone
GET_CUSTOMER_NAME() {
  local phone="$1"
  local query="SELECT name FROM customers WHERE phone='$phone'"
  $PSQL "$query"
}

# Function to get customer_id using customer phone
GET_CUSTOMER_ID() {
  local phone="$1"
  local query="SELECT customer_id FROM customers WHERE phone='$phone'"
  $PSQL "$query"
}

# Function for inserting a new row with name and phone values to customers table
INSERT_NEW_CUSTOMER() {
  local name="$1"
  local phone="$2"
  local query="INSERT INTO customers(name, phone)
               VALUES('$name', '$phone')"
  $PSQL "$query"
}

# Function for inserting a new row with customer_id, service_id, and time values to appointments table
INSERT_APPOINTMENT() {
  local customer_id="$1"
  local service_id="$2"
  local time="$3"
  local query="INSERT INTO appointments(customer_id, service_id, time)
               VALUES('$customer_id', '$service_id', '$time')"
  $PSQL "$query"
}

# Function for exiting the program
EXIT(){
  echo -e "\nThank you for stopping in.\n"
  exit 0
}



# MAIN CODE

# Intro message
echo -e "\n~~~~~ MY SALON ~~~~~\n"


# Loop until user gives a valid input
while true
do
  
  # Show all available services
  echo "Available services:"
  echo "$(GET_SERVICES)" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  

  # Ask for a service to appoint
  echo -e "\nWhich service would you like to make an appointment?"
  echo -e "Type 'q' to exit."
  # read -p "==> " SERVICE_ID_SELECTED
  read SERVICE_ID_SELECTED
  

  # If user wants to exit
  if [[ "$SERVICE_ID_SELECTED" = "q" ]]
  then
    EXIT  # exit the program
  fi


  # If service to appoint is not a valid number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    echo -e "Please enter a valid number.\n"
    continue  # restart the while loop
  else
    SERVICE_NAME=$(GET_SERVICE_NAME "$SERVICE_ID_SELECTED")
  fi


  # If service_id to appoint is not available
  if [[ -z $SERVICE_NAME ]]
  then
    echo -e "That service is not available. Please choose another.\n"
  else
    break  # Valid input, exit the loop
  fi

done


# Ask user for a phone number
echo -e "\nWhat is your phone number?"
# read -p "==> " CUSTOMER_PHONE
read CUSTOMER_PHONE


# Getting customer name from phone number
CUSTOMER_NAME=$(GET_CUSTOMER_NAME "$CUSTOMER_PHONE")


# If customer phone is not present in customers table
if [[ -z $CUSTOMER_NAME ]]
then
  # Asking user for name
  echo -e "\nWhat is your name?"
  # read -p "==> " CUSTOMER_NAME
  read CUSTOMER_NAME

  # Inserting the customer's details to the customers table
  NEW_CUSTOMER=$(INSERT_NEW_CUSTOMER "$CUSTOMER_NAME" "$CUSTOMER_PHONE")
fi


# Getting the customer_id from the customer phone
CUSTOMER_ID=$(GET_CUSTOMER_ID "$CUSTOMER_PHONE")


# Ask user for an appointment time
echo -e "\nWhat time would you like to add an appointment?"
# read -p "==>" SERVICE_TIME
read SERVICE_TIME


# Inserting the appointment details to the appointments table
ADD_APPOINTMENT=$(INSERT_APPOINTMENT "$CUSTOMER_ID" "$SERVICE_ID_SELECTED" "$SERVICE_TIME")

# Message for confirmation to the appointment details
echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed 's/ |/"/') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed 's/ |/"/')."