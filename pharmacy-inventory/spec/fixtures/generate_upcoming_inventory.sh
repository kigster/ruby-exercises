#!/usr/bin/env bash
ORDER_DATE_1=$(date -v+1d +'%Y-%m-%dT12:00:00Z')
ORDER_DATE_2=$(date -v+7d +'%Y-%m-%dT12:00:00Z')
ORDER_DATE_3=$(date -v+1m +'%Y-%m-%dT12:00:00')
ORDER_DATE_4=$(date -v+1d +'%Y-%m-%dT12:00:00Z')

cat >upcoming_inventory.json <<EOF
[
  {
    "medication_id": 1,
    "quantity": 30,
    "date": "$ORDER_DATE_1"
  },
  {
    "medication_id": 2,
    "quantity": 5,
    "date": "$ORDER_DATE_2"
  },
  {
    "medication_id": 2,
    "quantity": 10,
    "date": "$ORDER_DATE_3"
  },
  {
    "medication_id": 3,
    "quantity": 100,
    "date": "$ORDER_DATE_4"
  }
]
EOF
