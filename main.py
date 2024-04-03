from flask import Flask, render_template, request
import cx_Oracle

app = Flask(__name__)

# Configurare pentru conexiunea la baza de date Oracle
dsn_tns = cx_Oracle.makedsn('bd-dc.cs.tuiasi.ro', '1539', service_name='orcl')
conn = cx_Oracle.connect(user='bd053', password='bd053', dsn=dsn_tns)
cursor = conn.cursor()


@app.route('/')
def index():
    return render_template('home.html')


@app.route('/home.html')
def home():
    return render_template('home.html')


@app.route('/addFarmer.html', methods=['GET', 'POST'])
def add_farmer():
    if request.method == 'POST':
        new_conn = cx_Oracle.connect(user='bd053', password='bd053', dsn=dsn_tns)
        cursor = new_conn.cursor()
        try:
            # Deschidem tranzacția
            new_conn.begin()

            # Colectăm informațiile din formular
            nume_fermier = request.form['nume_fermier']
            prenume_fermier = request.form['prenume_fermier']
            cnp = request.form['cnp_fermier']
            adresa = request.form['adresa']

            # Verificăm dacă CNP-ul este unic
            cursor.execute("SELECT COUNT(*) FROM fermier WHERE cnp = :cnp", {"cnp": cnp})
            count = cursor.fetchone()[0]
            if count > 0:
                raise Exception("CNP-ul trebuie să fie unic. Acest CNP este deja în uz.")

            # Generăm ID-ul pentru noul fermier
            cursor.execute("SELECT fermier_seq.NEXTVAL FROM DUAL")
            id_fermier = cursor.fetchone()[0]

            # Adăugăm fermierul în tabelul 'fermier'
            cursor.execute("""
                INSERT INTO fermier (id_fermier, nume_fermier, prenume_fermier, cnp, adresa)
                VALUES (:id_fermier, :nume_fermier, :prenume_fermier, :cnp, :adresa)
            """, {"id_fermier": id_fermier, "nume_fermier": nume_fermier, "prenume_fermier": prenume_fermier, "cnp": cnp, "adresa": adresa})

            # Commităm tranzacția
            new_conn.commit()

            return render_template('addFarmer.html', result="Fermier adăugat cu succes")

        except cx_Oracle.DatabaseError as e:
            # Rollback în caz de eroare
            new_conn.rollback()
            return render_template('addFarmer.html', error=f"Eroare: {str(e)}")

        finally:
            # Închidem cursorul și conexiunea
            cursor.close()
            new_conn.close()

    return render_template('addFarmer.html')


@app.route('/addField.html', methods=['GET', 'POST'])
def addField():
    cursor.execute("SELECT nume_fermier FROM fermier")
    nume_fermier_options = [row[0] for row in cursor.fetchall()]
    cursor.execute("SELECT prenume_fermier FROM fermier")
    prenume_fermier_options = [row[0] for row in cursor.fetchall()]
    if request.method == 'POST':
        nume_fermier = request.form['nume_fermier']
        prenume_fermier = request.form['prenume_fermier']
        suprafata_teren = request.form['suprafata_teren']
        tip_teren = request.form['tip_teren']
        tip_cultura = request.form['tip_cultura']
        cursor.execute(
            "SELECT id_fermier FROM fermier WHERE nume_fermier = :nume_fermier AND prenume_fermier = :prenume_fermier",
            {"nume_fermier": nume_fermier, "prenume_fermier": prenume_fermier})
        fermier_id_fermier = cursor.fetchone()[0]

        cursor.execute("SELECT id_cultura FROM cultura WHERE tip_cultura = :tip_cultura",
                       {"tip_cultura": tip_cultura})
        cultura_id_cultura = cursor.fetchone()[0]

        cursor.execute("SELECT teren_seq.NEXTVAL FROM DUAL")
        id_teren = cursor.fetchone()[0]

        cursor.execute(
            "INSERT INTO teren (id_teren, suprafata_teren, tip_teren, fermier_id_fermier, cultura_id_cultura) VALUES (:id_teren, :suprafata_teren, :tip_teren, :fermier_id_fermier, :cultura_id_cultura)",
            {"id_teren": id_teren, "suprafata_teren": suprafata_teren, "tip_teren": tip_teren, "fermier_id_fermier": fermier_id_fermier, "cultura_id_cultura": cultura_id_cultura})

        conn.commit()

    return render_template('addField.html', nume_fermier_options=nume_fermier_options, prenume_fermier_options=prenume_fermier_options)


@app.route('/addCrop.html', methods=['GET', 'POST'])
def addCrop():
    cursor.execute("SELECT denumire_planta FROM planta")
    denumire_planta_options = [row[0] for row in cursor.fetchall()]
    if request.method == 'POST':
        tip_cultura = request.form['tip_cultura']
        perioada_cultivare = request.form['perioada_cultivare']
        data_cultivare = request.form['data_cultivare']
        denumire_planta = request.form['denumire_planta']

        cursor.execute(
            "SELECT id_planta FROM planta WHERE denumire_planta = :denumire_planta",
            {"denumire_planta": denumire_planta})
        planta_id_planta = cursor.fetchone()[0]

        cursor.execute("SELECT cultura_seq.NEXTVAL FROM DUAL")
        id_cultura = cursor.fetchone()[0]

        cursor.execute(
            "INSERT INTO cultura (id_cultura, tip_cultura, perioada_cultivare, data_cultivare, planta_id_planta) VALUES (:id_cultura, :tip_cultura, :perioada_cultivare, :data_cultivare, :planta_id_planta)",
            {"id_cultura": id_cultura, "tip_cultura": tip_cultura, "perioada_cultivare": perioada_cultivare,
             "data_cultivare": data_cultivare, "planta_id_planta": planta_id_planta})

        conn.commit()

    return render_template('addCrop.html', denumire_planta_options=denumire_planta_options)


@app.route('/addPlant.html', methods=['GET', 'POST'])
def addPlant():
    if request.method == 'POST':
        denumire_planta = request.form['denumire_planta']
        tip_planta= request.form['tip_planta']

        cursor.execute("SELECT planta_id_planta_seq.NEXTVAL FROM DUAL")
        id_planta = cursor.fetchone()[0]

        cursor.execute(
            "INSERT INTO planta (id_planta, denumire_planta, tip_planta) VALUES (:id_planta, :denumire_planta, :tip_planta)",
            {"id_planta": id_planta, "denumire_planta": denumire_planta, "tip_planta": tip_planta}
        )

        conn.commit()

        return render_template('addPlant.html', rezultate="Record updated successfully")

    return render_template('addPlant.html')


@app.route('/addVariety.html', methods=['GET', 'POST'])
def addVariety():
    cursor.execute("SELECT denumire_planta FROM planta")
    denumire_planta_options = [row[0] for row in cursor.fetchall()]

    if request.method == 'POST':
        denumire_soi = request.form['denumire_soi']
        descriere = request.form['descriere']
        nr_luni_crestere = request.form['nr_luni_crestere']
        denumire_planta = request.form['denumire_planta']

        cursor.execute(
            "SELECT id_planta FROM planta WHERE denumire_planta = :denumire_planta",
            {"denumire_planta": denumire_planta})
        planta_id_planta = cursor.fetchone()[0]

        cursor.execute("SELECT soi_id_soi_seq.NEXTVAL FROM DUAL")
        id_soi = cursor.fetchone()[0]

        cursor.execute(
            "INSERT INTO soi (id_soi, denumire_soi, descriere, nr_luni_crestere, planta_id_planta) VALUES (:id_soi, :denumire_soi, :descriere, :nr_luni_crestere, :planta_id_planta)",
            {"id_soi": id_soi, "denumire_soi": denumire_soi, "descriere": descriere,
             "nr_luni_crestere": nr_luni_crestere, "planta_id_planta":planta_id_planta})

        conn.commit()

    return render_template('addVariety.html', denumire_planta_options=denumire_planta_options)


@app.route('/addSeed.html', methods=['GET', 'POST'])
def addSeed():
    cursor.execute("SELECT denumire_soi FROM soi")
    denumire_soi_options = [row[0] for row in cursor.fetchall()]

    if request.method == 'POST':
        calitate = request.form['calitate']
        pret_kg_vanzare = request.form['pret_kg_vanzare']
        producator = request.form['producator']
        denumire_soi = request.form['denumire_soi']

        cursor.execute(
            "SELECT id_soi FROM soi WHERE denumire_soi = :denumire_soi",
            {"denumire_soi": denumire_soi})
        soi_id_soi = cursor.fetchone()[0]

        cursor.execute("SELECT seminte_id_seminte_seq.NEXTVAL FROM DUAL")
        id_seminte = cursor.fetchone()[0]

        cursor.execute(
            "INSERT INTO seminte (id_seminte, calitate, pret_kg_vanzare, producator, soi_id_soi) VALUES (:id_seminte, :calitate, :pret_kg_vanzare, :producator, :soi_id_soi)",
            {"id_seminte": id_seminte, "calitate": calitate, "pret_kg_vanzare": pret_kg_vanzare,
             "producator": producator, "soi_id_soi": soi_id_soi})

        conn.commit()

    return render_template('addSeed.html', denumire_soi_options=denumire_soi_options)


@app.route('/viewData.html', methods=['GET'])
def viewData():
    cursor.execute("""
        SELECT 
            f.nume_fermier,
            f.prenume_fermier,
            t.tip_teren,
            t.suprafata_teren,
            c.tip_cultura,
            p.denumire_planta,
            c.perioada_cultivare,
            c.data_cultivare
            
        FROM 
            fermier f, 
            teren t, 
            cultura c, 
            planta p
        WHERE 
            f.id_fermier = t.fermier_id_fermier
            AND t.cultura_id_cultura = c.id_cultura
            AND c.planta_id_planta = p.id_planta
        ORDER BY f.nume_fermier, f.prenume_fermier
    """)

    results1 = cursor.fetchall()
    cursor.execute("""
            SELECT 
    p.denumire_planta,
    s.denumire_soi,   
    s.descriere,
    p.tip_planta,
    s.nr_luni_crestere,
    sm.producator,
    sm.calitate,
    sm.pret_kg_vanzare
FROM 
    soi s, planta p, seminte sm
WHERE 
    p.id_planta = s.planta_id_planta
    AND sm.soi_id_soi = s.id_soi
    ORDER BY p.denumire_planta, s.denumire_soi
        """)

    results2 = cursor.fetchall()

    return render_template('viewData.html', results1=results1, results2=results2)


@app.route('/deleteTables.html', methods=['GET', 'POST'])
def deleteTables():
    if request.method == 'POST':
        nume_fermier = request.form['nume_fermier']
        prenume_fermier = request.form['prenume_fermier']

        cursor.execute(
            "SELECT id_fermier FROM fermier WHERE nume_fermier = :nume_fermier AND prenume_fermier = :prenume_fermier",
            {"nume_fermier": nume_fermier, "prenume_fermier": prenume_fermier})
        row = cursor.fetchone()

        if row:
            farmer_id = row[0]

            try:
                conn.begin()

                cursor.execute("DELETE FROM teren WHERE fermier_id_fermier = :farmer_id", {"farmer_id": farmer_id})
                cursor.execute("DELETE FROM cultura WHERE id_cultura IN (SELECT cultura_id_cultura FROM teren WHERE fermier_id_fermier = :farmer_id)", {"farmer_id": farmer_id})

                cursor.execute("DELETE FROM fermier WHERE id_fermier = :farmer_id", {"farmer_id": farmer_id})

                conn.commit()

                return render_template('deleteTables.html', result="Farmer and related records deleted successfully")

            except cx_Oracle.DatabaseError as e:
                print(f"Error during deletion: {str(e)}")
                conn.rollback()
                return render_template('deleteTables.html', error=f"Error: {str(e)}")

            finally:
                cursor.close()
        else:
            print("Farmer not found")
            return render_template('deleteTables.html', error="Farmer not found")

    return render_template('deleteTables.html')





if __name__ == '__main__':
    app.run(debug=True)
