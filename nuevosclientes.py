import json
import sqlite3

def parsear():
    with open('nuevosclientes.json') as file:
        try:
            data = json.load(file)    
        except FileNotFoundError as error: 
          print(error)
          return None
    return data 

def main():
    connection = sqlite3.connect('itbankavance.db')
    c = connection.cursor()
    data = parsear() 
  
    sqlite_insert_query = f"""INSERT INTO cliente(customer_DNI,customer_name,customer_surname,branch_id,customer_dob)
                           VALUES
                          ('{data['customer_DNI']}','{data['customer_name']}','{data['customer_surname']}','{data['customer_dob']}'{1}')"""
    c.execute(sqlite_insert_query)
    connection.commit()
main()
