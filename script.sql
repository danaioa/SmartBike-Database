CREATE TABLE Clienti (
    id_clienti INT unique PRIMARY KEY,
    nume VARCHAR(50) NOT NULL,
    prenume VARCHAR(50),
    CNP VARCHAR(13) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    telefon VARCHAR(10),
    adresa VARCHAR(200),
    CONSTRAINT cnp13_clienti CHECK (LENGTH(CNP) = 13),
    CONSTRAINT cnp_valid_clienti CHECK (SUBSTR(CNP, 1, 1) IN ('1', '2', '5', '6')),
    CONSTRAINT telefon_valid_clienti CHECK (telefon LIKE '07%'),
    CONSTRAINT email_valid_clienti CHECK (email LIKE '%@%.%')
);

CREATE TABLE Furnizori (
    id_furnizor INT unique PRIMARY KEY,
    nume_furnizor VARCHAR(50) NOT NULL,
    locatie VARCHAR(250),
    telefon VARCHAR(20) CHECK (telefon LIKE '0%'),
    cod_postal VARCHAR(10) CHECK (LENGTH(cod_postal) BETWEEN 5 AND 10),
    email VARCHAR(100) UNIQUE CHECK (email LIKE '%@%.%')
);


CREATE TABLE Service (
    id_service INT unique  PRIMARY KEY,
    nume_service VARCHAR(50) NOT NULL,
    locatie VARCHAR(50),
    telefon VARCHAR(20) CHECK (telefon LIKE '0%'),
    email VARCHAR(100) CHECK (email LIKE '%@%.%'),
    cod_postal VARCHAR(10),
    capacitate_maxima INT CHECK (capacitate_maxima > 0)
);


CREATE TABLE Categorii_Biciclete (
    id_categorie INT unique PRIMARY KEY,
    nume_categorie VARCHAR(50) NOT NULL UNIQUE
);
 
 
 
 CREATE TABLE Statii (
    id_statie INT unique PRIMARY KEY,
    locatie VARCHAR(250) NOT NULL,
    cod_postal VARCHAR(10) CHECK (LENGTH(cod_postal) BETWEEN 5 AND 10),
    telefon VARCHAR(20) CHECK (telefon LIKE '0%'),
    email VARCHAR(100) CHECK (email LIKE '%@%.%')
);



CREATE TABLE Angajati (
    id_angajat INT UNIQUE PRIMARY KEY,
    nume VARCHAR(50) NOT NULL,
    prenume VARCHAR(50),
    telefon VARCHAR(20) CHECK (telefon LIKE '0%'),
    email VARCHAR(100) CHECK (email LIKE '%@%.%'),
    salariu INT CHECK (salariu > 0),
    rol VARCHAR(50),
    data_angajarii DATE CHECK (data_angajarii <= '2024-12-23'),
    id_statie INT,
    CONSTRAINT fk_statie FOREIGN KEY (id_statie) REFERENCES Statii(id_statie) 
);


CREATE TABLE Biciclete (
    id_bicicleta INT UNIQUE PRIMARY KEY,
    brand VARCHAR(50) NOT NULL,
    tip VARCHAR(50) CHECK (tip IN ('MTB', 'City', 'Road', 'Hybrid')),
    culoare VARCHAR(30),
    id_furnizor INT,
    id_statie INT,
    id_categorie INT,
    CONSTRAINT fk_furnizor FOREIGN KEY (id_furnizor) REFERENCES Furnizori(id_furnizor) ,
    CONSTRAINT fk_statie_biciclete FOREIGN KEY (id_statie) REFERENCES Statii(id_statie) ,  
    CONSTRAINT fk_categorie FOREIGN KEY (id_categorie) REFERENCES Categorii_Biciclete(id_categorie) 
);

 
 
CREATE TABLE Service_Biciclete (
    id_reparatie INT UNIQUE PRIMARY KEY,
    id_service INT,
    id_bicicleta INT,
    data_intrare_service DATE NOT NULL,
    data_iesire_service DATE,
    cost_reparatie INT CHECK (cost_reparatie >= 0),
    CONSTRAINT fk_service FOREIGN KEY (id_service) REFERENCES Service(id_service) ,
    CONSTRAINT fk_bicicleta_service FOREIGN KEY (id_bicicleta) REFERENCES Biciclete(id_bicicleta) 
);



CREATE TABLE Inchirieri (
    id_inchiriere INT unique PRIMARY KEY,
    id_client INT,
    id_bicicleta INT,
    data_inchiriere DATE NOT NULL CHECK (data_inchiriere <= '2024-12-23'),
    durata_inchiriere_minute INT CHECK (durata_inchiriere_minute > 0),
    pret_total INT CHECK (pret_total >= 0),
    CONSTRAINT fk_client FOREIGN KEY (id_client) REFERENCES Clienti(id_clienti) ON DELETE CASCADE,
    CONSTRAINT fk_bicicleta FOREIGN KEY (id_bicicleta) REFERENCES Biciclete(id_bicicleta) ON DELETE CASCADE
);



ALTER TABLE Angajati
DROP CONSTRAINT fk_statie;


ALTER TABLE Angajati
ADD CONSTRAINT fk_statie
FOREIGN KEY (id_statie) REFERENCES Statii(id_statie)
ON DELETE CASCADE;


ALTER TABLE Biciclete DROP CONSTRAINT fk_furnizor;
ALTER TABLE Biciclete DROP CONSTRAINT fk_statie_biciclete;
ALTER TABLE Biciclete DROP CONSTRAINT fk_categorie;

ALTER TABLE Biciclete
ADD CONSTRAINT fk_furnizor
FOREIGN KEY (id_furnizor) REFERENCES Furnizori(id_furnizor)
ON DELETE CASCADE;

ALTER TABLE Biciclete
ADD CONSTRAINT fk_statie_biciclete
FOREIGN KEY (id_statie) REFERENCES Statii(id_statie)
ON DELETE CASCADE;

ALTER TABLE Biciclete
ADD CONSTRAINT fk_categorie
FOREIGN KEY (id_categorie) REFERENCES Categorii_Biciclete(id_categorie)
ON DELETE CASCADE;




ALTER TABLE Service_Biciclete DROP CONSTRAINT fk_service;
ALTER TABLE Service_Biciclete DROP CONSTRAINT fk_bicicleta_service;

ALTER TABLE Service_Biciclete
ADD CONSTRAINT fk_service
FOREIGN KEY (id_service) REFERENCES Service(id_service)
ON DELETE CASCADE;

ALTER TABLE Service_Biciclete
ADD CONSTRAINT fk_bicicleta_service
FOREIGN KEY (id_bicicleta) REFERENCES Biciclete(id_bicicleta)
ON DELETE CASCADE;



ALTER TABLE Clienti
MODIFY id_clienti INT  NOT NULL;

ALTER TABLE Furnizori
MODIFY id_furnizor INT  NOT NULL;


ALTER TABLE Service
MODIFY id_service INT  NOT NULL;


ALTER TABLE Categorii_Biciclete
MODIFY id_categorie INT  NOT NULL;


ALTER TABLE Statii
MODIFY id_statie INT NOT NULL;

ALTER TABLE Angajati
MODIFY id_angajat INT  NOT NULL;


ALTER TABLE Biciclete
MODIFY id_bicicleta INT  NOT NULL;


ALTER TABLE Service_Biciclete
MODIFY id_reparatie INT  NOT NULL;


ALTER TABLE Inchirieri
MODIFY id_inchiriere INT NOT NULL;





INSERT INTO Clienti (id_clienti, nume, prenume, CNP, email, telefon, adresa) VALUES
(1, 'Popescu', 'Ion', '1970101123456', 'ion.popescu@gmail.com', null, 'Strada Unirii, Nr. 5, Bucuresti'),
(2, 'Ionescu', 'Maria', '2850523123456', 'maria.ionescu@yahoo.com', '0722333444', 'Strada Libertatii, Nr. 10, Cluj-Napoca'),
(3, 'Georgescu', 'Dan', '1900223123456', 'dan.georgescu@hotmail.com', '0733456789', 'Strada Sperantei, Nr. 3, Timisoara'),
(4, 'Marinescu', 'Andreea', '2870611123456', 'andreea.marinescu@gmail.com', '0711122233', 'Strada Vasile Lupu, Nr. 18, Iasi'),
(5, 'Dumitrescu', 'Alexandru', '1920309123456', 'alex.dumitrescu@yahoo.com', '0723456677', 'Strada Principala, Nr. 22, Brasov'),
(6, 'Pop', 'Florin', '1970405123456', 'florin.pop@yahoo.com', '0715544332', 'Strada Eroilor, Nr. 8, Oradea'),
(7, 'Vasilescu', 'Elena', '2850318123456', 'elena.vasilescu@gmail.com', '0726655443', 'Strada Mihai Eminescu, Nr. 14, Sibiu'),
(8, 'Radulescu', 'Mihai', '1911123123456', 'mihai.radulescu@gmail.com', '0737766554', 'Bulevardul Carol, Nr. 20, Craiova'),
(9, 'Rusu', 'Ana', '2930511123456', 'ana.rusu@yahoo.com', '0718877665', 'Strada Nicolae Balcescu, Nr. 33, Piatra-Neamt'),
(10, 'Stoica', 'Bogdan', '1980306123456', 'bogdan.stoica@gmail.com', '0729988776', 'Calea Dorobantilor, Nr. 15, Arad'),
(11, 'Ciobanu', 'Cristina', '2890712123456', 'cristina.ciobanu@hotmail.com', '0731099887', 'Strada Generalului, Nr. 9, Alba Iulia'),
(12, 'Tudor', 'Ioana', '2860923123456', 'ioana.tudor@gmail.com', '0712100998', 'Strada Oituz, Nr. 18, Suceava'),
(13, 'Grigorescu', 'Razvan', '1951015123456', 'razvan.grigorescu@yahoo.com', '0723211109', 'Bulevardul Traian, Nr. 45, Buzau'),
(14, 'Preda', 'Monica', '2870624123456', 'monica.preda@gmail.com', '0734322210', 'Strada Alexandru Ioan Cuza, Nr. 30, Bistrita'),
(15, 'Ilie', 'Roxana', '2930817123456', 'roxana.ilie@yahoo.com', '0715433321', 'Strada Mihail Kogalniceanu, Nr. 12, Galati'),
(16, 'Dobre', 'Marius', '1900418123456', 'marius.dobre@gmail.com', '0726544432', 'Strada Ion Creanga, Nr. 7, Bacau'),
(17, 'Enache', 'Sorina', '2881113123456', 'sorina.enache@hotmail.com', '0737655543', 'Calea Victoriei, Nr. 50, Pitesti'),
(18, 'Filip', 'Adrian', '1920209123456', 'adrian.filip@yahoo.com', '0718766654', 'Strada Aurel Vlaicu, Nr. 22, Targoviste'),
(19, 'Constantin', 'Oana', '2850712123456', 'oana.constantin@gmail.com', '0729877765', 'Strada Gheorghe Doja, Nr. 33, Focsani'),
(20, 'Moldovan', 'Ciprian', '1970908123456', 'ciprian.moldovan@yahoo.com', '0730988876', 'Strada Stefan cel Mare, Nr. 15, Satu Mare');



INSERT INTO Furnizori (id_furnizor, nume_furnizor, locatie, telefon, cod_postal, email) VALUES
(1, 'BikeHub București', 'București, Strada Aviatorilor nr. 12', '0722123456', '010101', 'contact@bikehub.ro'),
(2, 'VeloMarket Cluj', 'Cluj-Napoca, Strada Memorandumului nr. 5', '0733344556', '400567', 'info@velomarket.ro'),
(3, 'Mountain Sports Brașov', 'Brașov, Strada Republicii nr. 18', '0754433221', '500123', 'sales@mountainsports.ro'),
(4, 'EcoBikes Timișoara', 'Timișoara, Strada Aradului nr. 7', '0765544332', '300456', 'ecobikes@timisoara.ro'),
(5, 'Urban Cyclists Sibiu', 'Sibiu, Strada Nicolae Bălcescu nr. 11', '0741234567', '550101', 'contact@urbancyclists.ro'),
(6, 'BikeGear Craiova', 'Craiova, Strada Unirii nr. 9', '0776655443', '200789', 'gear@bikecraio.ro'),
(7, 'ProVelo Iași', 'Iași, Strada Palatului nr. 15', '0788877765', '700345', 'prov@bikesiasi.ro'),
(8, 'BlackSea Bikes Constanța', 'Constanța, Strada Mamaia nr. 20', '0722998877', '900112', 'info@blackseabikes.ro'),
(9, 'VeloPoint Oradea', 'Oradea, Strada Republicii nr. 22', '0744556677', '410654', 'contact@velopoint.ro'),
(10, 'Adventure Wheels Târgu Mureș', 'Târgu Mureș, Strada Bolyai nr. 8', '0732123456', '540321', 'sales@adventurewheels.ro'),
(11, 'BikeStore Galați', 'Galați, Strada Domnească nr. 14', '0700112233', '800654', 'store@bikegalati.ro'),
(12, 'Cycling Experts Suceava', 'Suceava, Strada Ștefan cel Mare nr. 19', '0711223344', '720432', 'experts@cyclingsuceava.ro'),
(13, 'VeloGarage Arad', 'Arad, Strada Mihai Eminescu nr. 16', '0761234567', '310123', 'garage@veload.ro'),
(14, 'Biciclete Deva', 'Deva, Strada Traian nr. 21', '0754432211', '330567', 'info@bicicletedeva.ro'),
(15, 'GreenBike Bacău', 'Bacău, Strada Mioriței nr. 10', '0733344455', '600789', 'green@bikebacau.ro'),
(16, 'Urban Cyclers Pitești', 'Pitești, Strada Teilor nr. 13', '0745566778', '110987', 'cyclers@urbanpitesti.ro'),
(17, 'Bike World Alba Iulia', 'Alba Iulia, Strada Cetății nr. 25', '0788887766', '510111', 'world@bikealba.ro'),
(18, 'Rider Shop Satu Mare', 'Satu Mare, Strada Mihai Viteazul nr. 30', '0700445566', '440321', 'shop@ridersm.ro'),
(19, 'Speedy Wheels Timișoara', 'Timișoara, Strada Gheorghe Lazăr nr. 6', '0722334455', '300654', 'speedy@wheels.ro'),
(20, 'ProBike Zalău', 'Zalău, Strada Corneliu Coposu nr. 12', '0744455667', '450234', 'probike@zalau.ro');


INSERT INTO Service (id_service, nume_service, locatie, telefon, email, cod_postal, capacitate_maxima) VALUES
(1, 'VeloRent București', 'București', '0721123456', 'contact@velorent.ro', '010203', 120),
(2, 'BikeFix Brașov', 'Brașov', '0742233445', 'contact@bikefix.ro', '500123', 80),
(3, 'EcoVelo Cluj', 'Cluj-Napoca', '0753344556', 'info@ecovelo.ro', '400456', 100),
(4, 'MountainBike Center Timișoara', 'Timișoara', '0764455667', 'contact@mtbcenter.ro', '300678', 90),
(5, 'Urban Bikes Sibiu', 'Sibiu', '0775566778', 'urban@bikesibiu.ro', '550112', 70),
(6, 'Cycling Center Constanța', 'Constanța', '0786677889', 'info@cyclingconstanta.ro', '900321', 110),
(7, 'Bike Service Iași', 'Iași', '0701122334', 'service@bikeiasi.ro', '700987', 75),
(8, 'Green Wheels Oradea', 'Oradea', '0722233445', 'green@wheelsoradea.ro', '410123', 85),
(9, 'VeloHub Galați', 'Galați', '0733344556', 'hub@velogalați.ro', '800654', 95),
(10, 'FastBike Suceava', 'Suceava', '0744455667', 'fast@bikesuceava.ro', '720432', 60),
(11, 'ProCycling Craiova', 'Craiova', '0755566778', 'contact@procycling.ro', '200789', 100),
(12, 'Adventure Bikes Târgu Mureș', 'Târgu Mureș', '0766677889', 'adventure@bikestgm.ro', '540654', 70),
(13, 'CityBikes Ploiești', 'Ploiești', '0777788990', 'info@citybikesploiesti.ro', '100876', 50),
(14, 'FixMyBike Bacău', 'Bacău', '0788899001', 'fix@bikebacau.ro', '600321', 65),
(15, 'RideOn Arad', 'Arad', '0700011223', 'rideon@arad.ro', '310567', 80),
(16, 'Cyclist Garage Alba Iulia', 'Alba Iulia', '0723344556', 'garage@cyclist.ro', '510876', 55),
(17, 'TrailMasters Zalău', 'Zalău', '0734455667', 'trail@mastersz.ro', '450234', 90),
(18, 'BikePro Satu Mare', 'Satu Mare', '0745566778', 'pro@bikesatumare.ro', '440654', 85),
(19, 'Urban Cycling Deva', 'Deva', '0756677889', 'urban@cyclingdeva.ro', '330876', 95),
(20, 'SpeedyBikes Pitești', 'Pitești', '0767788990', 'speedy@bikespitesti.ro', '110345', 100);


INSERT INTO Categorii_Biciclete (id_categorie, nume_categorie) VALUES
(1, 'Mountain Bike'),
(2, 'City Bike'),
(3, 'Road Bike'),
(4, 'Hybrid Bike'),
(5, 'Bicicletă Electrică'),
(6, 'Bicicletă pliabilă'),
(7, 'Bicicletă pentru copii'),
(8, 'Fat Bike'),
(9, 'Cruiser Bike'),
(10, 'Tandem Bike'),
(11, 'Bicicletă de curse'),
(12, 'Bicicletă de trekking'),
(13, 'Bicicletă cargo'),
(14, 'Bicicletă BMX'),
(15, 'Bicicletă gravel'),
(16, 'Bicicletă vintage'),
(17, 'Bicicletă downhill'),
(18, 'Bicicletă touring'),
(19, 'Bicicletă fixie'),
(20, 'Bicicletă de triatlon');


INSERT INTO Statii (id_statie, locatie, cod_postal, telefon, email) VALUES
(1, 'București, Strada Universității nr. 5', '010101', '0721234567', 'universitate@statiibike.ro'),
(2, 'București, Bulevardul Unirii nr. 20', '010203', '0722345678', 'unirii@statiibike.ro'),
(3, 'București, Strada Dorobanți nr. 12', '010305', '0723456789', 'dorobanti@statiibike.ro'),
(4, 'Brașov, Strada Mureșenilor nr. 12', '500123', '0742233445', 'muresenilor@statiibike.ro'),
(5, 'Brașov, Piața Sfatului nr. 8', '500456', '0743344556', 'sfatului@statiibike.ro'),
(6, 'Brașov, Strada Lungă nr. 22', '500678', '0744455667', 'lunga@statiibike.ro'),
(7, 'Cluj-Napoca, Piața Avram Iancu nr. 10', '400456', '0753344556', 'avramiancu@statiibike.ro'),
(8, 'Cluj-Napoca, Strada Memorandumului nr. 7', '400567', '0754455667', 'memorandumului@statiibike.ro'),
(9, 'Cluj-Napoca, Strada Horea nr. 18', '400678', '0755566778', 'horea@statiibike.ro'),
(10, 'Timișoara, Strada Mareșal Prezan nr. 18', '300678', '0764455667', 'prezan@statiibike.ro'),
(11, 'Timișoara, Piața Victoriei nr. 5', '300123', '0765566778', 'victoriei@statiibike.ro'),
(12, 'Timișoara, Strada Gheorghe Lazăr nr. 14', '300456', '0766677889', 'lazar@statiibike.ro'),
(13, 'Constanța, Bulevardul Mamaia nr. 5', '900321', '0786677889', 'mamaia@statiibike.ro'),
(14, 'Constanța, Piața Ovidiu nr. 9', '900654', '0787788990', 'ovidiu@statiibike.ro'),
(15, 'Constanța, Strada Mircea cel Bătrân nr. 15', '900789', '0788899001', 'mircea@statiibike.ro'),
(16, 'Iași, Strada Lăpușneanu nr. 14', '700987', '0701122334', 'lapusneanu@statiibike.ro'),
(17, 'Iași, Piața Unirii nr. 20', '700123', '0702233445', 'uniriiiasi@statiibike.ro'),
(18, 'Iași, Strada Cuza Vodă nr. 11', '700654', '0703344556', 'cuzavoda@statiibike.ro'),
(19, 'Sibiu, Strada Nicolae Bălcescu nr. 25', '550112', '0775566778', 'balcescu@statiibike.ro'),
(20, 'Sibiu, Piața Mare nr. 9', '550456', '0776677889', 'piatamare@statiibike.ro');


INSERT INTO Angajati (id_angajat, nume, prenume, telefon, email, salariu, rol, data_angajarii, id_statie) VALUES
(1, 'Popescu', 'Andrei', '0721234567', 'andrei.popescu@statiibike.ro', 4000, 'Manager', '2022-05-10', 1),
(2, 'Ionescu', 'Maria', '0742233445', 'maria.ionescu@statiibike.ro', 3500, 'Tehnician', '2023-03-15', 1),
(3, 'Dumitru', 'Ioan', '0753344556', 'ioan.dumitru@statiibike.ro', 3200, 'Casier', '2023-06-20', 2),
(4, 'Stoica', 'Ana', '0764455667', 'ana.stoica@statiibike.ro', 3700, 'Manager', '2022-08-05', 3),
(5, 'Georgescu', 'Victor', '0775566778', 'victor.georgescu@statiibike.ro', 3100, 'Tehnician', '2023-02-10', 3),
(6, 'Marinescu', 'Roxana', '0786677889', 'roxana.marinescu@statiibike.ro', 3300, 'Casier', '2024-01-12', 4),
(7, 'Vasilescu', 'Cristina', '0701122334', 'cristina.vasilescu@statiibike.ro', 4000, 'Manager', '2021-11-18', 5),
(8, 'Lupu', 'George', '0722233445', 'george.lupu@statiibike.ro', 3400, 'Tehnician', '2022-07-22', 5),
(9, 'Preda', 'Elena', '0733344556', 'elena.preda@statiibike.ro', 3000, 'Casier', '2023-11-01', 6),
(10, 'Tudor', 'Florin', '0744455667', 'florin.tudor@statiibike.ro', 3600, 'Tehnician', '2023-08-25', 7),
(11, 'Dobre', 'Raluca', '0755566778', 'raluca.dobre@statiibike.ro', 3800, 'Manager', '2022-10-13', 8),
(12, 'Pavel', 'Daniel', '0766677889', 'daniel.pavel@statiibike.ro', 3200, 'Casier', '2024-04-05', 8),
(13, 'Constantinescu', 'Adrian', '0777788990', 'adrian.constantinescu@statiibike.ro', 3100, 'Tehnician', '2023-09-19', 9),
(14, 'Mihai', 'Simona', '0788899001', 'simona.mihai@statiibike.ro', 4000, 'Manager', '2021-12-22', 10),
(15, 'Barbu', 'Alexandra', '0700011223', 'alexandra.barbu@statiibike.ro', 3500, 'Tehnician', '2022-06-18', 10),
(16, 'Enache', 'Paul', '0723344556', 'paul.enache@statiibike.ro', 3200, 'Casier', '2024-03-10', 11),
(17, 'Grigorescu', 'Diana', '0734455667', 'diana.grigorescu@statiibike.ro', 3900, 'Manager', '2021-09-30', 12),
(18, 'Bălan', 'Marius', '0745566778', 'marius.balan@statiibike.ro', 3600, 'Tehnician', '2022-04-25', 12),
(19, 'Vlad', 'Laura', '0756677889', 'laura.vlad@statiibike.ro', 3100, 'Casier', '2023-12-05', 13),
(20, 'Neagu', 'Cătălin', '0767788990', 'catalin.neagu@statiibike.ro', 3500, 'Tehnician', '2022-01-15', 14);




INSERT INTO Biciclete (id_bicicleta, brand, tip, culoare, id_furnizor, id_statie, id_categorie) VALUES
(1, 'Giant', 'MTB', 'Negru', 1, 1, 1),
(2, 'Trek', 'MTB', 'Roșu', 2, 1, 2),
(3, 'Specialized', 'Road', 'Albastru', 3, 2, 3),
(4, 'Cannondale', 'Hybrid', 'Verde', 4, 2, 4),
(5, 'Bianchi', 'Road', 'Alb', 1, 3, 3),
(6, 'Merida', 'MTB', 'Portocaliu', 2, 3, 1),
(7, 'Scott', 'Hybrid', 'Gri', 3, 4, 4),
(8, 'Cube', 'City', 'Galben', 4, 4, 2),
(9, 'Kona', 'MTB', 'Maro', 1, 5, 1),
(10, 'Norco', 'City', 'Roșu', 2, 5, 2),
(11, 'Focus', 'Road', 'Negru', 3, 6, 3),
(12, 'Santa Cruz', 'MTB', 'Verde', 4, 6, 1),
(13, 'Felt', 'Hybrid', 'Albastru', 1, 7, 4),
(14, 'Radon', 'City', 'Albastru', 2, 7, 2),
(15, 'Orbea', 'MTB', 'Portocaliu', 3, 8, 1),
(16, 'Vitus', 'Road', 'Argintiu', 4, 8, 3),
(17, 'Stevens', 'Hybrid', 'Negru', 1, 9, 4),
(18, 'Diamondback', 'City', 'Verde', 2, 9, 2),
(19, 'KHS', 'Road', 'Roșu', 3, 10, 3),
(20, 'Merida', 'MTB', 'Albastru', 4, 10, 1);




INSERT INTO Service_Biciclete (id_reparatie, id_service, id_bicicleta, data_intrare_service, data_iesire_service, cost_reparatie) VALUES
(1, 1, 1, '2024-01-05', '2024-01-10', 150),
(2, 2, 3, '2024-01-06', '2024-01-11', 200),
(3, 3, 5, '2024-01-07', '2024-01-12', 100),
(4, 4, 7, '2024-01-08', '2024-01-13', 250),
(5, 1, 9, '2024-01-09', '2024-01-14', 300),
(6, 2, 11, '2024-01-10', '2024-01-15', 180),
(7, 3, 13, '2024-01-11', '2024-01-16', 220),
(8, 4, 15, '2024-01-12', '2024-01-17', 170),
(9, 1, 17, '2024-01-13', '2024-01-18', 210),
(10, 2, 19, '2024-01-14', '2024-01-19', 160);


INSERT INTO Inchirieri (id_inchiriere, id_client, id_bicicleta, data_inchiriere, durata_inchiriere_minute, pret_total) VALUES
(1, 1, 3, '2024-12-05', 1440, 30),
(2, 2, 5, '2024-12-06', 2880, 50),
(3, 3, 7, '2024-12-07', 4320, 70),
(4, 4, 9, '2024-12-08', 5760, 90),
(5, 5, 11, '2024-12-09', 7200, 110),
(6, 6, 13, '2024-12-10', 1440, 30),
(7, 7, 15, '2024-12-11', 2880, 50),
(8, 8, 17, '2024-12-12', 4320, 70),
(9, 9, 19, '2024-12-13', 5760, 90),
(10, 10, 1, '2024-12-14', 7200, 110);



-- a

SELECT *
FROM clienti
ORDER BY nume DESC;




-- c) Se solicita sa se afiseze informatiile despre inchirierile de biciclete de tipul 
-- 'MTB', in care durata inchirierii este mai mare de 60 de minute si data inchirierii este 
-- anterioara datei '2025-01-01'. 
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






--  d) Realizati o interogare SQL care sa returneze primii 5 clienti care au 
--  incasari totale mai mari de 10, ordonati descrescator dupa valoarea totala a 
--  incasarilor. Afisati numele clientului, prenumele clientului si valoarea totala a 
--  incasarilor.

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






-- f)

 --   Se doreste afisarea tuturor clientilor impreuna cu 
-- inchirierile lor efectuate. Rezultatul trebuie sa includa informatiile despre fiecare 
-- client, precum numele, prenumele si detalii despre fiecare inchiriere efectuata 
-- (bicicleta inchiriata, data inchirierii si durata inchirierii)

CREATE VIEW V_ListaInchirieri AS
SELECT 
    i.id_inchiriere,
    c.id_clienti,
    c.nume AS nume_client,
    c.prenume AS prenume_client,
    i.id_bicicleta,
    i.data_inchiriere,
    i.durata_inchiriere_minute,
    i.pret_total
FROM 
    Clienti c
JOIN 
    Inchirieri i ON c.id_clienti = i.id_client;
    
    
    
--  Sa se afiseze o statistica pentru fiacre tip de 
 --  Bicicleta in care apare brendul,constul total, numarul de inchirieri
    
    
    CREATE VIEW V_StatisticiBiciclete AS
SELECT 
    b.id_bicicleta,
    b.brand,
    b.tip,
    SUM(i.durata_inchiriere_minute) AS durata_totala_inchiriere,
    SUM(i.pret_total) AS venit_total
FROM 
    Biciclete b
LEFT JOIN 
    Inchirieri i ON b.id_bicicleta = i.id_bicicleta
GROUP BY 
    b.id_bicicleta, b.brand, b.tip;