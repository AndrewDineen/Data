CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,  -- SERIAL creates an auto-incrementing integer
    first_name VARCHAR(255) NOT NULL, -- String, max 255 characters, required
    last_name VARCHAR(255) NOT NULL,  -- String, max 255 characters, required
    email VARCHAR(255) UNIQUE,       -- String, max 255 characters, must be unique
    hire_date DATE,                   -- Date (YYYY-MM-DD)
    salary NUMERIC(10, 2),            -- Numeric with 10 digits total, 2 after decimal
    department_id INTEGER REFERENCES departments(department_id) -- Foreign key
);

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(255) UNIQUE NOT NULL,
    location VARCHAR(255)
);