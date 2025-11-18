CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- PROPIETARIOS
CREATE TABLE propietarios (
    id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre          varchar(150) NOT NULL,
    identificacion  varchar(50)  NOT NULL,
    telefono        varchar(50),
    email           varchar(150),
    origen          varchar(20)  NOT NULL,
    creado_en       timestamptz  NOT NULL DEFAULT now()
);

-- MASCOTAS
CREATE TABLE mascotas (
    id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_propietario  uuid        NOT NULL,
    nombre          varchar(150) NOT NULL,
    especie         varchar(50)  NOT NULL,
    raza            varchar(100),
    fecha_nacimiento date,
    origen          varchar(20)  NOT NULL,
    creado_en       timestamptz  NOT NULL DEFAULT now(),
    CONSTRAINT fk_mascotas_propietarios
        FOREIGN KEY (id_propietario)
        REFERENCES propietarios (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- SERVICIOS
CREATE TABLE servicios (
    id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    codigo          varchar(50)  NOT NULL UNIQUE,   
    nombre          varchar(150) NOT NULL,
    descripcion     text,
    precio          numeric(10,2) NOT NULL,
    activo          boolean       NOT NULL DEFAULT true,
    creado_en       timestamptz   NOT NULL DEFAULT now()
);

-- CONSULTAS
CREATE TABLE consultas (
    id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_mascota      uuid        NOT NULL,
    fecha_consulta  timestamptz NOT NULL,
    motivo          text,
    diagnostico     text,
    observaciones   text,
    origen          varchar(20) NOT NULL,
    creado_en       timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT fk_consultas_mascotas
        FOREIGN KEY (id_mascota)
        REFERENCES mascotas (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- CONSULTA_SERVICIO (SERVICIOS APLICADOS EN UNA CONSULTA)
CREATE TABLE consulta_servicio (
    id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_consulta     uuid        NOT NULL,
    id_servicio     uuid        NOT NULL,
    cantidad        integer     NOT NULL DEFAULT 1,
    precio_unitario numeric(10,2) NOT NULL,
    origen          varchar(20) NOT NULL,
    creado_en       timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT fk_cs_consultas
        FOREIGN KEY (id_consulta)
        REFERENCES consultas (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_cs_servicios
        FOREIGN KEY (id_servicio)
        REFERENCES servicios (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


create publication pub_propietario for table propietarios where (origen = 'quito')

create subscription sub_propietario_quito
	connection 'host=cuenca-db port=5432 dbname=cuencadb user= postgres password=postgres'
	publication pub_propietario_cuenca;

select * from propietarios;

create publication pub_mascotas_quito for table mascotas where (origen = 'quito');

create subscription sub_mascotas_quito
	connection 'host=cuenca-db port=5432 dbname=cuencadb user= postgres password= postgres'
	publication pub_mascotas_cuenca;

WITH nuevo_prop AS (
    INSERT INTO propietarios (nombre, identificacion, telefono, email, origen)
    VALUES ('Juan Pérez', '1723456789', '0999999999', 'juan.perez@example.com', 'quito')
    RETURNING id
)
INSERT INTO mascotas (id_propietario, nombre, especie, raza, fecha_nacimiento, origen)
SELECT id, 'Firulais', 'perro', 'Labrador', '2020-05-10', 'quito'
FROM nuevo_prop;

select * from mascotas;





