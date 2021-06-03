from robot.libraries.BuiltIn import BuiltIn
from JsonValidator import JsonValidator

""" Функции для преобразования json"""
class JsonParser(object):
    builtin_lib: BuiltIn = BuiltIn()
    js:JsonValidator = JsonValidator()
    def get_requests_lib(self):
        return self.builtin_lib.get_library_instance("Req")

    """ Функция для преобразования json в списки из category и categoryname"""
    def get_category_categoryname(self, data):
        category = self.js.get_elements(data, '$..category')
        categoryname = self.js.get_elements(data, '$..categoryname')
        self.builtin_lib.should_not_be_empty(category)
        self.builtin_lib.should_not_be_empty(categoryname)
        return category, categoryname

    """ Функция для преобразования json в списки из firstname, lastname и totalamount"""
    def get_firstname_lastname_totalamount(self, data):
        firstname = self.js.get_elements(data, '$..firstname')
        lastname = self.js.get_elements(data, '$..lastname')
        totalamount = self.js.get_elements(data, '$..totalamount')
        return firstname, lastname, totalamount

