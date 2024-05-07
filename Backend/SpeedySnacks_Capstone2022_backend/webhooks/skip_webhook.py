import requests
import json

# File will be used to send a mock webhook that we would expect to receive from the Skip API.
# Can use webhook testing site: https://webhook.site/#!/be7c8be5-38ec-425c-b0f4-3ec4c5814735/29836f9f-a5b7-4067-ae3c-46d5a495a228/1
# To run open terminal and type in python .\skip_webhook.py

# ###############################################
# ### URL where POST request will be made to ####
# ###############################################
# webhook_url = 'https://webhook.site/be7c8be5-38ec-425c-b0f4-3ec4c5814735'

# ##################################################################
# # Speedysnacks endpoint for receiving SKIP order notifications ###
####################################################################
#Temporary IP to test, in the future it will be asu.speedysnacks.co to connect to AWS
webhook_url = 'http://192.168.0.9:8000/skipOrderNotification/'


# ################################################################
# ###### Data payload example from SKIP API Documentation ########
# ################################################################
data = {
    "type": "delivery-by-delivery-partner",
    "posLocationId": "cf308849-81cf-4f61-9009-ddc1a808c553",
    "id": "38bbeb45-f520-4438-a44f-0fcdbb29e166",
    "location": {
        "id": 1234,
        "timezone": "Canada/Ottawa"
    },
    "driver": {
        "first_name": "John",
        "last_name": "Smith",
        "phone_number": "555-111-3344"
    },
    "items": [
        {
        "name": "Doritos Tortilla Chips (80g)",
        "description": "",
        "plu": "",
        "price": 210,
        "children": [
            {
            "name": "Bold BBQ",
            "description": "",
            "plu": "",
            "price": 0
            }
        ],
        "notes": ""
        }
    ],
    "created_at": "1675615058",
    "channel": {
        "id": 32,
        "name": "Just Eat"
    },
    "collect_at": "1606780980",
    "collection_notes": "Driver will be wearing a blue shirt",
    "kitchen_notes": "",
    "third_party_order_reference": "51959109103",
    "total": 210,
    "payment_method": "CARD",
    "tender_type": "Flyt",
    "menu_reference": "",
    "payment": {
        "items_in_cart": {
        "inc_tax": 218,
        "tax": 8
        },
        "adjustments": [],
        "final": {
        "inc_tax": 218,
        "tax": 8
        }
    },
    "delivery": {
        "first_name": "Jim",
        "last_name": "Carrey",
        "phone_number": "55555 113 000",
        "line_one": "1609, Kilmaurs Side Road",
        "line_two": "",
        "city": "West Carleton",
        "postcode": "K0A 3M0",
        "email": "JCarrey@email.com",
        "coordinates": {
        "longitude": -97.13560152293131,
        "latitude": 49.898498728223224,
        "longitude_as_string": "-122.2966",
        "latitude_as_string": "49.8984"
        },
        "phone_masking_code": ""
    },
    "extras": {},
    "promotions": [
        {
        "type": "FREE_ITEM_MIN_BASKET",
        "items": [
            {
            "name": "",
            "description": "",
            "plu": "",
            "children": [],
            "price": 0,
            "notes": ""
            }
        ]
        }
    ]
}

# #############################################################
# ### POST request that will send Webhook to specified URL ####
# #############################################################
r = requests.post(webhook_url, data=json.dumps(data), headers={'Content-Type': 'application/json'})
      