# ASVSP

## Osnovne informacije
Projekat je napravljen za potrebe predmeta arhitekture sistema velikih skupova podataka. Ideja je da ovaj projekat posluži kao primjer projekta koji studenti treba da implementiraju.

## Pokretanje
Preduslov pokretanja je preuzimanje skupa podataka `packets_sample.jsonl` putem ovog [linka](https://drive.google.com/file/d/1l5bOQjMhfCFsYrIRGiKRnnCU8DkJMBqF/view?usp=drive_link). Skup podataka je potrebno ubaciti u direktorijum `Airflow/files/data`. Da bi se projekat pokrenuo potrebno je izvršiti skriptu `./scripts/cluster_up.sh`. Nakon pokretanja skripte potrebno je kroz prompt potvrditi restore baze podataka vizualizacionog alata Metabase da bi se već napravljeni dashobard i chart- ovi učitali u suprotnom biće podignuta "prazna" instanca Metabase- a.

Apache Airflow je alat putem kog se orkestrira rad klastera i sastoji se od tri osnovna DAG- a koji se trebaju pokrenuti u sledećem redoslijedu: 
* `load_raw_data.py` - koristi se za postavljanje skupa podataka na HDFS, što predstavlja upis u sirovu zonu;
* `transform_raw_data.py` - sastoji se od task- ova koji predstavljaju Apache Spark poslove koji se šalju Apache Spark master čvoru na izvršenje i time se od sirovih podataka formiraju podaci u zoni transformacija na HDFS- u;
* `analytical_queries.py` - sastoji se od task- ova koji predstavljaju Apache Spark poslove koji se šalju Apache Spark master čvoru na izvršenje i time se od podataka iz zone transformacija dobijaju pročišćeni podaci koji se upisuju u Mongo bazu podataka;

Skup podataka (batch/istorijski skup podataka) predstavlja kolekciju zapisa mrežne komunikacije. Na osnovu podataka potrebno je dati odgovore na sledeća pitanja:
* Koja je prosječna veličina paketa (ethernet) u bajtovima u toku dana?
* Koji je prosječan broj paketa (ethernet) koji se šalju u toku dana?
* Sa kojih IP adresa su se najviše slali paketi?
* Koje IP adrese su zaprimile najviše paketa?
* Koja je zastupljenost različitih protokola (TCP, UDP...)?
* Kojih 5 portova je najviše zastupljeno (TCP/UDP)?
* Prema kojim  DNS domenima su najčešće postavljani upiti?
* Koliko dugo mogu biti keširani DNS domeni u sekundama?

Odgovori na pitanja se mogu naći u sklopu Metabase dashboard- a pod nazivom `Historical data - Internet traffic`.

U nastavku je opisan način pristupa pojedinačnim alatima klastera.

## Apache Airflow

Pristupa se putem WEB adrese [http://localhost:8080](http://localhost:8080). Kredencijali za pristup:
```
username: airflow
password: airflow
```

## Hadoop

Pristupa se putem WEB adrese [http://localhost:9870](http://localhost:9870). Moguće je pregledati distribuirani file sistem (HDFS).

## Apache Spark

Pristupa se putem WEB adrese [http://localhost:8000](http://localhost:8000). Moguće je pratiti izvršenje poslova koji su predati Apache Spark klasteru.

## MongoDB

Moguće je vizualizovati bazu podataka kroz Mongo Express ili neki alat poput Jet Brains Data Grip. Kredencijali za pristup:
```
username: admin
password: admin
```

## Metabase

Pristupa se putem WEB adrese [http://localhost:3000](http://localhost:3000). Vizualizacioni alat koji služi za prikaz pročišćenih podataka (podataka iz Mongo baze). Ukoliko na početku pokretanja klastera nije odabrana opcija da se uradi restore baze podataka ovog alata biće podignuta "prazna" instanca. Kredencijali za pristup:
```
username: asvsp@uns.ac.rs
password: asvsp25
```