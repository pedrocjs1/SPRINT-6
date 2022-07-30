import json
import sqlite3

def parsear():
    with open('eventos_gold.json') as file:
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
  
    sqlite_insert_query = f"""INSERT INTO cliente(customer_id,customer_DNI, customer_name, customer_surname, branch_id)
                           VALUES
                          ({data['numero']},'{data['dni']}','{data['nombre']}','{data['apellido']}','{1}')"""
    c.execute(sqlite_insert_query)
    connection.commit()
main()
    