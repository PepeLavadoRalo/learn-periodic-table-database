-- Crear la base de datos
CREATE DATABASE periodic_table;

-- Seleccionar la base de datos
\c periodic_table;

-- Crear tabla para elementos (elements)
CREATE TABLE elements (
    atomic_number INTEGER PRIMARY KEY,
    symbol VARCHAR(2) NOT NULL,
    name VARCHAR(40) NOT NULL,
    type VARCHAR(20) NOT NULL
);

-- Crear tabla para propiedades (properties)
CREATE TABLE properties (
    atomic_number INTEGER PRIMARY KEY,
    atomic_mass NUMERIC NOT NULL,
    melting_point_celsius NUMERIC NOT NULL,
    boiling_point_celsius NUMERIC NOT NULL,
    type_id INTEGER NOT NULL,
    FOREIGN KEY (atomic_number) REFERENCES elements(atomic_number)
);

-- Crear tabla para tipos (types)
CREATE TABLE types (
    type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL
);

-- Insertar algunos datos de ejemplo en la tabla types
INSERT INTO types (type_name) VALUES ('Nonmetal'), ('Metal'), ('Metalloid');

-- Insertar algunos datos de ejemplo en la tabla elements
INSERT INTO elements (atomic_number, symbol, name, type) VALUES
(1, 'H', 'Hydrogen', 'Nonmetal'),
(2, 'He', 'Helium', 'Nonmetal'),
(3, 'Li', 'Lithium', 'Metal');

-- Insertar algunos datos de ejemplo en la tabla properties
INSERT INTO properties (atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) VALUES
(1, 1.008, -259.1, -252.9, 1),
(2, 4.0026, -272.2, -268.9, 1),
(3, 6.94, 180.5, 159.4, 2);

