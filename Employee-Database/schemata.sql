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
