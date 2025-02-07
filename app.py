from flask import Flask, render_template, request, redirect, url_for
import pymysql

app = Flask(__name__)

baza_de_date = pymysql.connect(
    host="localhost",
    user="root",
    password="1234", 
    database="smart_bike"
)
curs = baza_de_date.cursor()

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/afisare', methods=['GET'])
def afisare():
    tabel = request.args.get('tabel')  
    if tabel is None:
        return redirect(url_for('index'))

    
    query = f"DESCRIBE {tabel}"  
    curs.execute(query)
    coloane = [row[0] for row in curs.fetchall()]


    sort_col = request.args.get('sort_col', None)
    sort_order = request.args.get('sort_order', 'asc')

    
    if sort_col:
        query = f"SELECT * FROM {tabel} ORDER BY {sort_col} {sort_order}"
    else:
        query = f"SELECT * FROM {tabel}"
    
    curs.execute(query)
    rezultate = curs.fetchall()

    return render_template('afisare.html', tabel=tabel, coloane=coloane, rezultate=rezultate)
@app.route('/editare', methods=['GET', 'POST'])
def editare():
    tabel = request.args.get('tabel')
    id_inregistrare = request.args.get('id')

   
    query = f"DESCRIBE {tabel}"
    curs.execute(query)
    coloane = [row[0] for row in curs.fetchall()]

    if request.method == 'POST':
        
        set_clause = ", ".join([f"{coloana} = %s" for coloana in coloane[1:]])  # excludem coloana id di luam ce vrem sa editam 
        values = [request.form[col] for col in coloane[1:]]
        values.append(id_inregistrare)

        query = f"UPDATE {tabel} SET {set_clause} WHERE {coloane[0]} = %s"
        curs.execute(query, values)
        baza_de_date.commit()

        return redirect(url_for('afisare', tabel=tabel))

    
    query = f"SELECT * FROM {tabel} WHERE {coloane[0]} = %s"
    curs.execute(query, (id_inregistrare,))
    inregistrare = curs.fetchone()

    return render_template('editare.html', tabel=tabel, coloane=coloane, inregistrare=inregistrare)

@app.route('/sterge', methods=['GET'])
def sterge():
    tabel = request.args.get('tabel')
    id_inregistrare = request.args.get('id')

    if not tabel or not id_inregistrare:
        return "Tabelul sau ID-ul nu este specificat."  

    try:
       
        query = f"DESCRIBE {tabel}"
        curs.execute(query)
        coloane = [row[0] for row in curs.fetchall()]
        
        
        query = f"DELETE FROM {tabel} WHERE {coloane[0]} = %s"
        curs.execute(query, (id_inregistrare,))
        baza_de_date.commit()

        return redirect(url_for('afisare', tabel=tabel))
    except Exception as e:
        
        return f"Eroare la ștergerea înregistrării: {str(e)}", 500




# date din clienti inchiriere biciclete si afiseaza doar daca bicicleta este de tip MTB 
# si durata de inchiriere este mai mare de 60 de minute
@app.route('/afisare_inchirieri', methods=['GET'])
def afisare_inchirieri():

    query = """
    SELECT
        c.nume AS Nume_Client,
        c.prenume AS Prenume_Client,
        b.brand AS Brand_Bicicleta,
        i.durata_inchiriere_minute AS Durata_Inchiriere,
        i.pret_total AS Pret_Inchiriere
    FROM
        Clienti c
    JOIN
        Inchirieri i ON c.id_clienti = i.id_client
    JOIN
        Biciclete b ON i.id_bicicleta = b.id_bicicleta
    WHERE
        b.tip = 'MTB'
        AND i.durata_inchiriere_minute > 60
        and  i.data_inchiriere < '2025-01-01'
    ORDER BY
        i.pret_total DESC;

    """
    curs.execute(query)
    rezultate = curs.fetchall()

    return render_template('afisare_inchirieri.html', rezultate=rezultate)


@app.route('/afisare_having', methods=['GET'])
def afisare_having():
    # Interogare SQL pentru a selecta clienții cu incasari mai mari de 10
    query = """
    SELECT 
    c.nume, 
    c.prenume, 
    SUM(i.pret_total) AS total_incasari
FROM 
    Clienti c
JOIN 
    Inchirieri i ON c.id_clienti = i.id_client
GROUP BY 
    c.nume, c.prenume
HAVING 
    SUM(i.pret_total) > 10
ORDER BY 
    total_incasari DESC
LIMIT 5;

    """
    curs.execute(query)
    rezultate = curs.fetchall()

    return render_template('afisare_having.html', rezultate=rezultate)


@app.route('/afisare_statii', methods=['GET'])
def afisare_statii():
    # Obține toate stațiile
    query = "SELECT id_statie, locatie, cod_postal, telefon, email FROM Statii"
    curs.execute(query)
    statii = curs.fetchall()

    return render_template('afisare_statii.html', statii=statii)


@app.route('/sterge_statie', methods=['GET', 'POST'])
def sterge_statie():
    if request.method == 'POST':
        # obtine id statiei pe care vrem sa o stergem 
        id_statie = request.form.get('id_statie')
        
        # executa stergerea statiei (angajații asociați vor fi stersi automat prin ON DELETE CASCADE)
        query_delete = "DELETE FROM Statii WHERE id_statie = %s"
        curs.execute(query_delete, (id_statie,))
        baza_de_date.commit()


    query_statii = "SELECT * FROM Statii"
    curs.execute(query_statii)
    statii_ramase = curs.fetchall()


    query_angajati = "SELECT * FROM Angajati"
    curs.execute(query_angajati)
    angajati_ramasi = curs.fetchall()

    return render_template(
        'sterge_statie.html', 
        statii_ramase=statii_ramase, 
        angajati_ramasi=angajati_ramasi
    )

@app.route('/vizualizare_inchirieri', methods=['GET'])
def vizualizare_inchirieri():
    query = "SELECT * FROM V_ListaInchirieri"
    curs.execute(query)
    rezultate = curs.fetchall()
    return render_template('vizualizare_inchirieri.html', rezultate=rezultate)
    
@app.route('/vizualizare_statistici', methods=['GET'])
def vizualizare_statistici():
    query = "SELECT * FROM V_StatisticiBiciclete"
    curs.execute(query)
    rezultate = curs.fetchall()
    return render_template('vizualizare_statistici.html', rezultate=rezultate)


if __name__ == '__main__':
    app.run(debug=True)

