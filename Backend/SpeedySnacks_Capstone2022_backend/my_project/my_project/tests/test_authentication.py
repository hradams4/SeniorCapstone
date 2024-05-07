from django.test import TestCase
from django.contrib.auth import authenticate
from django.contrib.auth.models import User

####################################################
############ Tests our Sign in system ##############
####################################################
class SigninTest(TestCase):
    
    # Sets up a fake user to test with. 
    def setUp(self):
        self.user = User.objects.create_user(username='fakeUser', password='password123', email='test@example.com')
        self.user.save()

    # Tests that our fake user can sign into our application
    def test_correct(self):
        user = authenticate(username='fakeUser', password='password123')
        self.assertTrue((user is not None) and user.is_authenticated)
        
    # Test to make sure that a wrong username won't authenticate.
    def test_wrong_username(self):
        user = authenticate(username='wrong', password='password123')
        self.assertFalse(user is not None and user.is_authenticated)
        
    # Test to mae sure that a wrong password will not authenticate
    def test_wrong_password(self):
        user = authenticate(username='fakeUser', password='wrong')
        self.assertFalse(user is not None and user.is_authenticated)
    
    # Tears down our test so it does not linger in test database. 
    def tearDown(self):
        self.user.delete()
