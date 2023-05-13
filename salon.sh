#!/bin/bash

PSQL="psql -U freecodecamp -d salon -t -X -c"
SERVICES=$($PSQL "SELECT * FROM services")

echo -e "\n~~~~~ MY SALON ~~~~~"


MAIN_MENU() {

if [[ $1 ]]
then
  echo -e "\n$1"
else
  echo -e "\nWelcome to My Salon, how can I help you?\n"
fi

echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
do
  echo "$SERVICE_ID) $SERVICE_NAME"
done
read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
  1) ASK_NUMBER ;;
  2) ASK_NUMBER ;;
  3) ASK_NUMBER ;;
  *) MAIN_MENU "I could not find that service. What would you like today?" ;;
esac

}

ASK_NUMBER() {
echo -e "\nWhat's your phone number?"
read  CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

if [[ -z $CUSTOMER_NAME ]]
then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  CUSTOMER_INSERT_RESULT=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  ASK_SERVICE_TIME
else
  ASK_SERVICE_TIME
fi
}

ASK_SERVICE_TIME() {
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo -e "\nWhat time would you like your $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
  read SERVICE_TIME
  MAKE_APPOINTMENT
}

MAKE_APPOINTMENT() {
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  APPOINTMENT_INSERT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
}


MAIN_MENU