# Practica de base de datos distribuidas - Replicacion Bidireccional

## Enunciado del problema

Una cadena de clínicas veterinarias tiene dos sucursales: una en Quito y otra en Cuenca.
Cada sucursal registra sus propias citas, mascotas, propietarios y servicios realizados.

Sin embargo, la administración necesita que:

- Los datos de mascotas y propietarios estén sincronizados.

- Los clientes deben poder llevar a su mascota a cualquiera de las dos sedes sin necesidad de volver a registrarla.

- Los catálogos de servicios (vacunas, consultas, baños, cirugías, precios) sean idénticos.

- Ambas sucursales deben ofrecer la misma información, precios y tipos de servicios.

- Las citas y servicios aplicados se repliquen.

- Para poder consultar historiales clínicos desde cualquier sucursal.

# Para levantar las 2 bases de datos con docker usar el comando

```bash
docker compose up -d
```

```mermaid
erDiagram

    PROPIETARIOS {
        id uuid PK
        nombre varchar
        identificacion varchar
        telefono varchar
        email varchar
        origen varchar
        creado_en timestamp
    }

    MASCOTAS {
        id uuid PK
        id_propietario uuid FK
        nombre varchar
        especie varchar
        raza varchar
        fecha_nacimiento date
        origen varchar
        creado_en timestamp
    }

    SERVICIOS {
        id uuid PK
        codigo varchar
        nombre varchar
        descripcion text
        precio numeric
        activo boolean
        creado_en timestamp
    }

    CONSULTAS {
        id uuid PK
        id_mascota uuid FK
        fecha_consulta timestamp
        motivo text
        diagnostico text
        observaciones text
        origen varchar
        creado_en timestamp
    }

    CONSULTA_SERVICIO {
        id uuid PK
        id_consulta uuid FK
        id_servicio uuid FK
        cantidad integer
        precio_unitario numeric
        origen varchar
        creado_en timestamp
    }

    PROPIETARIOS ||--o{ MASCOTAS : tiene
    MASCOTAS ||--o{ CONSULTAS : registra
    CONSULTAS ||--o{ CONSULTA_SERVICIO : incluye
    SERVICIOS ||--o{ CONSULTA_SERVICIO : aplicado_en
```