import os
from datetime import date
from pathlib import Path
import mysql.connector

try:
    from dotenv import load_dotenv
    load_dotenv()
    # Also load from web/.env if present
    web_env = Path(__file__).resolve().parents[3] / "web" / ".env"
    if web_env.exists():
        load_dotenv(web_env)
except ImportError:
    pass

def get_db_connection():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST", "127.0.0.1"),
        port=int(os.getenv("DB_PORT", "3306")),
        user=os.getenv("DB_USERNAME", os.getenv("DB_USER", "root")),
        password=os.getenv("DB_PASSWORD", ""),
        database=os.getenv("DB_DATABASE", "verifigate")
    )

def get_student_attire_condition(student_number):
  try:
    #connect to database
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    #get today's date
    today = date.today().strftime("%Y-%m-%d")

    # get "id" column from student no. taken from scan
    query_student_no = "SELECT id, sex FROM students WHERE student_number = %s"
    cursor.execute(query_student_no, (student_number,))
    student = cursor.fetchone()

    if student:
      student_id = student["id"]
    else:
      # if somehow student does not exist (will be expanded for visitor here ig)
     return "Unknown"

    # check for exemptions
    query = """
    SELECT e.date, et.name AS exemption_name
    FROM exemptions e
    JOIN exemption_types et ON e.exemption_type_id = et.id
    WHERE e.student_id = %s AND e.date = %s
    """
    cursor.execute(query, (student_id, today))
    exemption = cursor.fetchone()

    # if an exemption exists
    if exemption:
      print(f"Active exemption found: {exemption['exemption_name']}")
      return exemption["exemption_name"]
    else:
      sex = str(student.get("sex") or "male").upper()
      return f"Standard_{sex}"

  except mysql.connector.Error as err:
    print(f"Database error: {err}")
    return None
  finally:
    if "conn" in locals() and conn.is_connected():
      cursor.close()
      conn.close()

# student_no = "H24-9001"
# condition = get_student_attire_condition(student_no)
# print(f"The required attire condition for Student ID {student_no} is: {condition}")

# def get_student_attire_condition(student_id):
#   try:
#     #connect to database
#     conn = mysql.connector.connect(
#       host="127.0.0.1",
#       user="root",
#       password="",
#       database="verifigate"
#     )
#     cursor = conn.cursor(dictionary=True)

#     #get today's date
#     today = date.today().strftime("%Y-%m-%d")

#     #check for exemptions
#     query = """
#     SELECT e.date, et.name AS exemption_name
#     FROM exemptions e
#     JOIN exemption_types et ON e.exemption_type_id = et.id
#     WHERE e.student_id = %s AND e.date = %s
#     """
#     cursor.execute(query, (student_id, today))
#     exemption = cursor.fetchone()

#     # if an exemption exists
#     if exemption:
#       print(f"Active exemption found: {exemption['exemption_name']}")
#       return exemption["exemption_name"]

#     # if no exemptions exist
#     query_student = "SELECT sex FROM students WHERE id = %s"
#     cursor.execute(query_student, (student_id,))
#     student = cursor.fetchone()

#     # return default unif code
#     if student:
#       return f"Standard_{student["sex"]}"

#     # if somehow student does not exist (will be expanded for visitor here ig)
#     return "Unknown"

#   except mysql.connector.Error as err:
#     print(f"Database error: {err}")
#     return None
#   finally:
#     if "conn" in locals() and conn.is_connected():
#       cursor.close()
#       conn.close()

# student_no_testing = 3
# condition = get_student_attire_condition(student_no_testing)
# print(f"The required attire condition for Student ID {student_no_testing} is: {condition}")