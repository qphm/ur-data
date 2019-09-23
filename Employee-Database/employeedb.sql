CREATE TABLE "departments" (
    "dept_no" VARCHAR PRIMARY KEY,
    "dept_name" VARCHAR NOT NULL,
);

CREATE TABLE "dept_emp" (
    "emp_no" INT NOT NULL,
    "dept_no" VARCHAR NOT NULL,
    "from_date" DATE NOT NULL,
    "to_date" DATE NOT NULL
    FOREIGN KEY(dept_no) REFERENCES employees(emp_no) ON DELETE SET NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR NOT NULL,
    "emp_no" INT NOT NULL,
    "from_date" DATE NOT NULL,
    "to_date" DATE NOT NULL
    FOREIGN KEY(dept_no) REFERENCES employees(emp_no) ON DELETE SET NULL
);

CREATE TABLE "employees" (
    "emp_no" INT PRIMARY KEY,
    "birth_date" DATE NOT NULL,
    "first_name" VARCHAR NOT NULL,
    "last_name" VARCHAR NOT NULL,
    "gender" VARCHAR NOT NULL,
    "hire_date" DATE NOT NULL,
);

CREATE TABLE "salaries" (
    "emp_no" INT NOT NULL,
    "salary" INT NOT NULL,
    "from_date" DATE NOT NULL,
    "to_date" DATE NOT NULL
);

CREATE TABLE "titles" (
    "emp_no" INT NOT NULL,
    "title" VARCHAR NOT NULL,
    "from_date" DATE NOT NULL,
    "to_date" DATE NOT NULL
 );

ALTER TABLE dept_emp
ADD FOREIGN KEY(dept_no)
REFERENCES departments(dept_no)
ON DELETE SET NULL;

ALTER TABLE dept_manager
ADD FOREIGN KEY(dept_no)
REFERENCES departments(dept_no)
ON DELETE SET NULL;

--------------------------------------------------
-- Data Analysis

-- 1. List the following details of each employee: employee number, last name, first name, gender, and salary.
SELECT employees.emp_no, first_name, last_name, gender, salary
FROM employees
JOIN salaries
ON employees.emp_no = salaries.emp_no;

-- 2. List employees who were hired in 1986.
SELECT first_name, last_name, hire_date 
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31';

-- 3. List the manager of each https://app.quickdatabasediagrams.com/#/department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
SELECT departments.dept_no, dept_manager.emp_no, dept_name, first_name, last_name, from_date, to_date
FROM departments
JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no
JOIN employees
ON dept_manager.emp_no = employees.emp_no;

-- 4. List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT dept_emp.emp_no, first_name, last_name, dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON departments.dept_no = dept_emp.dept_no;

-- 5. List all employees whose first name is "Hercules" and last names begin with "B".
SELECT first_name, last_name
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';

-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT dept_emp.emp_no, first_name, last_name, dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON departments.dept_no = dept_emp.dept_no
WHERE departments.dept_name = 'Sales';

-- 7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT dept_emp.emp_no, first_name, last_name, dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE dept_name = 'Sales' 
OR dept_name = 'Development';

-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name, COUNT(last_name) AS "frequency"
FROM employees
GROUP BY last_name
ORDER BY COUNT(last_name) DESC;






