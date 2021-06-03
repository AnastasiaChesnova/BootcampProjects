from robot.libraries.BuiltIn import BuiltIn

"""  Функции для работы с SQL-запросами"""
class SqlRequests(object):
    builtin_lib: BuiltIn = BuiltIn()

    def get_postgresql_lib(self):
        return self.builtin_lib.get_library_instance("DB")

    def get_category_and_catygoryname_from_categories(self, category, categoryname):
        sql = """select category, categoryname from bootcamp.categories where category=%(category)s"""

        params = {"category": category, "categoryname": categoryname}
        return self.get_postgresql_lib().execute_sql_string_mapped(sql, **params)

    def get_firstname_lastname_totalamount_from_customers_and_orders_with_totalamounts_greater_than_430(self, totalamount):
        sql = """SELECT firstname, lastname, totalamount from bootcamp.customers c join bootcamp.orders o on c.customerid=o.customerid where totalamount > %(totalamount)s"""

        params = {"totalamount": totalamount}
        return self.get_postgresql_lib().execute_sql_string_mapped(sql, **params)


