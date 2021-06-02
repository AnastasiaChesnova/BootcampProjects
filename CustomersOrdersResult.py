def get_result_to_firstname_lastname_and_total_amount_list(data: list):
    firstname_list_db = []
    lastname_list_db = []
    totalamount_list_db = []
    for row in data:
        firstname_list_db.append(row['firstname'])
        lastname_list_db.append(row['lastname'])
        totalamount_list_db.append(float(row['totalamount']))
    return firstname_list_db, lastname_list_db, totalamount_list_db
