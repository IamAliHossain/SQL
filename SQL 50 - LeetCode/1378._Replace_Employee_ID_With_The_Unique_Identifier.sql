# Write your MySQL query statement below
-- যখন  multiple table থেকে data fetch করতে হয় তখন JOIN operation করতে হয় 
--  সেক্ষেত্রে LEFT/RIGHT JOIN use করা হয় jokhon কোন ভ্যালু table এ missing thake tokhon NULL return kore
-- Solution 1
select unique_id, name
from Employees LEFT JOIN EmployeeUNI ON (Employees.id = EmployeeUNI.id)

-- Solution 2
select unique_id, name
from EmployeeUNI RIGHT JOIN Employees ON (Employees.id = EmployeeUNI.id)