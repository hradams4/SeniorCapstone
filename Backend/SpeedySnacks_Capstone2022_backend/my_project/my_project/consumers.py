import json
import queue
import string
import random
import logging
import datetime

from channels.db import database_sync_to_async
from channels.generic.websocket import AsyncWebsocketConsumer
from channels.generic.websocket import AsyncJsonWebsocketConsumer, WebsocketConsumer
from django.contrib.auth import authenticate
from .models import ContactUsLog
from .models import CancelOrder
from .models import Menus
from django.contrib.auth.models import User
from django.core.mail import send_mail
from .models import Orders
from .models import Categories
from .models import Products
from .models import FullfillmentPartner
from django.core.serializers.json import DjangoJSONEncoder
from django.core import serializers
from django.db import connection
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from django.http import HttpResponse, JsonResponse
from django.core.exceptions import ObjectDoesNotExist
from django.db.models import Q
import re


# This retrieves a Python logging instance (or creates it)
# logger = logging.getLogger(__name__)
logging.basicConfig(filename='server.log', level=logging.DEBUG)

# Class will handle login logic.  Will accept connection, receive data and respond accordingly.
class loginConsumer(AsyncWebsocketConsumer):
    
    async def connect(self):

        # Adding a channel layer to a group so we can send notifications to front end using this channel
        await self.channel_layer.group_add('frontend_notifications', self.channel_name)
        print(f'User added to: [{self.channel_name}] - frontend_notifications group')
        
        # Accepts new connections and replies with connected message.
        await self.accept()
        logging.info(" " + str(datetime.datetime.now()) + " Client connected awaiting login credentials. \n")
        print('Client Connected awaiting login credentials....')

        await self.send(text_data=json.dumps({
            'type': 'connection_established',
            'message': 'Server Connected',
        }))

        self.user = self.scope['user']

    # Verifies account with database. If user Authenticates it sends success msg
    async def receive(self, text_data):
        # print('Received Data: ', text_data)
        text_data_json = json.loads(text_data)
        user_email = text_data_json['email']
        user_password = text_data_json['password']

        # Authenticates user with MYSQL. If it finds user it returns username otherwise None.
        user = authenticate(username=user_email, password=user_password)
        if user is not None:
            print(user_email + ' is authenticated')
            logging.info(" "+str(datetime.datetime.now()) + user_email + ' is authenticated. \n')

            # global email variable to send to other classes
            global email
            email = user_email

            # global variable to use with global session
            global firstName 
            firstName = User.objects.get(username=user_email).first_name

            # global variable to use with orders.
            global store_id
            user_id = User.objects.get(username=user_email).id
            store_id = FullfillmentPartner.objects.get(user=user_id).store_id
            
            await self.send(text_data=json.dumps({
                'type': 'notification',
                'message': 'authenticated'
            }))
            
        else:
            logging.error(" "+str(datetime.datetime.now()) + ' Invalid credentials. \n')
            await self.send(text_data=json.dumps({
                'type': 'notification',
                'message': 'Invalid credentials',
            }))
    
    # Method used to send notifications to the front end        
    async def webhook_notification(self, event):
        print('')
        print('Sending following order to: ' + self.channel_name + '\n')
        print(event["message"])
        logging.info(" "+str(datetime.datetime.now()) + str(event["message"]) + "\n")
        
        #Sends message to the front end that a new order notification is now in the DB.
        await self.send(text_data=json.dumps({
            "type": "notification",
            "message": "New order request!"
        }))

    async def disconnect(self, event):
        await self.channel_layer.group_discard('frontend_notifications', self.channel_name)
        logging.info(" "+str(datetime.datetime.now()) + ' Client disconnected. \n')
        print('disconnected', event)

class ContactsConsumer(AsyncJsonWebsocketConsumer):
    async def connect(self):
    # Accepts new connections and replies with connected message. 
        await self.accept()
        print('Navigated to Contact Us screen')
        logging.info(" "+str(datetime.datetime.now()) + ' Navigated to Contact Us screen. \n')
        await self.send(text_data=json.dumps({
            'type':'navigate_to_contacts',
            'message':'Connected to Contact Us screen',		
        }))

    async def receive(self, text_data):

        print('Received Data: ', text_data)
        text_data_json = json.loads(text_data)

        ContactUsLog.store_id = store_id
        ContactUsLog.client_deliverypartner = text_data_json['contact_deliverypartner']
        ContactUsLog.client_email = email
        ContactUsLog.client_message = text_data_json['contact_message']

        ticket = await database_sync_to_async(ContactUsLog.objects.create)(
            store_id=store_id,
            client_deliverypartner=text_data_json['contact_deliverypartner'],
            client_email=email,
            client_message=text_data_json['contact_message'])

        await database_sync_to_async(ticket.save)()

        send_mail(
            'CUSTOMER SUPPORT TICKET FROM: ' + ContactUsLog.client_email,
            'Delivery Partner: ' + ContactUsLog.client_deliverypartner
            + '\nMessage: ' + ContactUsLog.client_message,
            'no-reply@speedysnacks.com',
            ['nklee4@asu.edu'],
            fail_silently=False,
        )
        logging.info(" "+str(datetime.datetime.now()) + ' Support email sent from customer: ' + str(ContactUsLog.client_email)+ "\n")

    async def ticket_log(self, event):
        ContactUsLog.store_id = event[store_id]
        ContactUsLog.client_deliverypartner = event['contact_deliverypartner']
        ContactUsLog.client_email = event[email]
        ContactUsLog.client_message = event['contact_message']

        await self.send(text_data=json.dumps({
            store_id : ContactUsLog.store_id,
            email : ContactUsLog.client_email,
            'contact_deliverypartner' : ContactUsLog.client_deliverypartner,
            'contact_message' : ContactUsLog.client_message
        }))
        logging.info(" "+str(datetime.datetime.now()) + ' Support ticket logged for store ID: ' + str(ContactUsLog.store_id) + "\n")

    async def disconnect(self, event):
        print('Disconnected', event)
        logging.info(" "+str(datetime.datetime.now()) + ' Contact us session ended. \n')

# Class will handle change password logic.  Will make sure user exists then assign a new password.
class changePasswordConsumer(AsyncJsonWebsocketConsumer):

    async def connect(self):

        # Accepts new connections and replies with connected message.
        await self.accept()
        logging.info(" "+str(datetime.datetime.now()) + ' Server awaiting password change information. \n')
        print('Server awaiting password change information....')
        await self.send(text_data=json.dumps({
            'type': 'connection_established',
            'message': 'Connected to change password',
        }))

        self.user = self.scope['user']

# Verifies account with database. If user Authenticates it sends success msg
    async def receive(self, text_data):

        # print('Received Data: ', text_data)
        text_data_json = json.loads(text_data)
        user_name = text_data_json['username']
        old_password = text_data_json['old_password']
        new_password = text_data_json['new_password']

        # Authenticate user before changing password.
        user = authenticate(username=user_name, password=old_password)
        if user is not None:
            # Grab password and change password.
            print('Changing password for ' + user_name)
            logging.info(" "+str(datetime.datetime.now()) + ' Changing password for ' + str(user_name) + "\n")

            ######################################
            # change password block
            ######################################
            u = User.objects.get(username=user_name)
            u.set_password(new_password)
            u.save()

            await self.send(text_data=json.dumps({
                'type': 'notification',
                'message': 'password changed',
            }))
        else:
            logging.error(" "+str(datetime.datetime.now()) + ' Invalid credentials. \n')
            await self.send(text_data=json.dumps({
                'type': 'notification',
                'message': 'Invalid credentials',
            }))

    async def disconnect(self, event):
        print('Disconnected', event)
        logging.info(" "+str(datetime.datetime.now()) + ' Change password session ended. \n')

# Generates random password and sends to user email account for them to log in.
class resetPasswordConsumer(AsyncJsonWebsocketConsumer):

    async def connect(self):

        # Accepts new connections and replies with connected message.
        await self.accept()
        print('Server awaiting password reset information....')
        logging.info(" "+str(datetime.datetime.now()) + ' Server awaiting password reset information. \n')
        await self.send(text_data=json.dumps({
            'type': 'connection_established',
            'message': 'Connected to reset password',
        }))

        self.user = self.scope['user']

    # Verifies account with database. If user Authenticates it sends success msg
    async def receive(self, text_data):
        newPassword = ''

        print('Received Data: ', text_data)
        text_data_json = json.loads(text_data)
        user_email = text_data_json['email']

        # /////////////////////////////////////
        # Random 8 digit password generator.
        # ///////////////////////////////////
        def random_password(size=8, chars=string.ascii_uppercase + string.digits):
            return ''.join(random.choice(chars)
                           for _ in range(size))

        # Sets 8 character password to variable for use. 
        newPassword = random_password()

        # /////////////////////////////////
        # verify if email exists block
        # /////////////////////////////////
        user_exist = User.objects.filter(username=user_email).exists()
        if user_exist:

            ######################################
            # change password block
            ######################################
            print('Email exists! password changed to : ' + newPassword)
            logging.info(" "+str(datetime.datetime.now()) + ' Email exists! password changed. \n')
            u = User.objects.get(username=user_email)
            u.set_password(newPassword)
            u.save()

            # /////////////////////////////////////
            # Sends email with temporary password
            # /////////////////////////////////////
            send_mail(
                'Speedysnacks password reset',
                'Hello! \n \n Please use the following password to log in: ' + newPassword +
                '\n \n After logging in you can change your password by going into Settings - Change Password \n \n Thank you! \n SpeedySnacks Team',

                'no-reply@speedysnacks.com',
                # TEMPORARY BEHAVIOR - This will go to user's email.
                
                ##############################################
                # TO-DO Enter Speedy snacks contact email here
                ##############################################
                print('EMAIL HAS NOT BEEN SET - SEE LINE 283')
                ['ENTER EMAIL ADDRESS HERE'],
                fail_silently=False,
            )
            ######################################
            # uncomment once email has been set! #
            ######################################
            # logging.info(" "+str(datetime.datetime.now()) + ' New password emailed \n')
            
            logging.error(" "+str(datetime.datetime.now()) + ' EMAIL HAS NOT BEEN SET - SEE LINE 283 \n')

            await self.send(text_data=json.dumps({
                'type': 'notification',
                'message': 'password reset',
            }))
        else:
            logging.error(" "+str(datetime.datetime.now()) + ' Email was NOT found!  \n')
            print('Email was NOT found! ')
            await self.send(text_data=json.dumps({
                'type': 'notification',
                'message': 'Email does not exist',
            }))

    async def disconnect(self, event):
        print('Disconnected', event)
        logging.info(" "+str(datetime.datetime.now()) + ' Reset password session ended. \n')


class productList(AsyncJsonWebsocketConsumer):

    user_choice1 = ''

    async def connect(self):
        
        await self.accept()
        with connection.cursor() as cursor:
            cursor.execute("SELECT *, (select count(*) from products_categories, products, menus where (category_id = categories.id and products_categories.product_id = products.id and products.id = menus.product_id)) as prod_count FROM speedysnacks_dev.categories;")
            row = cursor.fetchall()
            
            await self.send(text_data=json.dumps({
            'type': 'navigate_to_productList',
            'message': row,
        }))
            
    async def receive(self, text_data):

        text_data_json = json.loads(text_data)
        user_choice = text_data_json['msg']

        #self.user_choice1 = user_choice
        self.__class__.user_choice1 = user_choice
               
    
class productDetail(AsyncJsonWebsocketConsumer):
    

    async def connect(self):
        
        await self.accept()
        test1 = productList()
        with connection.cursor() as cursor:
            cursor.execute(
                "SELECT products.name, products.size, products.image, menus.cost, products.brand, products.id, menus.availbility FROM speedysnacks_dev.products, speedysnacks_dev.categories, speedysnacks_dev.products_categories, speedysnacks_dev.menus  WHERE products.id = products_categories.product_id AND categories.id = products_categories.category_id AND products.id = menus.product_id AND categories.id = %s", test1.user_choice1)
            row = cursor.fetchall()
            row = [list(r) for r in row]
            for r in row:
                r[3] = float(r[3])
            
            print(row[0])
            await self.send(text_data=json.dumps({
            'type': 'navigate_to_productDetail',
            'message': row,
        } ))        
            
    async def receive(self, text_data):
        print("incoming data: " + text_data)
        text_data_json = json.loads(text_data)
        user_choice = text_data_json['status']
        print("status")
        print(user_choice)

        my_id = text_data_json['id']
        print("id: " +my_id)

        menu = await database_sync_to_async(Menus.objects.filter(product_id=my_id).first)()
        menu.availbility = user_choice
        
        await database_sync_to_async(menu.save)()
        
        
class ordersHistoryConsumer(AsyncJsonWebsocketConsumer):
    
    async def connect(self):

        # Accepts new connections and replies with connected message.
        await self.accept()
        print('Navigated to Orders History screen')
        logging.info(" "+str(datetime.datetime.now()) + ' Navigated to Orders History screen. \n')
        await self.send(text_data=json.dumps({
            'type': 'navigate_to_orders_history',
            'message': 'Connected to Orders History screen',
        }))

    async def disconnect(self, event):
        print('Disconnected', event)
        logging.info(" "+str(datetime.datetime.now()) + ' Order history session ended. \n')

class faqConsumer(AsyncJsonWebsocketConsumer):
    async def connect(self):

        # Accepts new connections and replies with connected message.
        await self.accept()
        print('Navigated to FAQ screen')
        logging.info(" "+str(datetime.datetime.now()) + ' Navigated to FAQ screen. \n')
        await self.send(text_data=json.dumps({
            'type': 'navigate_to_FAQ',
            'message': 'Connected to FAQ screen',
        }))

    async def disconnect(self, event):
        print('Disconnected', event)
        logging.info(" "+str(datetime.datetime.now()) + ' FAQ session ended. \n')

class settingsConsumer(AsyncJsonWebsocketConsumer):
    async def connect(self):

        # Accepts new connections and replies with connected message.
        await self.accept()
        print('Navigated to Settings screen')
        logging.info(" "+str(datetime.datetime.now()) + ' Navigated to Settings screen. \n')
        await self.send(text_data=json.dumps({
            'type': 'navigate_to_settings',
            'message': 'Connected to Settings screen',
        }))

    async def disconnect(self, event):
        print('Disconnected', event)
        logging.info(" "+str(datetime.datetime.now()) + ' Settings session ended. \n')

# Class will handle user session logic.  Will accept connection grab the first name from global variable and send it.
class userSessionConsumer(AsyncJsonWebsocketConsumer):

    async def connect(self):
        # ////////////////////////////////////////////////////////
        # Accepts request and responds with global variable value.
        # ////////////////////////////////////////////////////////
        await self.accept()
        print('Hello ' + firstName)
        print('User Session Initializing....')
        logging.info(" "+str(datetime.datetime.now()) + ' User session started for: ' + str(firstName)+ '\n')
        
        await self.send(text_data=json.dumps({
                'type': 'notification',
                'name' : firstName,
                'message': 'user found',
        }))

        self.user = self.scope['user']

    # Verifies account with database. If user Authenticates it sends success msg
    async def receive(self, text_data):
        # /////////////////////////////////////
        # Should not expect to receive any data. 
        # /////////////////////////////////////
        print('')

    async def disconnect(self, event):
        print('disconnected', event)
        logging.info(" "+str(datetime.datetime.now()) + ' User session ended. \n')

# Class will load orders from database associated with the username of the current session.
class loadOrdersConsumer(AsyncJsonWebsocketConsumer):
    async def connect(self):
        await self.accept()
        print('Navigated to Orders screen')
        logging.info(" "+str(datetime.datetime.now()) + ' Navigated to Orders screen. \n')

    async def disconnect(self, close_code):
        print('Disconnected')

    async def receive(self, text_data):
        print("Received a request for all orders from store ID " + store_id)
        orders = Orders.objects.filter(store_id=store_id)
        sqlOrderIds = orders.values('id')
        sqlOrderIds = [str(id['id']) for id in orders.values('id')]
        deliveryOrderIds = orders.values('delivery_order_id')
        statuses = orders.values('status')
        deliveryCos = orders.values('delivery_co')
        orderDates = orders.values('order_date')
        modifiers = orders.values('modifier')
        itemNames = orders.values('item_name')
        lineItems = orders.values('line_item')
        productIds = orders.values('product_id')
        productIds = [str(prodId['product_id']) for prodId in orders.values('product_id')]
        modifierIds = orders.values('modifier_id')
        modifierIds = [str(modId['modifier_id']) for modId in orders.values('modifier_id')]
        quantities = orders.values('quantity')
        quantities = [str(qty['quantity']) for qty in orders.values('quantity')]
        prices = orders.values('price')
        prices = [str(price['price']) for price in orders.values('price')]

        # Convert order_date to a string
        orderTimes = [date['order_date'].strftime("%H:%M") for date in orderDates]
        
        # Menu
        menu = Menus.objects.filter(store_id=store_id)
        cost = menu.values('cost')
        cost = [str(price['cost']) for price in menu.values('cost')]
        print(cost)
        

        # Get product image URLs for each product ID
        productPictureUrls = []
        for prodId in orders.values('product_id'):
            prod = Products.objects.get(id=prodId['product_id'])
            productPictureUrl = prod.image if prod.image else ''
            productPictureUrl = f"https://speedysnacks.s3.us-east-2.amazonaws.com/products/{productPictureUrl}"
            productPictureUrls.append(productPictureUrl)

        await self.send(json.dumps({
            'type':'response_orders',
            'sqlOrderIds': list(sqlOrderIds),
            'deliveryOrderIds' : list(deliveryOrderIds),
            'statuses' : list(statuses),
            'deliveryCos' : list(deliveryCos),
            'orderTimes' : orderTimes,
            'modifiers' : list(modifiers),
            'itemNames' : list(itemNames),
            'lineItems' : list(lineItems),
            'productIds' : list(productIds),
            'productPictureUrls': productPictureUrls,
            'modifierIds' : list(modifierIds),
            'quantities' : list(quantities),
            'prices' : list(cost),
            'message':'Received orders from server',
        }))

    
    async def disconnect(self, event):
        print('Disconnected', event)
        logging.info(" "+str(datetime.datetime.now()) + ' Orders session ended. \n')
        
# Class will be used when a new order notification comes through.    
class newOrderNotificationConsumer(AsyncJsonWebsocketConsumer):
    async def connect(self):

        # Accepts new connections and checks to see if there are any new orders.
        await self.accept()
    
        incoming_orders = Orders.objects.filter(status='INCOMING').values_list('id', 'delivery_co', 'delivery_order_id', 'status', 'order_date', 'line_item', 'item_name', 'product_id', 'modifier', 'modifier_id', 'quantity', 'price', 'cost', 'hst', 'pst', 'store_id', 'imported_on')
        
        new_orders = json.dumps(list(incoming_orders), cls=DjangoJSONEncoder)
        print(new_orders)
        logging.info(" "+str(datetime.datetime.now()) + ' New order notification Consumer called. \n')
                
        await self.send(text_data=json.dumps({
            'type': 'order_notification',
            'message': new_orders,
        }))
        
    async def disconnect(self, event):
        print('Disconnected', event)
        logging.info(" "+str(datetime.datetime.now()) + ' New order notification session ended. \n')

class orderDetails(AsyncJsonWebsocketConsumer):
    async def connect(self):
        # Accepts new connections and checks to see if there are any new orders.
        await self.accept()
        
        print("Store ID: " + store_id)
    
    async def receive(self, text_data):
        def remove_parentheses(text):
            return re.sub(r'\([^)]*\)', '', text).strip()
        print('Received Data: ', text_data)
        text_data_json = json.loads(text_data)
        print('Product json name is: ', text_data_json['productName'])
        cleaned_search_term = remove_parentheses(text_data_json['productName'])
        print('Cleaned product name: ', cleaned_search_term)
        product = Products.objects.get(Q(name__icontains=cleaned_search_term) | Q(display_name__icontains=cleaned_search_term))

        # product = Products.objects.get(name__icontains=text_data_json['productName'])
        
        print('Product name: ', product.name)
        print('Product picture: ', product.image)
        if 'productName' in text_data_json:
            try:
                product = Products.objects.get(Q(name__icontains=cleaned_search_term) | Q(display_name__icontains=cleaned_search_term))
                await self.send(text_data=json.dumps({
                    'type': 'PRODUCT_DETAILS',
                    'productName': product.display_name,
                    'productPictureUrl': product.image,
                }))
            except ObjectDoesNotExist:
                await self.send(text_data=json.dumps({
                    'type': 'PRODUCT_DETAILS',
                    'error': 'Product not found',
                }))

        
        if 'cancel_orderId' in text_data_json:
            try:
                cancel_orderId = text_data_json['cancel_orderId']
                print(cancel_orderId)
            except ObjectDoesNotExist:
                await self.send(text_data=json.dumps({
                    'type': 'CANCEL DETAILS',
                    'error': 'Product not found',
                }))
        
        await self.send(text_data=json.dumps({
            'type': '',
            'message': 'Connected to Order Details Screen',
        }))

    async def disconnect(self, event):
        print('Disconnected', event)



class cancelOrder(AsyncJsonWebsocketConsumer):
    async def connect(self):
        await self.accept()
        logging.info(" "+str(datetime.datetime.now()) + ' Cancel order initiated. \n')

    async def receive(self, text_data):
        print('Received Data: ', text_data)
        text_data_json = json.loads(text_data)
        action = text_data_json.get('action')

        if action == 'cancel_order':
            CancelOrder.store_id = store_id
            CancelOrder.order_id = text_data_json['cancel_orderId']
            CancelOrder.client_email = email
            CancelOrder.cancel_reason = text_data_json['cancel_reason']
            CancelOrder.other_reason = text_data_json['other_reason']

            ticket = await database_sync_to_async(CancelOrder.objects.create)(
                store_id=store_id,
                order_id=text_data_json['cancel_orderId'],
                client_email=email,
                cancel_reason=text_data_json['cancel_reason'],
                other_reason=text_data_json['other_reason'])

            await database_sync_to_async(ticket.save)()

            # Retrieve all orders with the same delivery_order_id and update their status to "CANCELLED"
            orders = await database_sync_to_async(Orders.objects.filter)(delivery_order_id=CancelOrder.order_id)
            await database_sync_to_async(orders.update)(status='Cancelled')
            await self.ticket_log(text_data_json)
        elif action == 'accept_order':
            order_id = text_data_json['order_id']
            orders = await database_sync_to_async(Orders.objects.filter)(delivery_order_id=order_id)
            await database_sync_to_async(orders.update)(status='Active')
            print("Order accepted:", order_id)
        elif action =='mark_ready':
            order_id = text_data_json['order_id']
            orders = await database_sync_to_async(Orders.objects.filter)(delivery_order_id=order_id)
            await database_sync_to_async(orders.update)(status='Ready')
            print("Order ready:", order_id)
        elif action =='complete_order':
            order_id = text_data_json['order_id']
            orders = await database_sync_to_async(Orders.objects.filter)(delivery_order_id=order_id)
            await database_sync_to_async(orders.update)(status='Completed')
            print("Order complete:", order_id)


    async def ticket_log(self, event):
        CancelOrder.store_id = event[store_id]
        CancelOrder.order_id = event['cancel_orderId']
        CancelOrder.client_email = event[email]
        CancelOrder.cancel_reason = event['cancel_reason']
        CancelOrder.other_reason = event['other_reason']

        # Update the status of the corresponding order to "CANCELLED"
        order_qs = await database_sync_to_async(Orders.objects.filter)(delivery_order_id=CancelOrder.order_id)
        if order_qs.exists():
            order = order_qs.first()
            order.status = 'CANCELLED'
            await database_sync_to_async(order.save)()
            logging.info(" "+str(datetime.datetime.now()) + ' Order status changed to cancelled. \n')

            await self.send(text_data=json.dumps({
                store_id : CancelOrder.store_id,
                email : CancelOrder.client_email,
                'cancel_orderId' : CancelOrder.order_id,
                'cancel_reason' : CancelOrder.cancel_reason,
                'other_reason' : CancelOrder.other_reason,
                'CANCELLED' : order.status
            }))

    async def disconnect(self, event):
        print('Disconnected', event)
        logging.info(" "+str(datetime.datetime.now()) + ' Cancel order session ended. \n')


        
        
# Class will receive updates to an order made in the front end and make these changes in the  database.
class editOrderConsumer(AsyncJsonWebsocketConsumer):
    async def connect(self):
        await self.accept()
        print('Navigated to Edit Order screen')
        logging.info(" "+str(datetime.datetime.now()) + ' Navigated to Edit Order screen. \n')

    async def disconnect(self, close_code):
        print('Disconnected')

    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        for i in range(len(text_data_json)):
            order_id = text_data_json[i]['order_id']
            order = Orders.objects.get(id=order_id)
            order.quantity = text_data_json[i]['quantity']
            order.save()
            print("Order updated:", order)