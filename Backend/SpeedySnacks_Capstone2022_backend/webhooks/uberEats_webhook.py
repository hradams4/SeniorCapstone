import requests
import json

# File will be used to send a mock webhook that we would expect to receive from the Uber Eats API.
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
webhook_url = 'http://192.168.0.9:8000/uberEatsOrderNotification/'


# ################################################################
# ###### Data payload example from SKIP API Documentation ########
# ################################################################
data = {
  "id": "f9f363d1-e1c2-4595-b477-c649845bc953",
  "display_id": "BC953",
  "external_reference_id": "Order-123",
  "current_state": "CREATED",
  "store": {
    "id": "c7f1dc2f-fabe-4997-845c-cad26fdcb894",
    "name": "Harry's Corner",
    "external_reference_id": "HARRY_123",
    "integrator_store_id": "Store123456ABC",
    "integrator_brand_id": "Brand123",
    "merchant_store_id": "HARRY_123"
  },
  "eater": {
    "first_name": "Johnny",
    "phone": "+1 555-555-5555",
    "phone_code": "555 55 555"
  },
  "eaters": [
    {
      "id": "63578c8b-9cd2-4c4f-91fc-315f575e6a78",
      "first_name": "Johnny",
    }
  ],
  "cart": {
    "items": [
      {
        "id": "Doritos Tortilla Chips (80g)",
        "instance_id": "Dorito's-Instance",
        "title": "Dorito's",
        "external_data": "External data for dorito's",
        "quantity": 1,
        "price": {
          "unit_price": {
            "amount": 218,
            "currency_code": "USD",
            "formatted_amount": "$2.18"
          },
          "total_price": {
            "amount": 218,
            "currency_code": "USD",
            "formatted_amount": "$2.18"
          },
          "base_unit_price": {
            "amount": 210,
            "currency_code": "USD",
            "formatted_amount": "$2.10"
          },
          "base_total_price": {
            "amount": 210,
            "currency_code": "USD",
            "formatted_amount": "$2.10"
          },
          "taxInfo": {
            "labels": [
              "",
              ""
            ]
          }
        },
        "selected_modifier_groups": [
          {
            "id": "Choose-flavor",
            "title": "Choose flavor",
            "external_data": "External data for Dorito flavor choice",
            "selected_items": [
              {
                "id": "Bold-BBQ",
                "title": "Bold BBQ",
                "external_data": "External data for Bold-BBQ flavor",
                "quantity": 1,
                "price": {
                  "unit_price": {
                    "amount": 0,
                    "currency_code": "USD",
                    "formatted_amount": "$0.00"
                  },
                  "total_price": {
                    "amount": 0,
                    "currency_code": "USD",
                    "formatted_amount": "$0.0"
                  },
                  "base_unit_price": {
                    "amount": 0,
                    "currency_code": "USD",
                    "formatted_amount": "$0.0"
                  },
                  "base_total_price": {
                    "amount": 0,
                    "currency_code": "USD",
                    "formatted_amount": "$0.00"
                  }
                },
                "default_quantity": 0
              }
            ],
            "removed_items": 'null'
          }
        ],
        "eater_id": "63578c8b-9cd2-4c4f-91fc-315f575e6a78"
      },
    ],
    "fulfillment_issues": [
      {
        "fulfillment_issue_type": "OUT_OF_ITEM",
        "fulfillment_action_type": "REMOVE_ITEM",
        "root_item": {
          "id": "Dorito's",
          "instance_id": "Dorito-Instance",
          "title": "Doritos Tortilla Chips (80g)",
          "external_data": "External data for doritos",
          "quantity": 1,
          "fulfillment_action": {
            "fulfillment_action_type": "REMOVE_ITEM"
          }
        },
        "item_availability_info": {
          "items_requested": 1,
          "items_available": 0
        }
      },
    ]
  },
  "payment": {
    "charges": {
      "total": {
        "amount": 210,
        "currency_code": "USD",
        "formatted_amount": "$2.10"
      },
      "sub_total": {
        "amount": 210,
        "currency_code": "USD",
        "formatted_amount": "$2.10"
      },
      "tax": {
        "amount": 8,
        "currency_code": "USD",
        "formatted_amount": "$0.08"
      },
      "total_fee": {
        "amount": 218,
        "currency_code": "USD",
        "formatted_amount": "$2.18"
      },
      "cash_amount_due": {
        "amount": 218,
        "currency_code": "USD",
        "formatted_amount": "$2.18"
      }
    },
    "accounting": {
      "taxRemittance": {
        "tax": {
          "uber": [
            {
              "value": {
                "amount": 53,
                "currencyCode": "USD",
                "formattedAmount": "$0.53"
              }
            }
          ],
          "restaurant": "",
          "courier": "",
          "eater": ""
        },
        "totalFeeTax": "",
        "deliveryFeeTax": "",
        "smallOrderFeeTax": ""
      },
      "tax_reporting": {
        "breakdown": {
          "items": [
            {
              "description": "ITEM",
              "gross_amount": {
                "amount": 218,
                "currency_code": "USD",
                "formatted_amount": "$2.18"
              },
              "instance_id": "Dorito-Instance",
              "net_amount": {
                "amount": 218,
                "currency_code": "USD",
                "formatted_amount": "$2.18"
              },
              "taxes": [
                {
                  "calculated_tax": {
                    "amount": 8,
                    "currency_code": "USD",
                    "formatted_amount": "$0.08"
                  },
                  "imposition": {
                    "description": "General Sales and Use Tax",
                    "name": "Sales and Use Tax"
                  },
                  "is_inclusive": "false",
                  "jurisdiction": {
                    "level": "STATE",
                    "name": "PENNSYLVANIA"
                  },
                  "rate": "0.06",
                  "tax_remittance": "UBER",
                  "taxable_amount": {
                    "amount": 210,
                    "currency_code": "USD",
                    "formatted_amount": "$2.10"
                  }
                }
              ],
              "total_tax": {
                "amount": 8,
                "currency_code": "USD",
                "formatted_amount": "$0.08"
              }
            },
          ]
        },
        "destination": {
          "country_iso2": "US",
          "id": "390170000",
          "postal_code": "18966"
        },
        "origin": {
          "country_iso2": "US",
          "id": "390170000",
          "postal_code": "19053"
        }
      }
    }
  },
  "placed_at": "2019-05-14T15:16:54-05:00",
  "estimated_ready_for_pickup_at": "2019-05-14T15:36:54-05:00",
  "type": "DELIVERY_BY_UBER",
  "brand": "UBER_EATS",
  "order_manager_client_id": "_ZIpOrYABMOFy3-igFpdeREBos1DZ",
  "deliveries": [
    {
      "id": "65d700da-1e9d-41a7-a304-d0fdcd12b2e4",
      "first_name": "Bruce",
      "vehicle": {
        "make": "Uber",
        "model": "Bicycle",
        "license_plate": "BICYCLE"
      },
      "picture_url": "https://www.example.com/picture_url",
      "estimated_pickup_time": "2019-05-14T15:38:45-05:00",
      "current_state": "ARRIVED_AT_PICKUP",
      "phone": "+13127666835",
      "phone_code": "31023259"
    }
  ]
}

# #############################################################
# ### POST request that will send Webhook to specified URL ####
# #############################################################
r = requests.post(webhook_url, data=json.dumps(data), headers={'Content-Type': 'application/json'})
      