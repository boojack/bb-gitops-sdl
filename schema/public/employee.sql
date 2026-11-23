CREATE TABLE public.employee (
    id bigint GENERATED ALWAYS AS IDENTITY,
    employee_number text NOT NULL,
    full_name text NOT NULL,
    work_email text NOT NULL,
    hire_date date NOT NULL,
    job_title text,
    employment_status text NOT NULL DEFAULT 'active',
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT employee_pkey PRIMARY KEY (id),
    CONSTRAINT employee_employee_number_key UNIQUE (employee_number),
    CONSTRAINT employee_employment_status_check
        CHECK (employment_status IN ('active', 'on_leave', 'terminated'))
);

CREATE UNIQUE INDEX employee_work_email_key
    ON public.employee (lower(work_email));
