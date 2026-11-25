CREATE TABLE users (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    iin VARCHAR(12) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    role VARCHAR(50) NOT NULL
);

CREATE TABLE specializations (
    spec_id INT PRIMARY KEY,
    spec_name VARCHAR(150) NOT NULL,
    department VARCHAR(150) NOT NULL
);

CREATE TABLE doctor_specializations (
    record_id INT PRIMARY KEY,
    doctor_id INT NOT NULL,
    spec_id INT NOT NULL,
    experience_years INT NOT NULL,
    license_number VARCHAR(100) NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES users(user_id),
    FOREIGN KEY (spec_id) REFERENCES specializations(spec_id)
);

CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date TIMESTAMP NOT NULL,
    meeting_link VARCHAR(200) NOT NULL,
    status VARCHAR(50) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES users(user_id),
    FOREIGN KEY (doctor_id) REFERENCES users(user_id)
);

CREATE TABLE medical_records (
    record_id INT PRIMARY KEY,
    appointment_id INT NOT NULL,
    symptoms VARCHAR(200) NOT NULL,
    diagnosis VARCHAR(200) NOT NULL,
    prescription VARCHAR(200) NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    appointment_id INT NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_status VARCHAR(50) NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

INSERT INTO users VALUES
(1, 'Каримов Ислам', '040315500111', 'islam@aues.kz', 'patient'),
(2, 'Сейітова Амина', '040822600222', 'amina@mail.kz', 'patient'),
(3, 'Др. Ахметов Ерлан', '850410300333', 'erlan.doc@telemed.kz', 'doctor'),
(4, 'Др. Нұрғалиева Динара', '900918400444', 'dinara.doc@telemed.kz', 'doctor');

INSERT INTO specializations VALUES
(10, 'Кардиолог', 'Жүрек-қантамыр бөлімі'),
(20, 'Терапевт', 'Жалпы медицина бөлімі'),
(30, 'Невропатолог', 'Неврология бөлімі');

INSERT INTO doctor_specializations VALUES
(101, 3, 10, 12, 'KZ-MED-2014-881'),
(102, 3, 20, 12, 'KZ-MED-2014-882'),
(103, 4, 30, 8, 'KZ-MED-2018-415');

INSERT INTO appointments VALUES
(201, 1, 3, '2026-11-20 10:00:00', 'https://meet.telemed.kz/room-201', 'completed'),
(202, 2, 4, '2026-11-22 14:30:00', 'https://meet.telemed.kz/room-202', 'confirmed'),
(203, 1, 4, '2026-11-25 16:00:00', 'https://meet.telemed.kz/room-203', 'pending'),
(204, 2, 3, '2026-11-26 11:00:00', 'https://meet.telemed.kz/room-204', 'confirmed');

INSERT INTO medical_records VALUES
(301, 201, 'Қан қысымының көтерілуі', 'Артериялық гипертензия I дәреже', 'Күнделікті қысым бақылау және диета'),
(302, 202, 'Бас ауруы және ұйқысыздық', 'Вегетативті дистония', 'Дәрумендер кешені және демалыс режимі'),
(303, 204, 'Жүрек соғысының жиілеуі', 'Синустық тахикардия', 'ЭКГ тексерісінен өту');

INSERT INTO payments VALUES
(401, 201, 8000.00, 'Kaspi QR', 'paid'),
(402, 202, 7500.00, 'Банк картасы', 'paid'),
(403, 203, 7500.00, 'Kaspi QR', 'pending'),
(404, 204, 8000.00, 'Банк картасы', 'paid');

SELECT
    u.full_name AS patient_name,
    a.appointment_date,
    a.status AS appointment_status,
    m.diagnosis,
    p.amount AS paid_amount
FROM users u
JOIN appointments a ON u.user_id = a.patient_id
JOIN medical_records m ON a.appointment_id = m.appointment_id
JOIN payments p ON a.appointment_id = p.appointment_id;

SELECT
    status AS appointment_status,
    COUNT(appointment_id) AS total_appointments
FROM appointments
GROUP BY status;