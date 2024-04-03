-- Generated by Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   at:        2023-12-13 22:31:58 EET
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE cultura (
    id_cultura         NUMBER(5) NOT NULL,
    tip_cultura        VARCHAR2(10) NOT NULL,
    perioada_cultivare VARCHAR2(10) NOT NULL,
    data_cultivare     DATE,
    planta_id_planta   NUMBER(5) NOT NULL
);

ALTER TABLE cultura
    ADD CHECK ( tip_cultura IN ( 'cereale', 'fructe', 'legume' ) );

ALTER TABLE cultura
    ADD CHECK ( perioada_cultivare IN ( 'iarna', 'primavara', 'toamna', 'vara' ) );


ALTER TABLE cultura ADD CONSTRAINT cultura_pk PRIMARY KEY ( id_cultura );

CREATE SEQUENCE cultura_seq
  START WITH 1
  INCREMENT BY 1
  NOMAXVALUE
  NOCYCLE;

CREATE TABLE fermier (
    id_fermier      NUMBER(5) NOT NULL,
    nume_fermier    VARCHAR2(20) NOT NULL,
    prenume_fermier VARCHAR2(20) NOT NULL,
    cnp             NUMBER(13),
    adresa          VARCHAR2(40)
);

ALTER TABLE fermier
    ADD CONSTRAINT fermier_nume_ck CHECK ( REGEXP_LIKE ( nume_fermier,
                                                         '[A-Z][a-z]{1,}' ) );

ALTER TABLE fermier
    ADD CONSTRAINT fermier_prenume_ck CHECK ( REGEXP_LIKE ( prenume_fermier,
                                                            '[A-Z][a-z]{1,}' ) );

ALTER TABLE fermier ADD CONSTRAINT fermier_pk PRIMARY KEY ( id_fermier );

ALTER TABLE fermier ADD CONSTRAINT fermier_cnp_un UNIQUE ( cnp );

CREATE SEQUENCE fermier_seq
  START WITH 1
  INCREMENT BY 1
  NOMAXVALUE
  NOCYCLE;

CREATE TABLE planta (
    id_planta       NUMBER(5) NOT NULL,
    denumire_planta VARCHAR2(10) NOT NULL,
    tip_planta      VARCHAR2(10)
);

ALTER TABLE planta
    ADD CONSTRAINT planta_denumire_ck CHECK ( REGEXP_LIKE ( denumire_planta,
                                                            '[A-Z][a-z\s]' ) );

ALTER TABLE planta
    ADD CONSTRAINT planta_tip_ck CHECK ( REGEXP_LIKE ( tip_planta,
                                                       '[A-Z][a-z\s]' ) );

ALTER TABLE planta ADD CONSTRAINT planta_pk PRIMARY KEY ( id_planta );

CREATE TABLE seminte (
    id_seminte      NUMBER(5) NOT NULL,
    calitate        VARCHAR2(10) NOT NULL,
    pret_kg_vanzare NUMBER(3) NOT NULL,
    producator      VARCHAR2(20),
    soi_id_soi      NUMBER(2) NOT NULL
);

ALTER TABLE seminte ADD CONSTRAINT seminte_pk PRIMARY KEY ( id_seminte,
                                                            soi_id_soi );

CREATE TABLE soi (
    id_soi           NUMBER(2) NOT NULL,
    denumire_soi     VARCHAR2(20) NOT NULL,
    nr_luni_crestere NUMBER(3) NOT NULL,
    descriere        VARCHAR2(50),
    planta_id_planta NUMBER(5) NOT NULL
);

ALTER TABLE soi
    ADD CONSTRAINT soi_denumire_ck CHECK ( REGEXP_LIKE ( denumire_soi,
                                                         '[A-Z][a-z\s]' ) );

ALTER TABLE soi
    ADD CONSTRAINT soi_descriere_ck CHECK ( REGEXP_LIKE ( descriere,
                                                          '[A-Z][a-z\s]' ) );

ALTER TABLE soi ADD CONSTRAINT soi_pk PRIMARY KEY ( id_soi );

ALTER TABLE soi ADD CONSTRAINT soi_denumire_soi_un UNIQUE ( denumire_soi );

CREATE TABLE teren (
    id_teren           NUMBER(5) NOT NULL,
    suprafata_teren    NUMBER(4) NOT NULL,
    tip_teren          VARCHAR2(10) DEFAULT 'arabil' NOT NULL,
    fermier_id_fermier NUMBER(5) NOT NULL,
    cultura_id_cultura NUMBER(5) NOT NULL
);

ALTER TABLE teren
    ADD CHECK ( tip_teren IN ( 'arabil', 'pomicol', 'sera', 'viticol' ) );

ALTER TABLE teren ADD CONSTRAINT teren_pk PRIMARY KEY ( id_teren );

ALTER TABLE teren ADD CONSTRAINT teren_id_teren_un UNIQUE ( id_teren );

ALTER TABLE cultura
    ADD CONSTRAINT cultura_planta_fk FOREIGN KEY ( planta_id_planta )
        REFERENCES planta ( id_planta );

ALTER TABLE seminte
    ADD CONSTRAINT seminte_soi_fk FOREIGN KEY ( soi_id_soi )
        REFERENCES soi ( id_soi );

ALTER TABLE soi
    ADD CONSTRAINT soi_planta_fk FOREIGN KEY ( planta_id_planta )
        REFERENCES planta ( id_planta );

ALTER TABLE teren
    ADD CONSTRAINT teren_cultura_fk FOREIGN KEY ( cultura_id_cultura )
        REFERENCES cultura ( id_cultura );

ALTER TABLE teren
    ADD CONSTRAINT teren_fermier_fk FOREIGN KEY ( fermier_id_fermier )
        REFERENCES fermier ( id_fermier );

CREATE SEQUENCE cultura_id_cultura_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE teren_seq
  START WITH 1
  INCREMENT BY 1
  NOMAXVALUE
  NOCYCLE;

CREATE OR REPLACE TRIGGER cultura_id_cultura_trg BEFORE
    INSERT ON cultura
    FOR EACH ROW
    WHEN ( new.id_cultura IS NULL )
BEGIN
    :new.id_cultura := cultura_id_cultura_seq.nextval;
END;
/

CREATE SEQUENCE fermier_id_fermier_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER fermier_id_fermier_trg BEFORE
    INSERT ON fermier
    FOR EACH ROW
    WHEN ( new.id_fermier IS NULL )
BEGIN
    :new.id_fermier := fermier_id_fermier_seq.nextval;
END;
/

CREATE SEQUENCE planta_id_planta_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER planta_id_planta_trg BEFORE
    INSERT ON planta
    FOR EACH ROW
    WHEN ( new.id_planta IS NULL )
BEGIN
    :new.id_planta := planta_id_planta_seq.nextval;
END;
/

CREATE SEQUENCE seminte_id_seminte_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER seminte_id_seminte_trg BEFORE
    INSERT ON seminte
    FOR EACH ROW
    WHEN ( new.id_seminte IS NULL )
BEGIN
    :new.id_seminte := seminte_id_seminte_seq.nextval;
END;
/

CREATE SEQUENCE soi_id_soi_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER soi_id_soi_trg BEFORE
    INSERT ON soi
    FOR EACH ROW
    WHEN ( new.id_soi IS NULL )
BEGIN
    :new.id_soi := soi_id_soi_seq.nextval;
END;
/

CREATE SEQUENCE teren_id_teren_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER teren_id_teren_trg BEFORE
    INSERT ON teren
    FOR EACH ROW
    WHEN ( new.id_teren IS NULL )
BEGIN
    :new.id_teren := teren_id_teren_seq.nextval;
END;
/



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             6
-- CREATE INDEX                             1
-- ALTER TABLE                             23
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           6
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          6
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0