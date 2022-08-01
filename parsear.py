import json
import sqlite3
#eventos_gold
def parsear():
    with open('clienteData.json') as file:
        try:
            data = json.load(file)    
        except FileNotFoundError as error: 
          print(error)
          return None
    return data 

def main():
    try: 
     connection = sqlite3.connect('itbank.db')
     c = connection.cursor()
     data = parsear()
     for data in data: 
        sqlite_insert_query = f"""INSERT INTO cliente(customer_name,customer_surname,customer_DNI, branch_id,customer_dob)
                              VALUES
                             ('{data['customer_name']}','{data['customer_surname']}','{data['customer_DNI']}',{data['branch_id']},'{data['customer_dob']}')"""
        c.execute(sqlite_insert_query)
        connection.commit()
        print('Se ingresaron correctamente!!')
    except: 
       print('Se produjo un problema ')
main()
    