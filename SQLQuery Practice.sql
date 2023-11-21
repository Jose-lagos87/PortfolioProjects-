

/* MEDIUM 
1.- Show unique birth years from patients and order them by ascending. */ 

  

SELECT distinct YEAR(birth_date) 

FROM patients	 

order by birth_date 

 

/*2.- Show unique first names from the patients table which only occurs once in the list. 

For example, if two or more people are named 'John' in the first_name column then don't  

include their name in the output list. If only 1 person is named 'Leo' then include them in the output. */  

  

select distinct(first_name) 

from patients 

group by first_name 

having count(first_name) =1 

 

/*3.-Show patient_id and first_name from patients  

where their first_name start and ends with 's' and is at least 6 characters long.*/ 

 

select patient_id, first_name 

from patients 

where first_name like 's____%s' 

 

/*4.-Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'. 

Primary diagnosis is stored in the admissions table.*/ 

  

select	patients.patient_id, patients.first_name, patients.last_name 

FROM patients 

join admissions 

ON patients.patient_id = admissions.patient_id 

where admissions.diagnosis = 'Dementia' 

 

/*5.- Display every patient's first_name. 

Order the list by the length of each name and then by alphbetically*/ 

 

select first_name 

from	 patients  

order by len(first_name), 

first_name 

 

/*6.- Show the total amount of male patients and the total amount of female patients in the patients table. 

Display the two results in the same row.*/ 

select  count(gender) as total_male , 4530 - count(gender) as total_female 

from patients  

where gender = 'M' 

 Otra solucion: 

SELECT  

  (SELECT count(*) FROM patients WHERE gender='M') AS male_count,  

  (SELECT count(*) FROM patients WHERE gender='F') AS female_count; 

Otra solucion: 

SELECT  

  SUM(Gender = 'M') as male_count,  

  SUM(Gender = 'F') AS female_count 

FROM patients 

 

/*7.- Show first and last name, allergies from patients which have allergies to either  

'Penicillin' or 'Morphine'.  

Show results ordered ascending by allergies then by first_name then by last_name.*/ 

select first_name, last_name, allergies 

from patients 

where allergies='Penicillin' or allergies='Morphine' 

order by allergies, first_name, last_name 

/*8.- Show patient_id, diagnosis from admissions.  

Find patients admitted multiple times for the same diagnosis.*/ 

select	patient_id, diagnosis 

from admissions 

group by diagnosis, 

patient_id 

having count(*) >1 

 

/*9.- Show the city and the total number of patients in the city. 

Order from most to least patients and then by city name ascending.*/ 

select city, count(patient_id) as total_number_of_patients 

from patients 

group by city  

order by total_number_of_patients desc, city 

 

/*10.- Show first name, last name and role of every person that is either patient or doctor. 

The roles are either "Patient" or "Doctor"*/ 

SELECT first_name, last_name, 'Patient' as role FROM patients 

    union all 

select first_name, last_name, 'Doctor' from doctors; 

 

/*11.- Show all allergies ordered by popularity. Remove NULL values from query.*/ 

select allergies, count(allergies) as count_of_allergies 

from patients 

where allergies is not null 

group by allergies 

order by count_of_allergies desc 

 

 

 

 

 

/*12.- Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade.  

Sort the list starting from the earliest birth_date.*/ 

 

select first_name, last_name, birth_date 

from patients 

where year(birth_date) between 1970 and 1979 

order by birth_date 

 

/*13.- We want to display each patient's full name in a single column.  

Their last_name in all upper letters must appear first, then first_name in all lower case letters. 

Separate the last_name and first_name with a comma. Order the list by the first_name in  

decending order 

EX: SMITH,jane*/ 

  

select concat(upper(last_name),',',lower(first_name)) as column_name 

from patients 

order by first_name desc 

ANOTHER SOLUTION: 

SELECT 

  UPPER(last_name) || ',' || LOWER(first_name) AS new_name_format 

FROM patients 

ORDER BY first_name DESC;. 

 

/*14.- Show the province_id(s), sum of height;  

where the total sum of its patient's height is greater than or equal to 7,000.*/ 

SELECT 

  province_id, 

  SUM(height) AS sum_height 

FROM patients 

GROUP BY province_id 

HAVING sum_height >= 7000 

ANOTHER SOLUTION: 

select patients.province_id,SUM(height) as sum_height 

from patients 

full outer join province_names 

on patients.province_id = province_names.province_id 

group by patients.province_id 

having sum_height >=7000 

 

/*15.- Show the difference between the largest weight and smallest weight  

for patients with the last name 'Maroni'*/ 

 

select max(weight) - min(weight) as difference 

from patients 

where last_name = 'Maroni' 

 

/*16.- Show all of the days of the month (1-31) and how many admission_dates 

occurred on that day. Sort by the day with most admissions to least admissions.*/ 

 

select day(admission_date) as day_month, count(admission_date) as total_addmissions 

from admissions 

group by day_month 

order by total_addmissions desc 

 

/*17.- Show all columns for patient_id 542's most recent admission_date.*/ 

select * 

from admissions 

where patient_id = 542  

group by patient_id 

having max(admission_date) 

 

 

 

/* 18.- Show patient_id, attending_doctor_id, and diagnosis for admissions  

that match one of the two criteria: 

1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19. 

2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.*/ 

 

SELECT	patient_id, attending_doctor_id, diagnosis 

FROM admissions 

WHERE (patient_id%2) <>0 AND  attending_doctor_id IN (1,5,19) 

OR (attending_doctor_id LIKE '%2%' AND	len(patient_id) =3) 

 

/* 19.- Show first_name, last_name, and the total number of admissions attended for each doctor. 

Every admission has been attended by a doctor.*/  

  

select doctors.first_name, doctors.last_name, COUNT(admissions.admission_date) AS total_admission 

from doctors 

inner join admissions 

on doctors.doctor_id = admissions.attending_doctor_id 

group by admissions.attending_doctor_id 

ANOTHER SOLUTION: 

SELECT 

  first_name, 

  last_name, 

  count(*) 

from 

  doctors p, 

  admissions a 

where 

  a.attending_doctor_id = p.doctor_id 

group by p.doctor_id; 

 

 

/*20.- For each doctor, display their id, full name, and the first and last admission date they attended. */ 

select a.doctor_id, concat(a.first_name,' ',a.last_name) as full_doctor_name, 

min(b.admission_date) as first_admission, 

   	max(b.admission_date) as last_admission 

FROM doctors  a                                

INNER JOIN admissions b  

on a.doctor_id = b.attending_doctor_id 

group by full_doctor_name 

order by a.doctor_id 

 

/* 21.- Display the total amount of patients for each province. Order by descending. */

select  province_name, count(first_name) as total_amount 

from patients  a, 

 province_names  b 

where a.province_id = b.province_id 

group by a.province_id 

order by total_amount desc 

 

/*22.- For every admission, display the patient's full name, their admission diagnosis,  

and their doctor's full name who diagnosed their problem.*/ 

 

select concat(a.first_name,' ',a.last_name) as patients_name, 

   b.diagnosis, concat(c.first_name,' ',c.last_name) AS doctors_name 

from patients a 

inner join admissions b, doctors c   

on a.patient_id = b.patient_id and b.attending_doctor_id = c.doctor_id 

 

 

/* 23.- Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. (Their patient_id does not exist in any admissions.patient_id rows.) */ 

SELECT 

  patients.patient_id, 

  first_name, 

  last_name 

from patients 

where patients.patient_id not in ( 

    select admissions.patient_id 

    from admissions 

  ) 

 

 

 

/*ANOTHER SOLUTION */

SELECT 

  CONCAT(patients.first_name, ' ', patients.last_name) as patient_name, 

  diagnosis, 

  CONCAT(doctors.first_name,' ',doctors.last_name) as doctor_name 

FROM patients 

  JOIN admissions ON admissions.patient_id = patients.patient_id 

  JOIN doctors ON doctors.doctor_id = admissions.attending_doctor_id; 

 

/* 23.- display the number of duplicate patients based  

on their first_name and last_name.*/ 

 

select 

  first_name, 

  last_name, 

  count(*) as num_of_duplicates 

from patients 

group by 

  first_name, 

  last_name 

having count(*) > 1 

 

/* 24.- Display patient's full name, height in the units feet rounded to 1 decimal, weight in the unit pounds rounded to 0 decimals, birth_date, gender non abbreviated.   Convert CM to feet by dividing by 30.48. 
Convert KG to pounds by multiplying by 2.205. */ 

select concat(first_name,' ',last_name), round(height/30.48,1) as height_ft, 

round(weight*2.205,0) as weight_pounds, birth_date, 

case 

when gender = 'M' THEN 'Male' 

    when gender = 'F' then 'Female' 

  end  as gender_full 

from patients 

 

/*25.- Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. (Their patient_id does not exist in any admissions.patient_id rows.)*/ 

SELECT 

  patients.patient_id, 

  first_name, 

  last_name 

from patients 

  left join admissions on patients.patient_id = admissions.patient_id 

where admissions.patient_id is NULL 

 

 

 

 



/* HARD LEVEL
26.- Show all of the patients grouped into weight groups. 
Show the total amount of patients in each weight group. 
Order the list by the weight group decending. 
 
For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc */ 

select COUNT(*) AS patients_in_group,  

  	case 

    	when weight between 0 and 09 then 0 

        when weight between 10 and 19 then 10 

        when weight between 20 and 29 then 20 

        when weight between 30 and 39 then 30 

        when weight between 40 and 49 then 40 

        when weight between 50 and 59 then 50 

        when weight between 60 and 69 then 60 

        when weight between 70 and 79 then 70 

        when weight between 80 and 89 then 80 

        when weight between 90 and 99 then 90 

        when weight between 100 and 109 then 100 

        when weight between 110 and 119 then 110 

        when weight between 120 and 129 then 120 

        when weight between 130 and 139 then 130 

        when weight between 140 and 149 then 140 

    end as weight_group 

from patients 

group by weight_group 

order by weight_group desc 

 

 

ANOTHER SOLUTION 

SELECT 

  COUNT(*) AS patients_in_group, 

  FLOOR(weight / 10) * 10 AS weight_group 

FROM patients 

GROUP BY weight_group 

ORDER BY weight_group DESC; 

 

 

 

 

/*28.- Show patient_id, first_name, last_name, and attending doctor's specialty. 

Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's  

first name is 'Lisa' 

Check patients, admissions, and doctors tables for required information.*/ 

  

select patients.patient_id, patients.first_name, patients.last_name, doctors.specialty 

from patients 

inner join admissions 

on patients.patient_id = admissions.patient_id 

inner join doctors 

on admissions.attending_doctor_id = doctors.doctor_id 

where diagnosis = 'Epilepsy' and doctors.first_name like '%Lisa' 

 

/*29.- All patients who have gone through admissions, can see their medical documents on our site. 

Those patients are given a temporary password after their first admission. 

Show the patient_id and temp_password. 

The password must be the following, in order: 

1. patient_id 

2. the numerical length of patient's last_name 

3. year of patient's birth_date */ 

select distinct(admissions.patient_id),  

     concat(admissions.patient_id,len(patients.last_name),year(patients.birth_date)) as tem_pasword 

from patients 

right join	 admissions 

on patients.patient_id = admissions.patient_id 

 

 

 

ANOTHER SOLUTION 

SELECT 

  DISTINCT P.patient_id, 

  CONCAT( 

    P.patient_id, 

    LEN(last_name), 

    YEAR(birth_date) 

  ) AS temp_password 

FROM patients P 

  JOIN admissions A ON A.patient_id = P.patient_id 

 

/*30.-  Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance. 
 
Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group */ 

select   

case  

    	when patient_id % 2 = 0 then 'Yes' 

        else 'No' 

    end as has_insurance, 

    case  

    	when patient_id % 2 = 0 then 10*count(*) 

        else 50 * count(*) 

    end as admissions_total 

from admissions 

group by has_insurance 

 

ANOTHER SOLUTION 

select 'No' as has_insurance, count(*) * 50 as cost 

from admissions where patient_id % 2 = 1 group by has_insurance 

union 

select 'Yes' as has_insurance, count(*) * 10 as cost 

from admissions where patient_id % 2 = 0 group by has_insurance 

 

 

 

 

 

 

 

 

 

 

/*31.- Show the provinces that has more patients identified as 'M' than 'F'.  

Must only show full province_name*/ 

  

select b.province_name 

        from( 

        select province_id,  

               sum(gender='M') as tm, 

               sum(gender='F') as tf 

          from patients 

        group by province_id)   a 

inner join province_names   b 

on a.province_id = b.province_id 

where a.tm > a.tf 

 

ANOTHER SOLUTION 

SELECT province_name 

FROM ( 

    SELECT 

      province_name, 

      SUM(gender = 'M') AS n_male, 

      SUM(gender = 'F') AS n_female 

    FROM patients pa 

      JOIN province_names pr ON pa.province_id = pr.province_id 

    GROUP BY province_name 

  ) 

WHERE n_male > n_female 

 

/*32.- We are looking for a specific patient. Pull all columns for the patient  

who matches the following criteria: 

- First_name contains an 'r' after the first two letters. 

- Identifies their gender as 'F' 

- Born in February, May, or December 

- Their weight would be between 60kg and 80kg 

- Their patient_id is an odd number 

- They are from the city 'Kingston' */ 

 

select * 

FROM patients 

WHERE first_name LIKE '__r%' and 

  gender = 'F' and 

      month(birth_date) in (02,05,12) and 

      weight between 60 AND 80 and 

      patient_id % 2 <> 0 and 

      city = 'Kingston' 

 

 

 

 

 

       

/* 33.- Show the percent of patients that have 'M' as their gender. 

Round the answer to the nearest hundreth number and in percent form. 

 

SELECT  

   CONCAT(ROUND(SUM(gender='M') / CAST(COUNT(*) AS float), 4) * 100, '%') 

FROM patients; 

 

/*34.- For each day display the total amount of admissions on that day.  

Display the amount changed from the previous date.*/ 

  

with normal as ( 

select admission_date, count(patient_id) as amount_of_admissions 

from admissions 

group by admission_date ) 

select admission_date, amount_of_admissions, 

amount_of_admissions - lag(amount_of_admissions,1)  over(order by admission_date) as diference 

from normal 

 

ANOTHER SOLUTION 

SELECT 

admission_date, 

count(admission_date) as admission_day, 

count(admission_date) - LAG(count(admission_date)) OVER(ORDER BY admission_date) AS admission_count_change  

FROM admissions 

group by admission_date 

 

/* 35.- Sort the province names in ascending order in such 

a way that the province 'Ontario' is always on top.*/ 

  

select province_name 

from province_names 

order by 

case 

    	when province_name = 'Ontario' then 0 

        else 1 

    end, 

    province_name 

 

 

 

 

 

 

 

 

 

 

 

 

 

/*36.- We need a breakdown for the total amount of admissions each doctor has started each year. 

Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year. */ 

 

select doctors.doctor_id, concat(doctors.first_name,' ',doctors.last_name) as doctor_full_name, 

doctors.specialty, year(admission_date) as year, 

        count(admissions.attending_doctor_id) as total_admissions 

from doctors 

inner join admissions 

on doctors.doctor_id = admissions.attending_doctor_id 

group by doctor_full_name, year(admission_date) 

order by doctors.doctor_id 

 

 