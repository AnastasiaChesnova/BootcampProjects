from robot.libraries.BuiltIn import BuiltIn
"""  Функции для работы с http-запросами"""
class GetDataFromRest(object):
    builtin_lib: BuiltIn = BuiltIn()

    def get_requests_lib(self):
        return self.builtin_lib.get_library_instance("Req")

    """Функция, выполняющая GET запрос"""
    def get_data_from_rest(self, alias,url, params, expected_status='200'):
        result = self.get_requests_lib().get_on_session(alias=alias, url=url, params=params,
                                                        expected_status=expected_status)
        return result.json()

    """Функция, выполняющая DELETE запрос"""
    def delete_data_from_rest(self, alias,url, params, expected_status='204'):
        self.get_requests_lib().delete_on_session(alias=alias, url=url, params=params,
                                                        expected_status=expected_status)

    """Функция, выполняющая POST запрос"""
    def post_data_to_rest(self, alias,url, params,jsonData ,headers, expected_status='201'):
         self.get_requests_lib().post_on_session(alias=alias, url=url, params=params,
                                                        expected_status=expected_status,json=jsonData ,headers=headers)

