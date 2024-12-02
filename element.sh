#!/bin/bash

# Verificar si se proporciona un argumento
if [ -z "$1" ]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Si el argumento es un número (atomic_number), usarlo directamente
if [[ "$1" =~ ^[0-9]+$ ]]; then
  QUERY_CONDITION="e.atomic_number = $1"
else
  # Si el argumento es un nombre o símbolo, usarlo para la búsqueda
  QUERY_CONDITION="e.symbol = '$1' OR e.name ILIKE '$1'"
fi

# Realizar la consulta a la base de datos usando el usuario correcto (postgres)
ELEMENT_INFO=$(psql -U postgres -d periodic_table -t -c "
  SELECT 
    e.atomic_number, 
    e.symbol, 
    e.name, 
    t.type, 
    p.atomic_mass, 
    p.melting_point_celsius, 
    p.boiling_point_celsius 
  FROM properties p
  JOIN elements e ON p.atomic_number = e.atomic_number
  JOIN types t ON p.type_id = t.type_id
  WHERE $QUERY_CONDITION")

# Verificar si se obtuvo un resultado de la consulta
if [ -z "$ELEMENT_INFO" ]; then
  echo "I could not find that element in the database."
else
  # Extraer los valores desde el resultado
  atomic_number=$(echo "$ELEMENT_INFO" | cut -d '|' -f 1 | tr -d ' ')
  symbol=$(echo "$ELEMENT_INFO" | cut -d '|' -f 2 | tr -d ' ')
  name=$(echo "$ELEMENT_INFO" | cut -d '|' -f 3 | tr -d ' ')
  type=$(echo "$ELEMENT_INFO" | cut -d '|' -f 4 | tr -d ' ')
  atomic_mass=$(echo "$ELEMENT_INFO" | cut -d '|' -f 5 | tr -d ' ')
  melting_point=$(echo "$ELEMENT_INFO" | cut -d '|' -f 6 | tr -d ' ')
  boiling_point=$(echo "$ELEMENT_INFO" | cut -d '|' -f 7 | tr -d ' ')

  # Mostrar la información
  echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
fi

