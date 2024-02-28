from peewee import *
from datetime import *
from req import *

# Создаем соединение с базой данных
con = PostgresqlDatabase(
    database='postgres',
    user='kira',
    password='password',
    host='127.0.0.1',
    port="5432"
)

class BaseModel(Model):
    class Meta:
        database = con


class Employee(BaseModel):
    id = IntegerField(column_name='id')
    fio = CharField(column_name='fio')
    date_of_birth = DateField(column_name='date_of_birth')
    department = CharField(column_name='department')

    class Meta:
        table_name = 'employee'

class EmployeeAttendance(BaseModel):
    id = IntegerField(column_name='id')
    employee_id = ForeignKeyField(Employee, backref='employee_id')
    data = DateField(column_name='date')
    day_of_week =  CharField(column_name='day_of_week')
    time = TimeField(column_name='time')
    type = IntegerField(column_name='type')

    class Meta:
        table_name = 'employee_attendance'


def Task():
    global con

    cur = con.cursor()

    cur.execute(FirstQ)
    print("Запрос 1:\n")
    rows = cur.fetchall()
    for row in rows:
        print(*row)

    cur.execute(ThirdQ)
    print("\nЗапрос 3:\n")
    rows = cur.fetchall()
    for row in rows:
        print(*row)

    cur.close()

def main():
	Task()
	con.close()

if __name__ == "__main__":
	main()


FirstQ = """
SELECT department
FROM employee JOIN employee_attendance ea on employee.id = ea.employee_id
WHERE fio LIKE '%Иванов%'
GROUP BY department;
"""



ThirdQ = """
SELECT *
FROM employee JOIN employee_attendance ea on employee.id = ea.employee_id
WHERE date =  '2023-12-12'
AND type = 1
AND time >= '09:07:00';
"""


