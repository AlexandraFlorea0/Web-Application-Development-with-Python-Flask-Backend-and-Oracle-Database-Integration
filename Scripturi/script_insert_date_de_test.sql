-- Date de inserare(se pastreaza ordinea, deoarece tabelele care depind de alte tabele vor da eroare din cauza ca nu gasesc FOREIGN-KEY valabil
-- Am adaugat si exemle de inserari nevalide in acest document(pentru a fi mai usor de identificat motivul pentru care sunt nevalide.

--FERMIER:

-- Inserari valide:

INSERT INTO fermier VALUES(null, 'Ionescu', 'Andrei',1800101221144,'Strada Victoriei nr. 123, Iași'); 
INSERT INTO fermier VALUES(null, 'Popescu', 'Alin',1950101221149,'Bulevardul Ștefan cel Mare și Sfânt nr. 45A, Iași');
INSERT INTO fermier VALUES(null, 'Enache', 'Tudor',1850526331236,'Aleea Crizantemelor nr. 7, Iași');
INSERT INTO fermier VALUES(70, 'Gavrilescu', 'Mihai',5000602123458,'Aleea Mihai Eminescu nr. 12, Iași');
INSERT INTO fermier VALUES(null, 'Nicolescu', 'Marian',1790408123469, null); 
-- adresa nu este obligatorie


--Inserari nevalide:

INSERT INTO fermier VALUES(null, 'Petrica', 'Cezar',5000602123458,'Aleea Zambilelor nr. 64, Iași'); 
-- are acelasi cnp ca o inregistrare anterioara
INSERT INTO fermier VALUES(null, null, 'Cezar',5000602123459,'Aleea Zambilelor nr. 64, Iași'); 
INSERT INTO fermier VALUES(null, 'Petrica', null ,5000602123459,'Aleea Zambilelor nr. 64, Iași'); 
-- numele/prenumele este obligatoriu, not null
INSERT INTO fermier VALUES(70, 'Petrica', null ,5000602123459,'Aleea Zambilelor nr. 64, Iași'); 
-- nu se respecta unicitatea ID-ului

select * from fermier;

--PLANTA:

-- Inserari valide:

insert into planta VALUES(null, 'Rosie', 'Anuala');
insert into planta VALUES(null, 'Par', 'Peren');
insert into planta VALUES(30, 'Strugure', 'Peren');
insert into planta VALUES(null, 'Morcov', 'Bianual');
insert into planta VALUES(null, 'Grau', 'Anual');


-- Inserari nevalide:

insert into planta VALUES(null, 'castravete', 'anuala');
--in constrangere scrie ca tipul si denumirea incep cu litere mari
insert into planta VALUES(30, 'Castravete', 'Peren');
-- nu se respecta unicitatea ID-ului

select * from planta;

--CULTURA:

-- Inserari valide:

INSERT INTO cultura VALUES(NULL, 'cereale', 'toamna', '10-OCT-22', (SELECT id_planta FROM planta WHERE denumire_planta = 'Grau'));
INSERT INTO cultura VALUES(NULL, 'fructe', 'toamna', '17-SEP-12', (SELECT id_planta FROM planta WHERE denumire_planta = 'Par'));
INSERT INTO cultura VALUES(NULL, 'fructe', 'primavara', '20-MAR-17', (SELECT id_planta FROM planta WHERE denumire_planta = 'Strugure'));
INSERT INTO cultura VALUES(NULL, 'legume', 'primavara', '10-MAR-23', (SELECT id_planta FROM planta WHERE denumire_planta = 'Morcov'));
INSERT INTO cultura VALUES(20, 'legume', 'primavara', '28-FEB-23', (SELECT id_planta FROM planta WHERE denumire_planta = 'Rosie'));

-- Inserari nevalide:

INSERT INTO cultura VALUES(NULL, 'legume', 'primavara', '28-FEB-23', (SELECT id_planta FROM planta WHERE denumire_planta = 'Rosie'));
--pe o cultura poate fi un singur tip de planta
INSERT INTO cultura VALUES(20, 'legume', 'primavara', '28-FEB-23', (SELECT id_planta FROM planta WHERE denumire_planta = 'Cartof'));
-- cheia primara nu se poate repeta
INSERT INTO cultura VALUES(null, 'legume', 'primavara', '28-FEB-23', (SELECT id_planta FROM planta WHERE denumire_planta = 'Cartof'));
-- nu exista inregistrare pentru cartof in planta

select * from cultura;

--TEREN:

-- Inserari valide:

INSERT INTO teren VALUES (null, 2, 'arabil', (SELECT id_fermier FROM fermier WHERE nume_fermier = 'Ionescu'), (SELECT id_cultura FROM cultura WHERE data_cultivare = '10-MAR-23'));
INSERT INTO teren VALUES (null, 15, 'arabil', (SELECT id_fermier FROM fermier WHERE nume_fermier = 'Enache'), (SELECT id_cultura FROM cultura WHERE data_cultivare = '10-MAR-23'));
INSERT INTO teren VALUES (null, 8, 'pomicol', (SELECT id_fermier FROM fermier WHERE nume_fermier = 'Ionescu'), (SELECT id_cultura FROM cultura WHERE data_cultivare = '17-SEP-12'));
INSERT INTO teren VALUES (null, 5, 'sera', (SELECT id_fermier FROM fermier WHERE nume_fermier = 'Gavrilescu'), (SELECT id_cultura FROM cultura WHERE data_cultivare = '28-FEB-23'));
INSERT INTO teren VALUES (null, 2, 'viticol', (SELECT id_fermier FROM fermier WHERE nume_fermier = 'Nicolescu'), (SELECT id_cultura FROM cultura WHERE data_cultivare = '20-MAR-17'));
INSERT INTO teren VALUES (40, 4, 'arabil', (SELECT id_fermier FROM fermier WHERE nume_fermier = 'Ionescu'), (SELECT id_cultura FROM cultura WHERE data_cultivare = '10-OCT-22'));

-- Inserari nevalide:

INSERT INTO teren VALUES (null, 4, 'gradina', (SELECT id_fermier FROM fermier WHERE nume_fermier = 'Ionescu'), (SELECT id_cultura FROM cultura WHERE data_cultivare = '10-OCT-22'));
-- nu exista optiunea pentru gradina
INSERT INTO teren VALUES (40, 5, 'arabil', (SELECT id_fermier FROM fermier WHERE nume_fermier = 'Ionescu'), (SELECT id_cultura FROM cultura WHERE data_cultivare = '10-OCT-22'));
-- nu se poate folosi aceeasi valoare cheii primare
INSERT INTO teren VALUES (40, 5, 'arabil', (SELECT id_fermier FROM fermier WHERE nume_fermier = 'Moise'), (SELECT id_cultura FROM cultura WHERE data_cultivare = '10-NOV-22'));
-- data si numele fermierului nu exista in baza de date

select * from teren;

--TEREN:

-- Inserari valide:

INSERT INTO soi VALUES(null, 'Tomata Cherry', 2, 'Roșii mici, rotunde și dulci.',(SELECT id_planta FROM planta WHERE denumire_planta = 'Rosie'));
INSERT INTO soi VALUES(null, 'Tomata Roma', 3, 'Roșii de formă alungită.',(SELECT id_planta FROM planta WHERE denumire_planta = 'Rosie'));
INSERT INTO soi VALUES(null, 'Grâu Durum', 4, 'Grâu dur, utilizat pentru făină.',(SELECT id_planta FROM planta WHERE denumire_planta = 'Grau'));
INSERT INTO soi VALUES(null, 'Struguri Muscat', 5, 'Struguri cu aromă distinctă de muscat.',(SELECT id_planta FROM planta WHERE denumire_planta = 'Strugure'));
INSERT INTO soi VALUES(50, 'Struguri Concord',5, 'Struguri negri, dulci și suculenți.',(SELECT id_planta FROM planta WHERE denumire_planta = 'Strugure'));

-- Inserari nevalide:

INSERT INTO soi VALUES(50, 'Struguri Zinfandel',5, 'Struguri roșii.',(SELECT id_planta FROM planta WHERE denumire_planta = 'Strugure'));
-- nu se poate folosi aceeasi valoare cheii primare
INSERT INTO soi VALUES(50, 'Capsuna Albion',3, 'Căpșuni mari, albe, dulci și aromate.',(SELECT id_planta FROM planta WHERE denumire_planta = 'Strugure'));
-- nu exista capsuna in baza de date

select * from soi;

--SEMINTE:

-- Inserari valide:

INSERT INTO seminte VALUES (null, 'cal. 1', 10, 'Depozit Fundulea', (SELECT id_soi FROM soi WHERE denumire_soi = 'Grâu Durum'));
INSERT INTO seminte VALUES (null, 'cal. 1', 40, 'Depozit Strunga', (SELECT id_soi FROM soi WHERE denumire_soi = 'Struguri Muscat'));
INSERT INTO seminte VALUES (null, 'cal. 2', 22, 'Depozit Roznov', (SELECT id_soi FROM soi WHERE denumire_soi = 'Struguri Muscat'));
INSERT INTO seminte VALUES (null, 'cal. 1', 34, 'Depozit Strunga', (SELECT id_soi FROM soi WHERE denumire_soi = 'Struguri Concord'));
INSERT INTO seminte VALUES (null, 'cal. 2', 10, 'Agrosem', (SELECT id_soi FROM soi WHERE denumire_soi = 'Tomata Cherry'));

select * from seminte;
