from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
import json
from .models import Orders, Products, ModifiersIdentifiers
import datetime
from django.utils.timezone import make_aware
from django.http import HttpResponse
# from channels import Group
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
# from channels.auth import channel_session_user_from_http

#######################################################
# parses data from SKIP webhook order notification
#######################################################
@csrf_exempt
def skipOrderNotification(request):

    ###################################################
    # Grabs data from SKIP webhook order notification
    ###################################################
    if request.method == 'POST':
        data = json.loads(request.body)
        
        print('\n ********************************** \n Incoming order request from SKIP!! \n ********************************** \n')
        print (data)
        # print('')
    
        ###################################################
        # Adds data to database through the model.
        ###################################################
        order = Orders()
        order.delivery_co = 'Skip the Dishes'
        order.customer_name = data['delivery']['first_name']
        order.delivery_order_id = data['third_party_order_reference']
        order.status = 'INCOMING'
        
        ##############################################
        ###### Turn UNIX Timestamp to date time ######
        ##############################################
        unix_time_stamp = int(data['collect_at'])
        order.order_date = make_aware(datetime.datetime.fromtimestamp(unix_time_stamp))
        
        order.line_item = "None" # not in webhook
        order.item_name = data['items'][0]['name']
        
        ##############################################
        ############ Find Product ID  ################
        ##############################################
        productID = Products.objects.filter(name=order.item_name).values_list('id', flat=True)
        order.product_id = productID # not in webhook
        
        order.modifier = data['items'][0]['children'][0]['name']
        
        ##############################################
        ############ Find Modifier ID  ################
        ##############################################
        modifierID = ModifiersIdentifiers.objects.filter(identifier=order.modifier).values_list('modifier_id', flat=True)[0]
        order.modifier_id = modifierID
        
        order.quantity = 1.00 # not in webhook
        order.price = data['items'][0]['price'] / 100
        order.cost = data['payment']['final']['inc_tax'] / 100
        order.hst = 5 # no idea what this is & not in webhook
        order.pst = 0 # no idea what this is & not in webhook
        order.store_id = data['posLocationId']
        order.imported_on = datetime.datetime.now()
        order.save()
        print('\n ********************* \n Successfully received \n ********************* \n')

        ##############################################################
        #### Sends instant notification when an order is received ####
        ##############################################################
        channel_layer = get_channel_layer()
        async_to_sync(channel_layer.group_send)('frontend_notifications', {'type': 'webhook.notification', 'message': data})

        #automatically accept order and is being processed
        # return HttpResponse(status=200)

        # if order is pending and not being processed, Pending state will fail after 5 minutes on FLYT end
        # must notify FLYT through the update order status endpoint.
        return HttpResponse(status=202)
    
        # if order cannot be processed
        # return HttpResponse(status=400)

#######################################################
# parses data from Uber Eats webhook order notification
#######################################################      
@csrf_exempt
def uberEatsOrderNotification(request):

    ###################################################
    # Grabs data from SKIP webhook order notification
    ###################################################
    if request.method == 'POST':
        data = json.loads(request.body)
        
        print('\n ********************************** \n Incoming order request from SKIP!! \n ********************************** \n')
        print (data)
        # print('')
    
        ###################################################
        # Adds data to database through the model.
        ###################################################
        order = Orders()
        order.delivery_co = 'Uber Eats'
        order.customer_name =data['eater']['first_name']
        order.delivery_order_id = data['id']
        order.status = 'INCOMING'
        order.order_date = data['placed_at']
        
        order.line_item = "None" # not in webhook
        order.item_name = data['cart']['items'][0]['id']
        
        ##############################################
        ############ Find Product ID  ################
        ##############################################
        productID = Products.objects.filter(name=order.item_name).values_list('id', flat=True)
        order.product_id = productID # not in webhook
        
        order.modifier = data['cart']['items'][0]['selected_modifier_groups'][0]['selected_items'][0]['title']
        
        ##############################################
        ############ Find Modifier ID  ###############
        ##############################################
        modifierID = ModifiersIdentifiers.objects.filter(identifier=order.modifier).values_list('modifier_id', flat=True)[0]
        order.modifier_id = modifierID
        
        order.quantity = data['cart']['items'][0]['quantity']
        order.price = data['cart']['items'][0]['price']['base_unit_price']['amount'] / 100
        order.cost = data['cart']['items'][0]['price']['unit_price']['amount'] / 100
        order.hst = 5 # no idea what this is & not in webhook
        order.pst = 0 # no idea what this is & not in webhook
        order.store_id = data['store']['id']
        order.imported_on = datetime.datetime.now()
        
        ###############################################
        ############ Saves order to DB  ###############
        ###############################################
        # order.save()
        
        print('\n ********************* \n Successfully received \n ********************* \n')
        
        ##############################################################
        #### Sends instant notification when an order is received ####
        ##############################################################
        channel_layer = get_channel_layer()
        async_to_sync(channel_layer.group_send)('frontend_notifications', {'type': 'webhook.notification', 'message': data})

        #automatically accept order and is being processed
        # return HttpResponse(status=200)

        # if order is pending and not being processed, Pending state will fail after 5 minutes on FLYT end
        # must notify FLYT through the update order status endpoint.
        return HttpResponse(status=202)
    
        # if order cannot be processed
        # return HttpResponse(status=400)