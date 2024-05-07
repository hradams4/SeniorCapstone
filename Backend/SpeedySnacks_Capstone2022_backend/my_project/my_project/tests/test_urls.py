from django.test import SimpleTestCase
from django.urls import reverse, resolve
from my_project.views import skipOrderNotification, uberEatsOrderNotification

# class that will run a test on our Webhook URL for Skip the dishes. Can be run by typing python manage.py test my_project
class TestSkipEndpoint(SimpleTestCase):
    
    ##############################################################
    ### Tests the skip order noification endpoint for webhooks ###
    ##############################################################
    def test_skipOrderNotification_url_is_resolved(self):
        
        # URL used by SKIP as an endpoint to send new order notifications.
        url = reverse('skipOrderNotification')
        
        # SKIP the dishes order notification endpoint should resolve to the corresponding view function. if not it will Fail.
        self.assertEquals(resolve(url).func, skipOrderNotification)
        
# class that will run a test on our Webhook URL for Uber Eats. Can be run by typing python manage.py test my_project
class TestUberEatsEndpoint(SimpleTestCase):
        
    ###################################################################
    ### Tests the Uber Eats order noification endpoint for webhooks ###
    ###################################################################
    def test_skipOrderNotification_url_is_resolved(self):
        
        # URL used by SKIP as an endpoint to send new order notifications.
        url = reverse('uberEatsOrderNotification')
        
        # SKIP the dishes order notification endpoint should resolve to the corresponding view function. if not it will Fail.
        self.assertEquals(resolve(url).func, uberEatsOrderNotification)