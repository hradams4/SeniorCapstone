from django.utils import timezone
from django.test import TestCase
from my_project.models import PartnerRegistrations

############################################################
############ Testing PartnerRegistration model #############
############################################################  
class TestPartnerRegistrations(TestCase):
    
    # Fake fulfillment partner data to test registration.
    def setUp(self):
        self.partner = PartnerRegistrations.objects.create(
            name = "Test Partner",
            company = "Some Corner Store",
            email = "newPartner@somestore.com",
            phone = "111-222-3333",
            address = "376-B Bd des Laurentides, Pont-Viau, Quebec, H7G 2T8",
            address2 = "None",
            city = "Pont-Viau",
            province = "Quebec",
            postal_code = "H7G 2T8",
            comments = "None",
            ipaddress = "10.10.10.10",
            status = "Active",
            notes = "None",
            invite_code = "12345678",
            application_id = "87654321",
            hours = "40",
            bank_name = "Bank of Neverland",
            transit_number = "5678910",
            bank_account = "18274638493782367283",
            bank_account_holder = "Bugs Bunny",
            beneficiary_address = "175 McDermot Ave, Winnipeg, Manitoba, R3B 0S1",
            tax_id = "8928278272990890203902394",
            stock_comments = "None"
        )
 
    # Testing each variable to ensure that a fullfilment partner was able to register successfully.
    def test_partner_registration(self):
        self.assertEqual(self.partner.name, "Test Partner")
        self.assertEqual(self.partner.company , "Some Corner Store")
        self.assertEqual(self.partner.email, "newPartner@somestore.com")
        self.assertEqual(self.partner.phone, "111-222-3333")
        self.assertEqual(self.partner.address, "376-B Bd des Laurentides, Pont-Viau, Quebec, H7G 2T8")
        self.assertEqual(self.partner.address2, "None")
        self.assertEqual(self.partner.city, "Pont-Viau")
        self.assertEqual(self.partner.province, "Quebec")
        self.assertEqual(self.partner.postal_code, "H7G 2T8")
        self.assertEqual(self.partner.comments, "None")
        self.assertEqual(self.partner.ipaddress, "10.10.10.10")
        self.assertEqual(self.partner.status, "Active")
        self.assertEqual(self.partner.notes, "None")
        self.assertEqual(self.partner.invite_code, "12345678")
        self.assertEqual(self.partner.application_id, "87654321")
        self.assertEqual(self.partner.hours, "40")
        self.assertEqual(self.partner.bank_name, "Bank of Neverland")
        self.assertEqual(self.partner.transit_number, "5678910")
        self.assertEqual(self.partner.bank_account, "18274638493782367283")
        self.assertEqual(self.partner.bank_account_holder, "Bugs Bunny")
        self.assertEqual(self.partner.beneficiary_address, "175 McDermot Ave, Winnipeg, Manitoba, R3B 0S1")
        self.assertEqual(self.partner.tax_id, "8928278272990890203902394")
        self.assertEqual(self.partner.stock_comments, "None")