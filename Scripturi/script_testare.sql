--exemple de vizualizare a datelor cu JOIN-uri

--vizualizare legatura intre tabelele FERMIER, TEREN, CULTURA, PLANTA(campuri de baza)

SELECT 
    f.nume_fermier, 
    t.tip_teren, 
    c.tip_cultura, 
    p.denumire_planta
FROM 
    fermier f, 
    teren t, 
    cultura c, 
    planta p
WHERE 
    f.id_fermier = t.fermier_id_fermier
    AND t.cultura_id_cultura = c.id_cultura
    AND c.planta_id_planta = p.id_planta;

--vizualizare legatura intre tabelele FERMIER, TEREN, CULTURA, PLANTA(vizualizare extinsa)

SELECT 
    f.id_fermier,
    f.nume_fermier,
    f.prenume_fermier,
    t.id_teren,
    t.suprafata_teren,
    t.tip_teren,
    c.id_cultura,
    c.tip_cultura,
    c.perioada_cultivare,
    c.data_cultivare,
    p.id_planta,
    p.denumire_planta
FROM 
    fermier f, 
    teren t, 
    cultura c, 
    planta p
WHERE 
    f.id_fermier = t.fermier_id_fermier
    AND t.cultura_id_cultura = c.id_cultura
    AND c.planta_id_planta = p.id_planta;

--vizualizare legatura intre tabelele SOI, SEMINTE, PLANTA(vizualizare extinsa)

SELECT 
    s.id_soi,
    s.denumire_soi,
    s.nr_luni_crestere,
    s.descriere,
    p.id_planta,
    p.denumire_planta,
    sm.id_seminte,
    sm.calitate,
    sm.pret_kg_vanzare,
    sm.producator
FROM 
    soi s, planta p, seminte sm
WHERE 
    p.id_planta = s.planta_id_planta
    AND sm.soi_id_soi = s.id_soi;

-- inserarile + inserari nevalide(validarea datelor) sunt testate in fisierul cu date de test

-- exemple de update

--se mareste suprafata pentru terenurile viticole

UPDATE teren
    SET suprafata_teren = 25
    WHERE tip_teren = 'viticol';
    
-- pentru toate inregistrarile la care planta are denumirea morcov, se seteaza tipul de teren sera

UPDATE teren
SET tip_teren = 'sera'
WHERE cultura_id_cultura IN (SELECT id_cultura
                             FROM cultura
                             WHERE planta_id_planta IN (SELECT id_planta
                                                       FROM planta
                                                       WHERE denumire_planta = 'Morcov'));


-- se sterg inserarile in care terenurile sunt pomicole

DELETE FROM teren
    WHERE tip_teren = 'pomicol';

-- se sterg toate inserarile de seminte care au cal. 2

DELETE FROM seminte
    WHERE calitate = 'cal. 2';
    
--stergere invalida - sunt prea multe foreign-key-uri care depind de inserarea asta
DELETE FROM fermier
    WHERE id_fermier = 70;

    
    