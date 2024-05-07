from email.mime import application
from os import path
from channels.auth import AuthMiddlewareStack
from channels.routing import ProtocolTypeRouter, URLRouter
from django.urls import re_path
from .import consumers
import my_project.routing

websocket_pattern = [
    re_path(r'ws/login/', consumers.loginConsumer.as_asgi()),
    re_path(r'ws/changePassword/', consumers.changePasswordConsumer.as_asgi()),
    re_path(r'ws/productList/', consumers.productList.as_asgi()),
    re_path(r'ws/productDetail/', consumers.productDetail.as_asgi()),
    re_path(r'ws/contacts/', consumers.ContactsConsumer.as_asgi()),
    re_path(r'ws/resetPassword/', consumers.resetPasswordConsumer.as_asgi()),
    re_path(r'ws/loadOrders/', consumers.loadOrdersConsumer.as_asgi()),
    re_path(r'ws/editOrder/', consumers.editOrderConsumer.as_asgi()),
    re_path(r'ws/ordershistory/', consumers.ordersHistoryConsumer.as_asgi()),
    re_path(r'ws/faq/', consumers.faqConsumer.as_asgi()),
    re_path(r'ws/settings/', consumers.settingsConsumer.as_asgi()),
    re_path(r'ws/userSession/', consumers.userSessionConsumer.as_asgi()),
    re_path(r'ws/getNewOrders/', consumers.newOrderNotificationConsumer.as_asgi()),
    re_path(r'ws/orderDetails/', consumers.orderDetails.as_asgi()),
    re_path(r'ws/cancelOrder/', consumers.cancelOrder.as_asgi()),
]

