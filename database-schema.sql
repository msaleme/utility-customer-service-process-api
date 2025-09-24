-- Utility Customer Service Process API Database Schema
-- Oracle Database Schema for comprehensive utility customer management

-- Drop tables if they exist (for clean setup)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE service_updates CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE service_requests CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE notification_preferences CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE payment_plans CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE payments CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE bills CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE hourly_usage CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE usage_data CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE weather_data CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE energy_profiles CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE customers CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Customers table
CREATE TABLE customers (
    customer_id VARCHAR2(50) PRIMARY KEY,
    account_number VARCHAR2(20) UNIQUE NOT NULL,
    first_name VARCHAR2(100) NOT NULL,
    last_name VARCHAR2(100) NOT NULL,
    email VARCHAR2(255) NOT NULL,
    phone VARCHAR2(20),
    service_street VARCHAR2(255) NOT NULL,
    service_city VARCHAR2(100) NOT NULL,
    service_state VARCHAR2(50) NOT NULL,
    service_zip VARCHAR2(10) NOT NULL,
    service_latitude NUMBER(10,6),
    service_longitude NUMBER(10,6),
    home_type VARCHAR2(50), -- single_family, apartment, condo, townhouse
    home_size_sqft NUMBER(10,2),
    occupancy_count NUMBER(2),
    created_date DATE DEFAULT SYSDATE,
    updated_date DATE DEFAULT SYSDATE
);

-- Energy profiles for customers
CREATE TABLE energy_profiles (
    profile_id VARCHAR2(50) PRIMARY KEY,
    customer_id VARCHAR2(50) NOT NULL,
    avg_monthly_usage NUMBER(10,2),
    peak_usage_hours VARCHAR2(500), -- Comma-separated list of hours
    seasonal_pattern VARCHAR2(100), -- winter_heavy, summer_heavy, balanced
    hvac_type VARCHAR2(50),
    solar_panels NUMBER(1,0) DEFAULT 0, -- 0=No, 1=Yes
    electric_vehicle NUMBER(1,0) DEFAULT 0, -- 0=No, 1=Yes
    created_date DATE DEFAULT SYSDATE,
    updated_date DATE DEFAULT SYSDATE,
    CONSTRAINT fk_profile_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Weather data for analytics
CREATE TABLE weather_data (
    weather_id VARCHAR2(50) PRIMARY KEY,
    date DATE NOT NULL,
    location_zip VARCHAR2(10) NOT NULL,
    temperature NUMBER(5,2),
    humidity NUMBER(5,2),
    wind_speed NUMBER(5,2),
    conditions VARCHAR2(100),
    created_date DATE DEFAULT SYSDATE
);

-- Daily usage data
CREATE TABLE usage_data (
    usage_id VARCHAR2(50) PRIMARY KEY,
    customer_id VARCHAR2(50) NOT NULL,
    usage_date DATE NOT NULL,
    kwh_used NUMBER(10,2) NOT NULL,
    peak_demand NUMBER(10,2),
    off_peak_usage NUMBER(10,2),
    cost_per_kwh NUMBER(8,4),
    total_cost NUMBER(10,2),
    temperature NUMBER(5,2),
    day_of_week NUMBER(1),
    month NUMBER(2),
    season VARCHAR2(10),
    home_type VARCHAR2(50),
    home_size_range VARCHAR2(20),
    coordinates SDO_GEOMETRY, -- For spatial queries
    created_date DATE DEFAULT SYSDATE,
    CONSTRAINT fk_usage_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT uk_usage_customer_date UNIQUE (customer_id, usage_date)
);

-- Hourly usage data for detailed analysis
CREATE TABLE hourly_usage (
    hourly_id VARCHAR2(50) PRIMARY KEY,
    customer_id VARCHAR2(50) NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    kwh_used NUMBER(8,3) NOT NULL,
    cost NUMBER(8,4),
    demand NUMBER(8,3),
    created_date DATE DEFAULT SYSDATE,
    CONSTRAINT fk_hourly_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT uk_hourly_customer_time UNIQUE (customer_id, timestamp)
);

-- Bills table
CREATE TABLE bills (
    bill_id VARCHAR2(50) PRIMARY KEY,
    customer_id VARCHAR2(50) NOT NULL,
    amount NUMBER(10,2) NOT NULL,
    due_date DATE NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    status VARCHAR2(20) NOT NULL, -- CURRENT, OVERDUE, PAID
    energy_charges NUMBER(10,2),
    delivery_charges NUMBER(10,2),
    taxes NUMBER(10,2),
    fees NUMBER(10,2),
    created_date DATE DEFAULT SYSDATE,
    CONSTRAINT fk_bill_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Payments table
CREATE TABLE payments (
    payment_id VARCHAR2(50) PRIMARY KEY,
    customer_id VARCHAR2(50) NOT NULL,
    bill_id VARCHAR2(50) NOT NULL,
    amount NUMBER(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR2(50), -- CREDIT_CARD, BANK_TRANSFER, CHECK, CASH
    transaction_id VARCHAR2(100),
    status VARCHAR2(20) DEFAULT 'COMPLETED',
    created_date DATE DEFAULT SYSDATE,
    CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_payment_bill FOREIGN KEY (bill_id) REFERENCES bills(bill_id)
);

-- Payment plans table
CREATE TABLE payment_plans (
    plan_id VARCHAR2(50) PRIMARY KEY,
    customer_id VARCHAR2(50) NOT NULL,
    plan_type VARCHAR2(50) NOT NULL, -- EQUAL_PAYMENTS, BUDGET_BILLING, DEFERRED
    number_of_payments NUMBER(3),
    preferred_date NUMBER(2), -- Day of month (1-31)
    total_amount NUMBER(10,2),
    monthly_amount NUMBER(10,2),
    status VARCHAR2(20) DEFAULT 'ACTIVE', -- ACTIVE, COMPLETED, CANCELLED
    created_date DATE DEFAULT SYSDATE,
    start_date DATE,
    end_date DATE,
    CONSTRAINT fk_plan_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Service requests table
CREATE TABLE service_requests (
    request_id VARCHAR2(50) PRIMARY KEY,
    customer_id VARCHAR2(50) NOT NULL,
    request_type VARCHAR2(100) NOT NULL, -- REPAIR, INSTALLATION, MAINTENANCE, METER_READ
    description CLOB,
    priority VARCHAR2(20) DEFAULT 'NORMAL', -- LOW, NORMAL, HIGH, URGENT
    contact_preference VARCHAR2(20) DEFAULT 'EMAIL', -- EMAIL, PHONE, SMS
    status VARCHAR2(30) DEFAULT 'SUBMITTED', -- SUBMITTED, ASSIGNED, IN_PROGRESS, COMPLETED, CANCELLED
    created_date DATE DEFAULT SYSDATE,
    estimated_completion DATE,
    actual_completion DATE,
    assigned_technician VARCHAR2(100),
    CONSTRAINT fk_request_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Service request updates/notes
CREATE TABLE service_updates (
    update_id VARCHAR2(50) PRIMARY KEY,
    request_id VARCHAR2(50) NOT NULL,
    update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR2(30),
    notes CLOB,
    updated_by VARCHAR2(100),
    CONSTRAINT fk_update_request FOREIGN KEY (request_id) REFERENCES service_requests(request_id)
);

-- Notification preferences
CREATE TABLE notification_preferences (
    pref_id VARCHAR2(50) PRIMARY KEY,
    customer_id VARCHAR2(50) NOT NULL,
    bill_reminders NUMBER(1,0) DEFAULT 1, -- 0=No, 1=Yes
    outage_alerts NUMBER(1,0) DEFAULT 1,
    usage_alerts NUMBER(1,0) DEFAULT 0,
    savings_tips NUMBER(1,0) DEFAULT 1,
    email_enabled NUMBER(1,0) DEFAULT 1,
    sms_enabled NUMBER(1,0) DEFAULT 0,
    push_enabled NUMBER(1,0) DEFAULT 0,
    created_date DATE DEFAULT SYSDATE,
    updated_date DATE DEFAULT SYSDATE,
    CONSTRAINT fk_pref_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT uk_pref_customer UNIQUE (customer_id)
);

-- Create indexes for performance
CREATE INDEX idx_customer_account ON customers(account_number);
CREATE INDEX idx_customer_email ON customers(email);
CREATE INDEX idx_customer_location ON customers(service_zip);

CREATE INDEX idx_usage_customer_date ON usage_data(customer_id, usage_date);
CREATE INDEX idx_usage_date ON usage_data(usage_date);
CREATE INDEX idx_usage_month ON usage_data(month);

CREATE INDEX idx_hourly_customer_time ON hourly_usage(customer_id, timestamp);
CREATE INDEX idx_hourly_timestamp ON hourly_usage(timestamp);

CREATE INDEX idx_bill_customer_status ON bills(customer_id, status);
CREATE INDEX idx_bill_due_date ON bills(due_date);

CREATE INDEX idx_payment_customer ON payments(customer_id);
CREATE INDEX idx_payment_date ON payments(payment_date);

CREATE INDEX idx_request_customer_status ON service_requests(customer_id, status);
CREATE INDEX idx_request_status ON service_requests(status);
CREATE INDEX idx_request_type ON service_requests(request_type);

CREATE INDEX idx_weather_date_zip ON weather_data(date, location_zip);

-- Create sequences for ID generation
CREATE SEQUENCE seq_usage_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_hourly_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_bill_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_payment_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_profile_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_weather_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_update_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pref_id START WITH 1 INCREMENT BY 1;

-- Sample data for testing
INSERT INTO customers VALUES (
    'CUST001', 'ACC12345', 'John', 'Doe', 'john.doe@email.com', '555-0123',
    '123 Main St', 'Springfield', 'IL', '62701', 39.7817, -89.6501,
    'single_family', 2500, 4, SYSDATE, SYSDATE
);

INSERT INTO customers VALUES (
    'CUST002', 'ACC12346', 'Jane', 'Smith', 'jane.smith@email.com', '555-0124',
    '456 Oak Ave', 'Springfield', 'IL', '62702', 39.7917, -89.6401,
    'townhouse', 1800, 2, SYSDATE, SYSDATE
);

INSERT INTO energy_profiles VALUES (
    'PROF001', 'CUST001', 1250.50, '17,18,19,20', 'summer_heavy', 'central_ac',
    0, 1, SYSDATE, SYSDATE
);

INSERT INTO energy_profiles VALUES (
    'PROF002', 'CUST002', 890.25, '16,17,18,19', 'balanced', 'heat_pump',
    1, 0, SYSDATE, SYSDATE
);

-- Sample usage data for the past 30 days
DECLARE
    v_date DATE := SYSDATE - 30;
    v_usage NUMBER;
    v_cost NUMBER;
BEGIN
    FOR i IN 1..30 LOOP
        -- Customer 1 usage
        v_usage := 35 + DBMS_RANDOM.VALUE(-10, 15);
        v_cost := v_usage * 0.12;
        
        INSERT INTO usage_data VALUES (
            'USAGE' || LPAD(seq_usage_id.NEXTVAL, 6, '0'),
            'CUST001',
            v_date + i,
            v_usage,
            v_usage * 0.3,
            v_usage * 0.6,
            0.12,
            v_cost,
            70 + DBMS_RANDOM.VALUE(-20, 25),
            TO_NUMBER(TO_CHAR(v_date + i, 'D')),
            TO_NUMBER(TO_CHAR(v_date + i, 'MM')),
            CASE WHEN TO_NUMBER(TO_CHAR(v_date + i, 'MM')) IN (6,7,8) THEN 'summer'
                 WHEN TO_NUMBER(TO_CHAR(v_date + i, 'MM')) IN (12,1,2) THEN 'winter'
                 ELSE 'mild' END,
            'single_family',
            '2000-3000',
            NULL,
            SYSDATE
        );
        
        -- Customer 2 usage
        v_usage := 25 + DBMS_RANDOM.VALUE(-8, 12);
        v_cost := v_usage * 0.12;
        
        INSERT INTO usage_data VALUES (
            'USAGE' || LPAD(seq_usage_id.NEXTVAL, 6, '0'),
            'CUST002',
            v_date + i,
            v_usage,
            v_usage * 0.25,
            v_usage * 0.65,
            0.12,
            v_cost,
            70 + DBMS_RANDOM.VALUE(-20, 25),
            TO_NUMBER(TO_CHAR(v_date + i, 'D')),
            TO_NUMBER(TO_CHAR(v_date + i, 'MM')),
            CASE WHEN TO_NUMBER(TO_CHAR(v_date + i, 'MM')) IN (6,7,8) THEN 'summer'
                 WHEN TO_NUMBER(TO_CHAR(v_date + i, 'MM')) IN (12,1,2) THEN 'winter'
                 ELSE 'mild' END,
            'townhouse',
            '1500-2000',
            NULL,
            SYSDATE
        );
    END LOOP;
    COMMIT;
END;
/

-- Sample bills
INSERT INTO bills VALUES (
    'BILL001', 'CUST001', 185.50, SYSDATE + 15, SYSDATE - 30, SYSDATE,
    'CURRENT', 145.60, 25.90, 10.50, 3.50, SYSDATE
);

INSERT INTO bills VALUES (
    'BILL002', 'CUST002', 132.75, SYSDATE + 12, SYSDATE - 30, SYSDATE,
    'CURRENT', 105.25, 18.50, 7.25, 1.75, SYSDATE
);

-- Sample notification preferences
INSERT INTO notification_preferences VALUES (
    'PREF001', 'CUST001', 1, 1, 1, 1, 1, 1, 0, SYSDATE, SYSDATE
);

INSERT INTO notification_preferences VALUES (
    'PREF002', 'CUST002', 1, 1, 0, 1, 1, 0, 1, SYSDATE, SYSDATE
);

-- Create views for common queries
CREATE OR REPLACE VIEW customer_summary AS
SELECT 
    c.customer_id,
    c.account_number,
    c.first_name || ' ' || c.last_name AS full_name,
    c.email,
    c.service_city || ', ' || c.service_state AS location,
    ep.avg_monthly_usage,
    ep.seasonal_pattern,
    b.amount AS current_bill_amount,
    b.due_date AS current_bill_due,
    COUNT(sr.request_id) AS open_service_requests
FROM customers c
LEFT JOIN energy_profiles ep ON c.customer_id = ep.customer_id
LEFT JOIN bills b ON c.customer_id = b.customer_id AND b.status = 'CURRENT'
LEFT JOIN service_requests sr ON c.customer_id = sr.customer_id AND sr.status IN ('SUBMITTED', 'ASSIGNED', 'IN_PROGRESS')
GROUP BY c.customer_id, c.account_number, c.first_name, c.last_name, c.email, 
         c.service_city, c.service_state, ep.avg_monthly_usage, ep.seasonal_pattern,
         b.amount, b.due_date;

CREATE OR REPLACE VIEW usage_analytics AS
SELECT 
    u.customer_id,
    TRUNC(u.usage_date, 'MM') AS usage_month,
    SUM(u.kwh_used) AS total_kwh,
    AVG(u.kwh_used) AS avg_daily_kwh,
    MAX(u.peak_demand) AS max_peak_demand,
    SUM(u.total_cost) AS total_cost,
    AVG(u.temperature) AS avg_temperature
FROM usage_data u
GROUP BY u.customer_id, TRUNC(u.usage_date, 'MM');

-- Commit all changes
COMMIT;

-- Display table information
SELECT 'Database schema created successfully!' AS status FROM dual;

SELECT table_name, num_rows 
FROM user_tables 
WHERE table_name IN ('CUSTOMERS', 'ENERGY_PROFILES', 'USAGE_DATA', 'BILLS', 'NOTIFICATION_PREFERENCES')
ORDER BY table_name;
