from django.contrib import admin

#This class is used for registering our classes so they are viewable on our admin site.

#import classes we need 
from .models import FullfillmentPartner
from .models import ContactUsLog

#register them to use them on our admin portal.
admin.site.register(FullfillmentPartner)
admin.site.register(ContactUsLog)
