# """
# ASGI config for my_project project.

# It exposes the ASGI callable as a module-level variable named ``application``.

# For more information on this file, see
# https://docs.djangoproject.com/en/4.1/howto/deployment/asgi/
# """

import os

os.environ["DJANGO_ALLOW_ASYNC_UNSAFE"] = "true"
from django.core.asgi import get_asgi_application
from channels.routing import ProtocolTypeRouter, URLRouter
from channels.auth import AuthMiddlewareStack
import my_project.routing

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'my_project.settings')

application = ProtocolTypeRouter({
	'http':get_asgi_application(),
	'websocket':AuthMiddlewareStack(
		URLRouter(
			my_project.routing.websocket_pattern
		)
	)
})
