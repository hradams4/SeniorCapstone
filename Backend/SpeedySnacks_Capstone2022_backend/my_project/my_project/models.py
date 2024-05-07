# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
from django.contrib.auth.models import User

class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.IntegerField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=150)
    last_name = models.CharField(max_length=150)
    email = models.CharField(max_length=254)
    is_staff = models.IntegerField()
    is_active = models.IntegerField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class Categories(models.Model):
    category = models.CharField(max_length=255, blank=True, null=True)
    category_order = models.IntegerField(blank=True, null=True)
    disabled = models.PositiveIntegerField(blank=True, null=True)
    prod_count = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'categories'


class ContactUsLog(models.Model):
    receive_time = models.DateTimeField(auto_now_add=True)
    store_id = models.CharField(max_length=36, blank=True, null=True)
    client_deliverypartner = models.CharField(max_length=100, null=True, default='SkipTheDishes')
    client_email = models.CharField(max_length=100, null=True)
    client_message = models.TextField(max_length=100, null=True)
    client_resolved = models.BooleanField(default=False)

    def __str__(self):
        return "Delivery partner: " + str(self.client_deliverypartner) + " - " +"Email: " + str(self.client_email) + " - " + "Message: " + str(self.client_message) + " - " + "Received on: " + str(self.receive_time) + " - " + "Resolved: " + str(self.client_resolved)

    class Meta:
        managed = True
        db_table = 'contact_us_log'
        


class CancelOrder(models.Model):
    receive_time = models.DateTimeField(auto_now_add=True)
    store_id = models.CharField(max_length=36, blank=True, null=True)
    order_id = models.CharField(max_length=36, blank=True, null=True)
    client_email = models.CharField(max_length=100, null=True)
    cancel_reason = models.TextField(max_length=100, null=True)
    other_reason = models.TextField(max_length=100, null=True)

    class Meta:
        managed = True
        db_table = 'cancel_order_log'


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.PositiveSmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    id = models.BigAutoField(primary_key=True)
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class FullfillmentPartner(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    store_id = models.CharField(max_length=36, blank=True, null=True)
    
    class Meta:
        managed = True
        db_table = 'fullfillment_partners'



class Ipv4(models.Model):
    id = models.BigAutoField(primary_key=True)
    ip_start = models.BigIntegerField(blank=True, null=True)
    ip_end = models.BigIntegerField(blank=True, null=True)
    country_short = models.TextField(db_collation='latin1_swedish_ci', blank=True, null=True)
    country = models.TextField(db_collation='latin1_swedish_ci', blank=True, null=True)
    province = models.TextField(db_collation='latin1_swedish_ci', blank=True, null=True)
    city = models.TextField(db_collation='latin1_swedish_ci', blank=True, null=True)
    gps_lat = models.FloatField(blank=True, null=True)
    gps_lng = models.FloatField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'ipv4'


class LandingPageClicks(models.Model):
    landing_page_id = models.PositiveIntegerField(blank=True, null=True)
    product_id = models.PositiveIntegerField(blank=True, null=True)
    ref = models.CharField(max_length=45, blank=True, null=True)
    user_agent = models.TextField(blank=True, null=True)
    ipaddress = models.PositiveIntegerField(blank=True, null=True)
    datetime = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'landing_page_clicks'


class LandingPagePreviews(models.Model):
    landing_page_id = models.PositiveIntegerField(blank=True, null=True)
    product_id = models.PositiveIntegerField(blank=True, null=True)
    ref = models.CharField(max_length=45, blank=True, null=True)
    referrer = models.TextField(blank=True, null=True)
    user_agent = models.TextField(blank=True, null=True)
    ipaddress = models.PositiveIntegerField(blank=True, null=True)
    datetime = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'landing_page_previews'


class LandingPageViews(models.Model):
    landing_page_id = models.PositiveIntegerField(blank=True, null=True)
    product_id = models.PositiveIntegerField(blank=True, null=True)
    ref = models.CharField(max_length=45, blank=True, null=True)
    referrer = models.TextField(blank=True, null=True)
    user_agent = models.TextField(blank=True, null=True)
    ipaddress = models.PositiveIntegerField(blank=True, null=True)
    datetime = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'landing_page_views'


class LandingPages(models.Model):
    snack_id = models.CharField(unique=True, max_length=100, blank=True, null=True)
    product_name = models.TextField(blank=True, null=True)
    title = models.TextField(blank=True, null=True)
    image = models.TextField(blank=True, null=True)
    background_image = models.TextField(blank=True, null=True)
    social_image = models.TextField(blank=True, null=True)
    copy = models.TextField(db_collation='utf8mb4_0900_ai_ci', blank=True, null=True)
    keywords = models.TextField(blank=True, null=True)
    product_id = models.IntegerField(blank=True, null=True)
    disabled = models.IntegerField(blank=True, null=True)
    uuid = models.CharField(max_length=36, blank=True, null=True)
    added_on = models.DateTimeField(blank=True, null=True)
    added_by = models.IntegerField(blank=True, null=True)
    updated = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'landing_pages'


class MenuApproval(models.Model):
    idmenu_approval_copy1 = models.AutoField(primary_key=True)
    user_id = models.CharField(max_length=45, blank=True, null=True)
    data = models.TextField(blank=True, null=True)
    store_id = models.CharField(max_length=36, blank=True, null=True)
    menu_id = models.IntegerField()
    status = models.CharField(max_length=45, blank=True, null=True)
    product_id = models.CharField(max_length=45)

    class Meta:
        managed = True
        db_table = 'menu_approval'


class Menus(models.Model):
    store_id = models.CharField(max_length=36, blank=True, null=True)
    product_id = models.IntegerField(blank=True, null=True)
    price = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    cost = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    hst = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    pst = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    date_time = models.DateTimeField(blank=True, null=True)
    profit = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    margin = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    delivery_fee = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    availbility = models.CharField(max_length=36, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'menus'


class MenusHistory(models.Model):
    history_id = models.AutoField(primary_key=True)
    id = models.IntegerField(blank=True, null=True)
    store_id = models.CharField(max_length=36, blank=True, null=True)
    product_id = models.IntegerField(blank=True, null=True)
    price = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    cost = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    hst = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    pst = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    date_time = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'menus_history'


class ModifiersIdentifiers(models.Model):
    product_id = models.PositiveIntegerField(blank=True, null=True)
    modifier_id = models.PositiveIntegerField(blank=True, null=True)
    identifier = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'modifiers_identifiers'
        unique_together = (('product_id', 'modifier_id', 'identifier'), ('product_id', 'modifier_id', 'identifier'),)


class Orders(models.Model):
    delivery_co = models.CharField(max_length=45, blank=True, null=True)
    customer_name = models.CharField(max_length=255, blank=True, null=True)
    delivery_order_id = models.CharField(max_length=45, blank=True, null=True)
    status = models.CharField(max_length=45, blank=True, null=True)
    order_date = models.DateTimeField(blank=True, null=True)
    line_item = models.CharField(max_length=50, blank=True, null=True)
    item_name = models.CharField(max_length=255, blank=True, null=True)
    product_id = models.IntegerField(blank=True, null=True)
    modifier = models.CharField(max_length=255, blank=True, null=True)
    modifier_id = models.IntegerField(blank=True, null=True)
    quantity = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    price = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    cost = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    hst = models.IntegerField(blank=True, null=True)
    pst = models.IntegerField(blank=True, null=True)
    store_id = models.CharField(max_length=36, blank=True, null=True)
    imported_on = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'orders'


class PartnerApplications(models.Model):
    name = models.TextField(blank=True, null=True)
    email = models.TextField(blank=True, null=True)
    location = models.TextField(blank=True, null=True)
    phone = models.TextField(blank=True, null=True)
    comments = models.TextField(blank=True, null=True)
    ipaddress = models.CharField(max_length=15, blank=True, null=True)
    received = models.DateTimeField(blank=True, null=True)
    responded = models.DateTimeField(blank=True, null=True)
    status = models.TextField(blank=True, null=True)
    notes = models.TextField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'partner_applications'


class PartnerProducts(models.Model):
    id = models.AutoField(primary_key=True)
    partner_registration_id = models.IntegerField(blank=True, null=True)
    product_id = models.IntegerField(blank=True, null=True)
    price = models.CharField(max_length=45, blank=True, null=True)
    date_time = models.DateTimeField(blank=True, null=True)
    price2 = models.CharField(max_length=45, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'partner_products'


class PartnerProductsHistory(models.Model):
    history_id = models.AutoField(primary_key=True)
    id = models.IntegerField()
    partner_registration_id = models.IntegerField(blank=True, null=True)
    product_id = models.IntegerField(blank=True, null=True)
    price = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    date_time = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'partner_products_history'


class PartnerProductsModifiers(models.Model):
    modifier_id = models.IntegerField()
    partner_registration_id = models.IntegerField()

    class Meta:
        managed = True
        db_table = 'partner_products_modifiers'


class PartnerRegistrations(models.Model):
    name = models.TextField(blank=True, null=True)
    company = models.TextField(blank=True, null=True)
    email = models.TextField(blank=True, null=True)
    phone = models.TextField(blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    address2 = models.TextField(blank=True, null=True)
    city = models.TextField(blank=True, null=True)
    province = models.TextField(blank=True, null=True)
    postal_code = models.TextField(blank=True, null=True)
    comments = models.TextField(blank=True, null=True)
    registered_on = models.DateTimeField(blank=True, null=True)
    ipaddress = models.CharField(max_length=15, blank=True, null=True)
    reviewed_on = models.DateTimeField(blank=True, null=True)
    status = models.TextField(blank=True, null=True)
    notes = models.TextField(blank=True, null=True)
    invite_code = models.CharField(max_length=36, blank=True, null=True)
    invited_on = models.DateTimeField(blank=True, null=True)
    application_id = models.IntegerField(blank=True, null=True)
    hours = models.CharField(max_length=255, blank=True, null=True)
    bank_name = models.CharField(max_length=255, blank=True, null=True)
    transit_number = models.CharField(max_length=255, blank=True, null=True)
    bank_account = models.CharField(max_length=255, blank=True, null=True)
    bank_account_holder = models.CharField(max_length=255, blank=True, null=True)
    beneficiary_address = models.CharField(max_length=255, blank=True, null=True)
    tax_id = models.CharField(max_length=255, blank=True, null=True)
    stock_submitted_on = models.DateTimeField(blank=True, null=True)
    stock_comments = models.TextField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'partner_registrations'


class PartnerRegistrationsHistory(models.Model):
    id_history = models.AutoField(primary_key=True)
    id = models.IntegerField(blank=True, null=True)
    name = models.TextField(blank=True, null=True)
    company = models.TextField(blank=True, null=True)
    email = models.TextField(blank=True, null=True)
    phone = models.TextField(blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    address2 = models.TextField(blank=True, null=True)
    city = models.TextField(blank=True, null=True)
    province = models.TextField(blank=True, null=True)
    postal_code = models.TextField(blank=True, null=True)
    comments = models.TextField(blank=True, null=True)
    registered_on = models.DateTimeField(blank=True, null=True)
    ipaddress = models.CharField(max_length=15, blank=True, null=True)
    reviewed_on = models.DateTimeField(blank=True, null=True)
    status = models.TextField(blank=True, null=True)
    notes = models.TextField(blank=True, null=True)
    invite_code = models.CharField(max_length=36, blank=True, null=True)
    invited_on = models.DateTimeField(blank=True, null=True)
    application_id = models.IntegerField(blank=True, null=True)
    hours = models.CharField(max_length=255, blank=True, null=True)
    bank_name = models.CharField(max_length=255, blank=True, null=True)
    transit_number = models.CharField(max_length=255, blank=True, null=True)
    bank_account = models.CharField(max_length=255, blank=True, null=True)
    bank_account_holder = models.CharField(max_length=255, blank=True, null=True)
    beneficiary_address = models.CharField(max_length=255, blank=True, null=True)
    tax_id = models.CharField(max_length=255, blank=True, null=True)
    stock_submitted_on = models.DateTimeField(blank=True, null=True)
    stock_comments = models.TextField(blank=True, null=True)
    date_time = models.DateTimeField(blank=True, null=True)
    user_id = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'partner_registrations_history'


class ProductApproval(models.Model):
    user_id = models.CharField(max_length=45, blank=True, null=True)
    product = models.CharField(max_length=1000, blank=True, null=True)
    product_id = models.IntegerField()
    status = models.CharField(max_length=45, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'product_approval'


class Products(models.Model):
    name = models.TextField(blank=True, null=True)
    display_name = models.CharField(max_length=255, blank=True, null=True)
    brand = models.TextField(blank=True, null=True)
    size = models.CharField(max_length=45, blank=True, null=True)
    units = models.CharField(max_length=45, blank=True, null=True)
    suggested_price = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)
    suggested_cost = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)
    image = models.TextField(blank=True, null=True)
    category = models.TextField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    keywords = models.TextField(blank=True, null=True)
    disabled = models.PositiveIntegerField(blank=True, null=True)
    is_vegan = models.PositiveIntegerField(blank=True, null=True)
    is_vegetarian = models.PositiveIntegerField(blank=True, null=True)
    is_gluten_free = models.PositiveIntegerField(blank=True, null=True)
    upc = models.CharField(max_length=20, blank=True, null=True)
    modifier_id = models.IntegerField(blank=True, null=True)
    added_by = models.IntegerField(blank=True, null=True)
    added_on = models.DateTimeField(blank=True, null=True)
    updated = models.DateTimeField(blank=True, null=True)
    temperature = models.TextField(blank=True, null=True)
    product_type_1 = models.CharField(max_length=45, blank=True, null=True)
    product_type_2 = models.CharField(max_length=45, blank=True, null=True)
    product_type_3 = models.CharField(max_length=45, blank=True, null=True)
    tax_category = models.CharField(max_length=45, blank=True, null=True)
    tax_category_2 = models.CharField(max_length=45, blank=True, null=True)
    tax_category_skip = models.CharField(max_length=45, blank=True, null=True)
    is_peanut_free = models.PositiveIntegerField(blank=True, null=True)
    core_product = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'products'


class ProductsCategories(models.Model):
    product_id = models.IntegerField(blank=True, null=True)
    category_id = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'products_categories'


class ProductsHistory(models.Model):
    product_id = models.PositiveIntegerField()
    name = models.TextField(blank=True, null=True)
    display_name = models.CharField(max_length=255, blank=True, null=True)
    brand = models.TextField(blank=True, null=True)
    size = models.CharField(max_length=45, blank=True, null=True)
    units = models.CharField(max_length=45, blank=True, null=True)
    suggested_price = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)
    suggested_cost = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)
    image = models.TextField(blank=True, null=True)
    category = models.TextField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    keywords = models.TextField(blank=True, null=True)
    disabled = models.PositiveIntegerField(blank=True, null=True)
    is_vegan = models.PositiveIntegerField(blank=True, null=True)
    is_vegetarian = models.PositiveIntegerField(blank=True, null=True)
    is_gluten_free = models.PositiveIntegerField(blank=True, null=True)
    upc = models.CharField(max_length=20, blank=True, null=True)
    modifier_id = models.IntegerField(blank=True, null=True)
    date_time = models.DateTimeField(blank=True, null=True)
    user_id = models.CharField(max_length=255, blank=True, null=True)
    is_peanut_free = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'products_history'


class ProductsIdentifiers(models.Model):
    product_id = models.PositiveIntegerField(blank=True, null=True)
    identifier = models.CharField(unique=True, max_length=255, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'products_identifiers'


class ProductsModifiers(models.Model):
    product_id = models.IntegerField(blank=True, null=True)
    modifier = models.TextField(blank=True, null=True)
    modifier_group_name = models.CharField(max_length=45, blank=True, null=True)
    display_name = models.CharField(max_length=255, blank=True, null=True)
    disabled = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'products_modifiers'


class SpeedysnacksSpeedysnacks(models.Model):
    id = models.BigAutoField(primary_key=True)
    title = models.CharField(max_length=200)
    description = models.TextField()

    class Meta:
        managed = True
        db_table = 'speedysnacks_speedysnacks'


class Stores(models.Model):
    store_id = models.CharField(max_length=36, blank=True, null=True)
    name = models.CharField(max_length=200, blank=True, null=True)
    contact_name = models.CharField(max_length=255, blank=True, null=True)
    address = models.CharField(max_length=200, blank=True, null=True)
    address2 = models.CharField(max_length=200, blank=True, null=True)
    city = models.CharField(max_length=200, blank=True, null=True)
    province = models.CharField(max_length=10, blank=True, null=True)
    postal_code = models.CharField(max_length=10, blank=True, null=True)
    phone = models.CharField(max_length=45, blank=True, null=True)
    email = models.CharField(max_length=255, blank=True, null=True)
    gps_lat = models.DecimalField(max_digits=10, decimal_places=8, blank=True, null=True)
    gps_lng = models.DecimalField(max_digits=11, decimal_places=8, blank=True, null=True)
    location = models.TextField(blank=True, null=True)  # This field type is a guess.
    gmt = models.IntegerField(blank=True, null=True)
    url = models.CharField(max_length=255, blank=True, null=True)
    company = models.TextField(blank=True, null=True)
    joined = models.DateTimeField(blank=True, null=True)
    status = models.TextField(blank=True, null=True)
    notes = models.TextField(blank=True, null=True)
    registration_id = models.IntegerField(blank=True, null=True)
    application_id = models.IntegerField(blank=True, null=True)
    open_monday = models.TextField(blank=True, null=True)
    close_monday = models.TextField(blank=True, null=True)
    open_tuesday = models.TextField(blank=True, null=True)
    close_tuesday = models.TextField(blank=True, null=True)
    open_wednesday = models.TextField(blank=True, null=True)
    close_wednesday = models.TextField(blank=True, null=True)
    open_thursday = models.TextField(blank=True, null=True)
    close_thursday = models.TextField(blank=True, null=True)
    open_friday = models.TextField(blank=True, null=True)
    close_friday = models.TextField(blank=True, null=True)
    open_saturday = models.TextField(blank=True, null=True)
    close_saturday = models.TextField(blank=True, null=True)
    open_sunday = models.TextField(blank=True, null=True)
    close_sunday = models.TextField(blank=True, null=True)
    delivery_company_store_id = models.CharField(max_length=36, blank=True, null=True)
    delivery_company = models.TextField(blank=True, null=True)
    uber_store_id = models.CharField(max_length=36, blank=True, null=True)
    uber_fee = models.DecimalField(max_digits=4, decimal_places=2, blank=True, null=True)
    uber_store_url = models.TextField(blank=True, null=True)
    doordash_store_id = models.CharField(max_length=36, blank=True, null=True)
    doordash_fee = models.DecimalField(max_digits=4, decimal_places=2, blank=True, null=True)
    doordash_store_url = models.TextField(blank=True, null=True)
    skip_store_id = models.CharField(max_length=36, blank=True, null=True)
    skip_fee = models.DecimalField(max_digits=4, decimal_places=2, blank=True, null=True)
    skip_store_url = models.TextField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'stores'


class StoresHistory(models.Model):
    history_id = models.AutoField(primary_key=True)
    id = models.PositiveIntegerField(blank=True, null=True)
    store_id = models.CharField(max_length=36, blank=True, null=True)
    name = models.CharField(max_length=200, blank=True, null=True)
    contact_name = models.CharField(max_length=255, blank=True, null=True)
    address = models.CharField(max_length=200, blank=True, null=True)
    address2 = models.CharField(max_length=200, blank=True, null=True)
    city = models.CharField(max_length=200, blank=True, null=True)
    province = models.CharField(max_length=10, blank=True, null=True)
    postal_code = models.CharField(max_length=10, blank=True, null=True)
    phone = models.CharField(max_length=45, blank=True, null=True)
    email = models.CharField(max_length=255, blank=True, null=True)
    gps_lat = models.DecimalField(max_digits=10, decimal_places=8, blank=True, null=True)
    gps_lng = models.DecimalField(max_digits=11, decimal_places=8, blank=True, null=True)
    location = models.TextField(blank=True, null=True)  # This field type is a guess.
    url = models.CharField(max_length=255, blank=True, null=True)
    company = models.TextField(blank=True, null=True)
    joined = models.DateTimeField(blank=True, null=True)
    status = models.TextField(blank=True, null=True)
    notes = models.TextField(blank=True, null=True)
    registration_id = models.IntegerField(blank=True, null=True)
    application_id = models.IntegerField(blank=True, null=True)
    open_monday = models.TextField(blank=True, null=True)
    close_monday = models.TextField(blank=True, null=True)
    open_tuesday = models.TextField(blank=True, null=True)
    close_tuesday = models.TextField(blank=True, null=True)
    open_wednesday = models.TextField(blank=True, null=True)
    close_wednesday = models.TextField(blank=True, null=True)
    open_thursday = models.TextField(blank=True, null=True)
    close_thursday = models.TextField(blank=True, null=True)
    open_friday = models.TextField(blank=True, null=True)
    close_friday = models.TextField(blank=True, null=True)
    open_saturday = models.TextField(blank=True, null=True)
    close_saturday = models.TextField(blank=True, null=True)
    open_sunday = models.TextField(blank=True, null=True)
    close_sunday = models.TextField(blank=True, null=True)
    uber_store_id = models.CharField(max_length=36, blank=True, null=True)
    uber_fee = models.DecimalField(max_digits=4, decimal_places=2, blank=True, null=True)
    uber_store_url = models.TextField(blank=True, null=True)
    doordash_store_id = models.CharField(max_length=36, blank=True, null=True)
    doordash_fee = models.DecimalField(max_digits=4, decimal_places=2, blank=True, null=True)
    doordash_store_url = models.TextField(blank=True, null=True)
    skip_store_id = models.CharField(max_length=36, blank=True, null=True)
    skip_fee = models.DecimalField(max_digits=4, decimal_places=2, blank=True, null=True)
    skip_store_url = models.TextField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'stores_history'


class StoresReports(models.Model):
    store_id = models.CharField(max_length=36, blank=True, null=True)
    start_date = models.DateField(blank=True, null=True)
    end_date = models.DateField(blank=True, null=True)
    file_name = models.CharField(max_length=255, blank=True, null=True)
    sent_on = models.DateTimeField(blank=True, null=True)
    sent_by = models.IntegerField(blank=True, null=True)
    paid_on = models.DateTimeField(blank=True, null=True)
    paid_by = models.IntegerField(blank=True, null=True)
    amount = models.DecimalField(max_digits=8, decimal_places=2, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'stores_reports'


class Users(models.Model):
    username = models.CharField(max_length=45, blank=True, null=True)
    password = models.CharField(max_length=128, blank=True, null=True)
    admin = models.IntegerField(blank=True, null=True)
    marketing = models.IntegerField(blank=True, null=True)
    stores = models.IntegerField(blank=True, null=True)
    pricing = models.IntegerField(blank=True, null=True)
    products = models.IntegerField(blank=True, null=True)
    registrations = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'users'


class VisitorsStores(models.Model):
    ipaddress = models.IntegerField(blank=True, null=True)
    store_id = models.CharField(max_length=36, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'visitors_stores'


class Visits(models.Model):
    page = models.TextField(blank=True, null=True)
    ipaddress = models.PositiveIntegerField(blank=True, null=True)
    ipaddress_ipv4 = models.CharField(max_length=45, blank=True, null=True)
    user_agent = models.TextField(blank=True, null=True)
    referrer = models.TextField(blank=True, null=True)
    visited_on = models.DateTimeField(blank=True, null=True)
    creative_uuid = models.CharField(max_length=36, blank=True, null=True)
    store_id = models.CharField(max_length=36, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'visits'


class VisitsAdmin(models.Model):
    page = models.TextField(blank=True, null=True)
    ipaddress = models.PositiveIntegerField(blank=True, null=True)
    ipaddress_ipv4 = models.CharField(max_length=45, blank=True, null=True)
    user_agent = models.TextField(blank=True, null=True)
    referrer = models.TextField(blank=True, null=True)
    visited_on = models.DateTimeField(blank=True, null=True)
    webpage = models.CharField(max_length=45, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'visits_admin'