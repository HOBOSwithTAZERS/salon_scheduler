#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  echo -e "\nWelcome to our salon, what service are you interested in?"
  SERVICES=$($PSQL "SELECT * FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  # get service id
  read SERVICE_ID_SELECTED

  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  # if input doesn't exist
  if [[ -z $SERVICE_ID ]]
  then
    # return to main menu
    MAIN_MENU "Please select a valid service number."
  
  else
    # get customer phone number
    echo -e "\nWhat is your phone number?"
    read CUSTOMER_PHONE
    
    CUSTOMER_PHONE_NUMBER=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")

    #check if customer exists
    if [[ -z $CUSTOMER_PHONE_NUMBER ]]
    then
      #get customer info
      echo -e "\nWhat is your name?"
      read CUSTOMER_NAME

      #insert customer info
      INSERT_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

    fi

    # get customer id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    # get service time
    echo -e "\nWhat time would you like your appointment?"
    read SERVICE_TIME

    
    # insert appointment
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

    SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID")
    
    
    echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  fi

}

MAIN_MENU