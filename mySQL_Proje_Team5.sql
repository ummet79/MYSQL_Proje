-- (1.) D001 departmanındaki tüm çalışanları listele.

select dept_emp.dept_no ,first_name ,last_name,gender,hire_date
from employees
left join dept_emp ON dept_emp.emp_no=employees.emp_no
left join departments ON departments.dept_no=dept_emp.dept_no
Where departments.dept_no='D001';

-- (2.)'İnsan Kaynakları' departmanındaki tüm çalışanları listele
select  departments.dept_name, first_name, last_name, gender, hire_date
from employees
left join dept_emp ON dept_emp.emp_no = employees.emp_no
left join departments ON departments.dept_no = dept_emp.dept_no
Where departments.dept_name = 'Human Resources';

 -- (3.)Tüm çalışanların ortalama maaşını hesapla.
 
select avg(salary) as OrtalamaMaas
from salaries;

-- (4.)"Erkek" cinsiyetindeki tüm çalışanların ortalama maaşını hesapla.
 
 select avg(salaries.salary) as ErkekOrtalamaMaas
 from employees
 left join salaries ON salaries.emp_no = employees.emp_no
 Where employees.gender = 'M';


 -- (5.)"Kadın" cinsiyetindeki tüm çalışanların ortalama maaşını hesapla.
 
 select avg(salaries.salary) as KadınOrtalamaMaas
 from employees
 left join salaries ON salaries.emp_no = employees.emp_no
 Where employees.gender = 'F';
 
 -- (6.)Maaşı 70.000'den yüksek olan "Satış" departmanındaki tüm çalışanları listele

select  employees.emp_no, first_name, last_name, salaries.salary, departments.dept_name
 from employees
 left join salaries ON salaries.emp_no = employees.emp_no
 left  join dept_emp ON dept_emp.emp_no = salaries.emp_no
 left join departments ON dept_emp.dept_no = departments.dept_no
 Where salaries.salary > 70000 and departments.dept_name = 'Sales';

-- (7.)Bu sorgu, maaşı 50.000 ile 100.000 arasında olan çalışanları getirir.
  
  select employees.emp_no, first_name, last_name, salaries.salary 
  from employees
  left join salaries ON employees.emp_no = salaries.emp_no
  Where salaries.salary between 50000 and 100000;

-- (8.) Her departmanın ortalama maaşını hesapla (departman numarasına veya departman adına göre)
 
select dept_name, avg(salary) as ortalamaMaaş
from salaries
left join dept_emp ON salaries.emp_no=dept_emp.emp_no
left join departments ON dept_emp.dept_no=departments.dept_no
group by departments.dept_name;

 
--  (9.) Departman adlarını da içeren her departmanın ortalama maaşını hesapla.
 
select dept_name, avg(salary) as ortalamaMaaş
from salaries
left join dept_emp ON salaries.emp_no=dept_emp.emp_no
left join departments ON dept_emp.dept_no=departments.dept_no
group by departments.dept_name;

 
 --  (10.)'10102' iş numarasına sahip çalışanın tüm maaş değişikliklerini bul.
 
select * from departments;
select * from salaries;
select * from dept_emp;
select * from employees;

select from_date as tarihler, employees.emp_no, salary as maaşDeğişiklikleri
from employees
left join salaries ON employees.emp_no=salaries.emp_no
where employees.emp_no='10102'
and from_date>'1995-01-02'
order by maaşDeğişiklikleri asc; 

 -- (11.)Maaş numarası '10102' olan çalışanın maaş artışlarını bul ('to_date' sütununu kullanarak).
 
select to_date as tarihler, employees.emp_no, salary as maaşDeğişiklikleri
from employees
left join salaries ON employees.emp_no=salaries.emp_no
where employees.emp_no='10102'
and from_date>'1995-01-02'
order by tarihler asc; 

 
-- (12.) En yüksek maaşa sahip çalışanı bul. 

select employees.emp_no, first_name, salary
from employees
left join salaries ON salaries.emp_no = employees.emp_no
Where salaries.salary = (select max(salary) from salaries); -- En yüksek maaşı bulmak için bir alt sorgu kullanmak.

-- (13.)Her çalışanın en son maaşlarını bul.(from_date: Maaşın başlangıç tarihi   to_date: Maaşın bitiş tarihi)

select employees.emp_no, employees.first_name, employees.last_name, salaries.salary
from employees 
left join salaries ON employees.emp_no = salaries.emp_no
Where salaries.to_date = (select MAX(to_date) from salaries Where emp_no = employees.emp_no);
    
-- (14.)"Satış" departmanındaki çalışanların adını, soyadını ve en yüksek maaşını listele.
-- Listeyi en yüksek maaşa göre azalan şekilde sırala ve sadece en yüksek maaşa sahip çalışanı göster
 
 select first_name AS ad, last_name AS soyad,MAX(salaries.salary) AS en_yuksek_maas
from employees 
left join dept_emp ON employees.emp_no = dept_emp.emp_no
left join departments ON departments.dept_no = dept_emp.dept_no
left join salaries ON employees.emp_no = salaries.emp_no
where departments.dept_name = 'Sales' 
group by first_name, last_name
order by en_yuksek_maas DESC
LIMIT 1;
 
-- (15.)Araştırma Departmanındaki Ortalama En Yüksek Maaşlı Çalışanı Bul
 
select employees.emp_no, first_name, last_name, salaries.salary
from employees 
left join salaries ON employees.emp_no = salaries.emp_no
left join dept_emp ON salaries.emp_no = dept_emp.emp_no  
left join departments ON departments.dept_no = dept_emp.dept_no
where departments.dept_name = 'Research' 
AND salaries.salary = (select MAX(salary) FROM salaries WHERE emp_no = employees.emp_no)  -- Araştırma departmanındaki en yüksek maaşı alan çalışan
order by salaries.salary DESC  -- Maaşa göre azalan sırada sıralama
LIMIT 1;  -- En yüksek maaşlı çalışanı al( Eğer birden fazla çalışan aynı maaşı alıyorsa, sadece ilkini döndürecektir. )

-- (16.) Her departman için, kaydedilmiş en yüksek tek maaşı belirle.Departman adını, çalışanın adını, soyadını ve en yüksek maaş tutarını listele. Sonuçları en yüksek maaşa göre azalan şekilde sırala
 
 select departments.dept_name, first_name, last_name, MAX(salaries.salary) AS En_Yüksek_Maaş
from departments 
left join dept_emp ON departments.dept_no = dept_emp.dept_no
left join employees ON dept_emp.emp_no = employees.emp_no
left join salaries ON employees.emp_no = salaries.emp_no        
group by departments.dept_name , employees.emp_no, first_name, last_name
order by En_Yüksek_Maaş DESC;	 
       


 --  (17.)Her departmandaki en yüksek ortalama maaşa sahip çalışanları belirle. 
 -- Departman adını, çalışanın adını, soyadını ve ortalama maaşı listele. 
 -- Sonuçları departmanlarına göre azalan şekilde sırala, sadece kendi departmanlarında en yüksek ortalama maaşa sahip olanları göster
 

-- (18.)1990-01-01 tarihinden önce işe alınan tüm çalışanların adlarını, soyadlarını ve işe alınma tarihlerini alfabetik sırayla listele

select first_name, last_name, hire_date
from employees
where hire_date < '1990-01-01'
order by first_name, last_name; -- adları aynıysa soyadlara göre sıralıyoruz.

-- (19.)1985-01-01 ile 1989-12-31 tarihleri arasında işe alınan tüm çalışanların adlarını, soyadlarını ve işe alınma tarihlerini işe alınma tarihine göre sıralı olarak listele

select first_name, last_name, hire_date
from employees
where hire_date between '1985-01-01' and '1989-12-31'
order by hire_date; 

 -- (20.)1985-01-01 ile 1989-12-31 tarihleri arasında işe alınan Satış departmanındaki tüm çalışanların
 -- adlarını, soyadlarını, işe alınma tarihlerini ve maaşlarını, maaşa göre azalan şekilde sıralı olarak listele.

select first_name, last_name, hire_date, salaries.salary
from employees
left join salaries ON employees.emp_no = salaries.emp_no
left join dept_emp ON salaries.emp_no = dept_emp.emp_no  
left join departments ON departments.dept_no = dept_emp.dept_no
where hire_date between '1985-01-01' and '1989-12-31'
and departments.dept_name = 'Sales'
order by salaries.salary desc; 

--  (21.) a.Erkek çalışanların sayısını bulun (179973) 
select count(*) as erkekçalışanlar -- tüm satırları saymak için count(*) kullanılır
from employees
Where gender ='M';

-- (21.) b.Kadın çalışanların sayısını belirleyin (120050)

select count(*) as kadınçalışanlar
from employees
Where gender ='F';

-- (21.) c.Gruplandırarak erkek ve kadın çalışanların sayısını bulun:

select count(*) as KadınVeErkekÇalışanlar
from employees
group by gender;

-- (21.) d.Şirketteki toplam çalışan sayısını hesaplayın (300023)

select count(*) as toplamÇalışanlar 
from employees;

-- (22.) a.Kaç çalışanın benzersiz ilk adı olduğunu bulun (1275)

select count(DISTINCT first_name)  as benzersizAd -- Sadece her değeri bir kez sayar.
from employees;


-- (22.) b.Farklı bölüm adlarının sayısını belirleyin (9)

select count(DISTINCT dept_name)  as benzersizDepartman -- Sadece her değeri bir kez sayar.
from departments;

-- (23.) Her bölümdeki çalışan sayısını listele

select departments.dept_name, count(*) as çalışanSayısı -- count(*) her deppartman için çalışan sayısını hesaplar.
from departments
left join dept_emp ON departments.dept_no = dept_emp.dept_no
group by departments.dept_name;


-- (24.) 1990-- 1990-02-20 tarihinden sonraki son 5 yıl içinde işe alınan tüm çalışanları listele(?)

select first_name, last_name, hire_date
from employees
Where hire_date > '1990-02-20' -- 1990-02-20 tarihinden 5 yıl sonrası, yani 1995-02-20.
and hire_date <= '1995-02-20'
order by hire_date;

-- (25.) "Annemarie Redmiles" adlı çalışanın bilgilerini (çalışan numarası, doğum tarihi, ilk adı, soyadı, cinsiyet, işe alınma tarihi) listele.

select * from employees
where first_name = 'Annemarie' and last_name = 'Redmiles';



-- (26.) "Annemarie Redmiles" adlı çalışanın tüm bilgilerini (çalışan numarası, doğum tarihi, ilk adı,soyadı, cinsiyet, işe alınma tarihi, maaş, departman ve unvan) listele
  select employees.emp_no as calisan_numarasi,
    birth_date as dogum_tarihi,
    first_name as isim,
    last_name as soyisim,
    gender as cinsiyet,
    hire_date as ise_alim_tarihi,
    salaries.salary as maas,
    departments.dept_name as departman,
    titles.title as unvan
    from employees
left join salaries ON employees.emp_no = salaries.emp_no
left join dept_emp ON employees.emp_no = dept_emp.emp_no
left join departments ON dept_emp.dept_no = departments.dept_no
left join titles ON employees.emp_no = titles.emp_no 
where first_name = 'Annemarie' and last_name = 'Redmiles';

-- (27.) D005 bölümündeki tüm çalışanları ve yöneticileri listele

select employees.emp_no, first_name, last_name, gender, birth_date, hire_date, dept_manager.dept_no
from employees
left join dept_manager ON employees.emp_no = dept_manager.emp_no
where employees.emp_no IN (
    select emp_no 
    from dept_emp 
    where dept_no = 'D005'
) And dept_manager.dept_no = 'D005';


-- (28.)'1994-02-24' tarihinden sonra işe alınan ve 50.000'den fazla kazanan tüm çalışanları listele
select employees.emp_no, first_name, last_name, employees.hire_date, salaries.salary
from  employees 
left join salaries ON employees.emp_no = salaries.emp_no
where   employees.hire_date > '1994-02-24'
and salaries.salary > 50000;
  
 -- (29.) "Satış" bölümünde "Yönetici" unvanıyla çalışan tüm çalışanları listele
 select  employees.emp_no, first_name, last_name, titles.title, departments.dept_name, hire_date
 from employees
left join titles ON employees.emp_no = titles.emp_no
left join dept_emp ON employees.emp_no = dept_emp.emp_no
left join departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales' 
AND titles.title = 'Manager';
 
-- (30.) '10102' numaralı çalışanın en uzun süre çalıştığı departmanı bul



-- (31.) D004 bölümünde en yüksek maaş alan çalışanı bulun

select  employees.emp_no, first_name, last_name, salaries.salary
from employees
left join salaries ON employees.emp_no = salaries.emp_no
left join dept_emp ON employees.emp_no = dept_emp.emp_no
left join departments ON departments.dept_no = dept_emp.dept_no
where  departments.dept_no = 'D004'
order by salaries.salary DESC -- Maaşları büyükten küçüğe sıralar.
LIMIT 1; -- En yüksek maaş alan çalışanı alır.

-- (32.) '10102' numaralı çalışanın tüm pozisyon geçmişini bulun

select employees.emp_no, first_name, last_name, departments.dept_name, dept_emp.from_date, dept_emp.to_date
from employees
left join dept_emp ON employees.emp_no = dept_emp.emp_no
left join departments ON dept_emp.dept_no = departments.dept_no
where employees.emp_no = '10102'
order by dept_emp.from_date;


-- (33.) Ortalama "çalışan yaşını" bulma



-- (34.) Bölüm başına çalışan sayısını bulma

select departments.dept_name, COUNT(employees.emp_no) AS çalışanSayısı -- Her bölüm için, o bölümdeki çalışanların sayısını hesaplamak için kullanılır(COUNT(employees.emp_no))
from employees
left join dept_emp ON employees.emp_no = dept_emp.emp_no
left join departments ON dept_emp.dept_no = departments.dept_no
group by departments.dept_name;


-- (35.) 110022 numaralı çalışanın yönetim geçmişini bulma

select employees.emp_no, first_name, last_name, departments.dept_name, dept_manager.from_date, dept_manager.to_date
from employees
left join dept_manager ON employees.emp_no = dept_manager.emp_no
left join departments ON dept_manager.dept_no = departments.dept_no
where employees.emp_no = '110022';

-- (36.) Her çalışanın istihdam süresini bulma

select  emp_no, hire_date,
current_date() - hire_date AS istihdam_suresi_gun -- (CURRENT_DATE - hire_date:) Bu ifade, işe başlama tarihi ile bugünün tarihi arasındaki farkı hesaplar
from employees;
    

-- (37.) Her çalışanın en son unvan bilgisini bulma

select titles.emp_no, titles.title
from titles
where (titles.emp_no, titles.from_date) IN (
    select emp_no, MAX(from_date)
    from titles
    group by emp_no
);

-- (38.) 'D005' bölümünde yöneticilerin adını ve soyadını bulma

select first_name, last_name
from employees 
left join dept_manager ON employees.emp_no = dept_manager.emp_no
left join departments ON dept_manager.dept_no = departments.dept_no
WHERE departments.dept_no = 'D005';

--  (39.)Çalışanları doğum tarihlerine göre sıralama

select emp_no, first_name, last_name, birth_date
from employees
order by birth_date;

-- (40.) Nisan 1992'de işe alınan çalışanları listeleme
 
 select emp_no, first_name, last_name, hire_date 
from employees
where hire_date between '1992-04-01' and '1992-04-30';

 -- (41.) '10102' numaralı çalışanın çalıştığı tüm bölümleri bulma.
 
 select departments.dept_name
from departments 
left join dept_emp ON departments.dept_no = dept_emp.dept_no
where dept_emp.emp_no = '10102';
