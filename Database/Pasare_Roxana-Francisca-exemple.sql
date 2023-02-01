
---exercitiul11
---afisati numele spitalelor care au etiologii in cadrul careia se analizeaza evolutie_pacient in solon 212
SELECT DISTINCT CONCAT(CONCAT('',s.denumire),' are si etiologii secundare in salonul 212') as 'Rezultat'
FROM SPITAL s, DEPARTAMENT d, SECTIE sec, ETIOLOGIE e, DESFASURATOR desf, SALON sal
WHERE s.cod_spital=d.cod_spital and d.cod_departament=sec.cod_departament and sec.cod_sectie=e.cod_sectie
and e.cod_etiologie=desf.cod_etiologie and desf.cod_salon=sal.cod_salon and UPPER(sal.denumire) like UPPER('212');

SELECT * FROM SPITAL

----afisarea denumirii centrelor de donare care s-au infiintat pe strada Bd. Marasesti nr.63
SELECT c.DENUMIRE as 'Nume centru'
FROM CENTRU_DONARE c
INNER JOIN SPITAL ON 
c.COD_CENTRU=SPITAL.COD_SPITAL
WHERE SPITAL.ADRESA='Bd. Marasesti nr. 63'
SELECT * FROM DOCTOR
select * from spital

---afisare nume, prenume, mail si daca salariul este peste media salarilor si lucreaza la facultati al caror cod postal incepe cu 284
SELECT d.NUME+' '+d.PRENUME as 'Nume', d.mail as 'Mail'
from DOCTOR d
where d.cod_doctor in(select cod_doctor 
					  from CONTRACT
					  WHERE SALARIU>(SELECT AVG(SALARIU) 
					  FROM CONTRACT)) 
		and d.cod_doctor in(select cod_doctor
							from CONTRACT
							WHERE cod_spital in(select cod_spital 
							from SPITAL
							where cod_postal%100=28));

						

--afisare pentru fiecare pacient forma analizei si procentul sub forma unui mesaj folosind case
SELECT p.nume, p.prenume, a.forma, e.denumire,
case
when d.procent>90 then 'Starea de sanatate este buna!'
when d.procent>80 and d.procent<90 then 'Stare de sanatate constanta!'
else 'Stare inrautatita'
END AS 'Starea pacientului'
FROM EVOLUTIE_PACIENT e, DIAGNOSTIC d, ANALIZE a, PACIENT p
WHERE p.cod_pacient = d.cod_pacient and d.cod_analize = a.cod_analize and a.cod_evolutie = e.cod_evolutie
ORDER By p.nume, p.prenume, a.forma, e.denumire;
SELECT * FROM ETIOLOGIE

----Ordonare pacienti in functie de starea lor de sanatate afisand numele prenumele si forma de analiza realizata 
SELECT p.nume, p.prenume, a.forma
FROM pacient p, diagnostic d , analize a
WHERE p.cod_pacient = d.cod_pacient and a.cod_analize= a.cod_analize
ORDER By d.procent;

---exercitiul12
----UPDATE URI----
UPDATE CONTRACT
SET SALARIU=SALARIU+0.1*SALARIU
WHERE COD_DOCTOR IN(SELECT COD_DOCTOR 
					FROM DOCTOR 
					WHERE TELEFON LIKE '074%');


UPDATE DIAGNOSTIC
SET PROCENT=PROCENT+2
WHERE procent < 70 and cod_pacient in (select cod_pacient
                        from pacient
                        where sex LIKE 'F');
                        
UPDATE DIAGNOSTIC
SET PROCENT=PROCENT+2
WHERE procent > 50 and cod_pacient in (select cod_pacient
                        from pacient
                        WHERE TELEFON LIKE '074%');
--exercitiul 14
--creare secventa
CREATE SEQUENCE salary_increment
INCREMENT BY 50
START WITH 2800
MAXVALUE 9700
CYCLE


INSERT INTO CONTRACT
VALUES (2,'1989-02-22',4,NEXT VALUE FOR salary_increment)

INSERT INTO CONTRACT
VALUES (3,'1954-06-27',2,NEXT VALUE FOR salary_increment)

INSERT INTO CONTRACT
VALUES (3,'1967-03-13',4,NEXT VALUE FOR salary_increment)

INSERT INTO CONTRACT
VALUES (1,'1990-09-18',4,NEXT VALUE FOR salary_increment)

INSERT INTO CONTRACT
VALUES (3,'1989-12-22',3,NEXT VALUE FOR salary_increment)

select * from contract


---VIEW LMD
CREATE VIEW [Doctori care au salarii mari] AS
SELECT COUNT(*) AS 'Doctori'
FROM CONTRACT
WHERE CONTRACT.COD_DOCTOR IN (SELECT COD_DOCTOR FROM DOCTOR)
GROUP BY SALARIU/1000


SELECT * FROM [Doctori care au salarii mari]

--Operatie LMD care nu merge
SELECT * FROM [Doctori care au salarii mari]
WHERE [DOCTORI]< 1

--Operatie LMD care merge

SELECT * FROM [Doctori care au salarii mari]
WHERE [DOCTORI]>= 1

select * from contract
--sortare salarii
SELECT SALARIU,
CASE
WHEN SALARIU<3000 THEN 'Salariul este mic'
WHEN SALARIU BETWEEN 2000 AND 5000 THEN 'Salariul este mediu'
else 'Salariu este mare'
end as Salarii
from Contract

SELECT * FROM CONTRACT
SELECT * FROM spital
select * from centru_donare


SELECT COD_DOCTOR, COALESCE(SALARIU-0,2*SALARIU) "Noul salariu al doctorului"
FROM CONTRACT
WHERE COD_SPITAL IN (SELECT COD_SPITAL FROM CENTRU_DONARE WHERE COD_CENTRU=(SELECT COD_CENTRU FROM CENTRU_DONARE WHERE DATA_INSCRIERII='2010-02-07'));

SELECT CONCAT(CONCAT('->', ' '),s.DENUMIRE)+STR(s.COD_SPITAL) as "Denumire+cod"
FROM SPITAL s
where s.COD_SPITAL IN (SELECT COD_SPITAL 
						FROM SPITAL
						WHERE COD_SPITAL>2)
					AND s.COD_SPITAL in (SELECT s.COD_SPITAL
										FROM SPITAL
										WHERE (ADRESA IS NOT NULL));

---3 tab

select DENUMIRE
from spital s 
where s.cod_spital in (select cod_spital
						FROM CONTRACT
						WHERE COD_SPITAL
						IN ( SELECT COD_SPITAL 
						FROM CENTRU_DONARE
						WHERE DENUMIRE='CDSUUB' OR DENUMIRE='CDSCCB')
						);

SELECT * FROM CONTRACT
WHERE SALARIU IN (3050, 5000);

select * from etiologie

--se afiseaza doctorii care au de consultat pacienti la etiologia din sectia 1
select * from doctor d
where not exists(
select cod_etiologie
from desfasurator
where d.cod_doctor=cod_doctor
except
select cod_etiologie
from etiologie
where cod_sectie like '1%');

select * from evolutie_pacient 

--toti pacientii care au efectuat analizele pentru a fi observata evolutiei cu codul 1
select * from pacient p
where not exists(
(select cod_analize
from DIAGNOSTIC
where p.cod_pacient=cod_pacient)
except
(select cod_analize
from analize
where cod_evolutie=1));

---sa se afiseze pentru fiecare pacient numele si prenumie, forma analizei si evalutia sa
select p.nume, p.prenume, a.forma as 'Forma analiza', ev.denumire as 'Evolutie' 
from pacient p right outer join diagnostic d on (d.cod_pacient=p.cod_pacient) left outer join analize a
on (d.cod_analize=a.cod_analize) full outer join evolutie_pacient ev on(ev.cod_evolutie=a.cod_evolutie)

---sa se afiseze numarul de verdicte legate de evolutia pacientului realizate intr-un salon.
select s.cod_salon, isnull(count(d.cod_salon),0) as 'Numar verdicte'
from salon s left outer join desfasurator d on (s.cod_salon=d.cod_salon)
group by s.cod_salon

select * from contract
---index
create index index_doc
on contract(cod_doctor, cod_spital)
select
salariu
from contract
where cod_spital=1

select * from spital
---CODUL DOCTORILOR CARE AU SALARIUL PESTE MEDIE SI LUCREAZA IN SPITALUL CF WITTING
with salary(avgsalary) as (select avg(salariu) from contract  )
select cod_doctor
from contract, salary
where contract.salariu>salary.avgsalary and contract.cod_doctor in (select cod_doctor from desfasurator 
where cod_spital=(select cod_spital from spital where denumire='Spitalul CF Witting'))

select *
from contract
order by salariu