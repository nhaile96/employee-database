CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL
);

CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title" FOREIGN KEY("emp_title")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

--View and verify data

SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM salaries;
SELECT * FROM titles;
SELECT * FROM dept_manager;

--1.

CREATE VIEW emp_salaries AS
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
INNER JOIN salaries ON
employees.emp_no = salaries.emp_no;

--2.
CREATE VIEW emp_1986 AS
SELECT first_name, last_name, hire_date 
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1987-01-01';

--3.
CREATE VIEW managers_dept AS 
SELECT departments.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM departments
INNER JOIN dept_manager ON
departments.dept_no=dept_manager.dept_no
INNER JOIN employees ON
dept_manager.emp_no=employees.emp_no;

--4.
CREATE VIEW emp_departments AS
SELECT dept_emp.emp_no, employees.last_name,employees.first_name,departments.dept_name
FROM dept_emp
INNER JOIN employees ON
dept_emp.emp_no=employees.emp_no
INNER JOIN departments ON
dept_emp.dept_no = departments.dept_no;

--5.
CREATE VIEW herc_emp AS
SELECT first_name, last_name, sex
FROM employees
WHERE first_name='Hercules'AND last_name LIKE 'B%';

--6.
CREATE VIEW sales_emp AS
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
INNER JOIN employees ON
dept_emp.emp_no = employees.emp_no
INNER JOIN departments ON
dept_emp.dept_no=departments.dept_no
WHERE departments.dept_name ='Sales';

--7.
CREATE VIEW last_name_count AS
SELECT last_name,
COUNT(last_name) 
FROM employees
GROUP BY last_name
ORDER BY
COUNT(last_name) DESC;

--Export Views

COPY (SELECT * FROM emp_1986) TO 'C:\Users\Public\emp_data1986.csv' DELIMITER ',' CSV HEADER;

COPY (SELECT * FROM emp_departments) TO 'C:\Users\Public\emp_departments.csv' DELIMITER ',' CSV HEADER;

COPY (SELECT * FROM emp_salaries) TO 'C:\Users\Public\emp_salaries.csv' DELIMITER ',' CSV HEADER;

COPY (SELECT * FROM herc_emp) TO 'C:\Users\Public\herc_emp.csv' DELIMITER ',' CSV HEADER;

COPY (SELECT * FROM last_name_count) TO 'C:\Users\Public\last_name_count.csv' DELIMITER ',' CSV HEADER;

COPY (SELECT * FROM managers_dept) TO 'C:\Users\Public\managers_dept.csv' DELIMITER ',' CSV HEADER;

COPY (SELECT * FROM sales_emp) TO 'C:\Users\Public\sales_emp.csv' DELIMITER ',' CSV HEADER;





