
-- TABLE CLEANUP SCRIPT
set serveroutput on
declare
    table_exists varchar(1) := 'Y';
    sql_command varchar(2000);
begin
   dbms_output.put_line('###Start schema cleanup###');
   for i in ( select 'JOB_POST_SKILL' table_name from dual union all
	select 'USER_SKILL' table_name from dual union all
        select 'JOB_EDUCATION_REQ' table_name from dual union all
	select 'USER_EDUCATION' table_name from dual union all
	select 'APPLICATION_TRACKING' table_name from dual union all
        select 'APPLICATIONS' table_name from dual union all
	select 'JOBPOST' table_name from dual union all
	select 'JOB_LOCATION' table_name from dual union all
	select 'COMPANY' table_name from dual union all
	select 'SKILLSET' table_name from dual union all
	select 'EDUCATION' table_name from dual union all
	select 'JOB_CATEGORY' table_name from dual union all
	select 'USERS' table_name from dual 
   )
   loop
   dbms_output.put_line('Dropping the table: '||i.table_name);
   begin
       select 'Y' into table_exists
       from USER_TABLES
       where TABLE_NAME=i.table_name;

       sql_command := 'drop table '||i.table_name;
       execute immediate sql_command;
       dbms_output.put_line('Table '||i.table_name||'has been dropped successfully');
       
   exception
       when no_data_found then
           dbms_output.put_line('Table already dropped');
   end;
   end loop;
   dbms_output.put_line('###Schema cleanup successfully completed###');
exception
   when others then
      dbms_output.put_line('Failed to execute code:'||sqlerrm);
end;
/

--CREATE TABLES for Job location
create table Job_Location(Job_Location_Id NUMBER CONSTRAINT Job_Location_PK primary key, 
Country varchar2(80) not null,
States VARCHAR(80) not null, 
City VARCHAR(80) not null,
CONSTRAINT Job_Location_unique UNIQUE (States, City))
/
-- creates table for the different job category
create table Job_Category(Job_Category_ID NUMBER CONSTRAINT Job_Category_PK primary key, 
Job_Type varchar2(40) CONSTRAINT Job_Type_Check CHECK(Job_Type IN ('ONSITE','HYBRID','REMOTE')))
/
-- creates table for the different companies
create table Company(Company_ID NUMBER CONSTRAINT Company_PK primary key, 
Company_Name varchar2(40) not null, 
Company_Description varchar2(400) not null, 
Industy_Type varchar2(40) not null, 
Company_Size Number not null)
/

-- creates table for the different skill sets
create table Skillset(Skillset_ID NUMBER CONSTRAINT Skillset_PK primary key, 
Skill_Name varchar2(40) not null, 
Skill_Type varchar2(40) CONSTRAINT Skill_Type_Check CHECK(Skill_Type IN ('TECHNICAL','SOFTSKILLS')))
/

-- creates table to list education of the user
create table Education(Degree_ID NUMBER CONSTRAINT Degree_PK primary key, 
Degree_Name varchar2(40) not null, 
Degree_Type varchar2(40) not null)
/

-- creates table for the job post
create table JOBPOST(JobPost_ID NUMBER CONSTRAINT JobPost_PK primary key, 
Job_Title varchar2(40) not null, 
Creation_Date Date not null,
Job_Description varchar2(400) not null,
Salary NUMBER not null,
Created_By varchar2(40) not null,
Hiring_Status varchar2(40) CONSTRAINT Hiring_Status_Check CHECK(Hiring_Status IN ('AVAILABLE','EXPIRED')),
Job_Location_Id NUMBER NOT NULL CONSTRAINT Job_Location_Id_FK REFERENCES Job_Location(Job_Location_Id) ON DELETE CASCADE,
Job_Category_ID NUMBER NOT NULL CONSTRAINT Job_Category_ID_FK REFERENCES Job_Category(Job_Category_ID) ON DELETE CASCADE,
Job_Company_Id NUMBER NOT NULL CONSTRAINT Job_Company_Id_FK REFERENCES Company(Company_ID) ON DELETE CASCADE)
/
-- creates table for the users
create table USERS(User_ID NUMBER CONSTRAINT User_PK primary key, 
First_Name varchar2(40) not null, 
Last_Name varchar2(40) not null,
Date_of_Birth Date not null,
Gender varchar2(40) CONSTRAINT Gender_Check CHECK(Gender IN ('MALE','FEMALE','OTHER')),
Phone_Number NUMBER NOT NULL CONSTRAINT Phone_Number_Unq UNIQUE,
Role_Type varchar2(40) CONSTRAINT Role_Type_Check CHECK(Role_Type IN ('JOBSEEKER','RECRUITER')))
/
-- creates table for the applications
create table APPLICATIONS(Application_Id NUMBER CONSTRAINT Application_PK primary key, 
Current_Status varchar2(40) CONSTRAINT Current_Status_Check CHECK(Current_Status IN ('APPLIED','HIRED','INTERVIEW_SCHEDULED', 'REJECTED')),
Application_Date Date not null,
Job_Post_ID NUMBER NOT NULL CONSTRAINT Job_Post_ID_FK REFERENCES JobPost(JobPost_ID) ON DELETE CASCADE,
User_Id NUMBER NOT NULL CONSTRAINT User_Id_FK REFERENCES USERS(User_ID) ON DELETE CASCADE)
/

-- creates table for application tracking
create table APPLICATION_TRACKING(Application_Tracking_ID NUMBER CONSTRAINT Application_Tracking_PK primary key, 
Status varchar2(40) CONSTRAINT Status_Check CHECK(Status IN ('APPLIED','HIRED','INTERVIEW_SCHEDULED', 'REJECTED')),
Changed_On Date not null,
Modified_By varchar2(40) not null,
Application_ID NUMBER NOT NULL CONSTRAINT Application_ID_FK REFERENCES APPLICATIONS(Application_ID) ON DELETE CASCADE)
/

-- creates bridge table between user and education
create table USER_EDUCATION(Start_Date date not null ,
End_Date DATE NOT NULL,
Users_ID NUMBER NOT NULL CONSTRAINT Users_ID_FK REFERENCES USERS(User_ID) ON DELETE CASCADE,
Degree_ID NUMBER NOT NULL CONSTRAINT DegreeID_FK REFERENCES EDUCATION(Degree_ID) ON DELETE CASCADE,
CONSTRAINT CheckEndLaterThanStart CHECK (End_Date >= Start_Date));
/

-- creates bridge table between job post and education
create table JOB_EDUCATION_REQ(JobPost_ID NUMBER NOT NULL CONSTRAINT JobPost_ID_FK REFERENCES JOBPOST(JobPost_ID) ON DELETE CASCADE,
Degree_ID NUMBER NOT NULL CONSTRAINT Degree_ID_FK REFERENCES EDUCATION(Degree_ID) ON DELETE CASCADE)
/

-- creates a bridge table between job posts and skillset
CREATE TABLE JOB_POST_SKILL(JobPostSkill_ID NUMBER NOT NULL CONSTRAINT JobPostSkill_ID_FK REFERENCES JOBPOST(JobPost_ID) ON DELETE CASCADE,
SkillSet_ID NUMBER NOT NULL CONSTRAINT SkillSet_ID_FK REFERENCES Skillset(Skillset_ID) ON DELETE CASCADE)
/

-- creates bridge table between user and skillset
Create table User_Skill(User_ID NUMBER NOT NULL CONSTRAINT UserID_FK REFERENCES USERS(User_ID) ON DELETE CASCADE,
SkillSet_ID NUMBER NOT NULL CONSTRAINT Skill_Set_ID_FK REFERENCES Skillset (Skillset_ID) ON DELETE CASCADE);
/

-------- Inserting data into the table Job Location ----------------

INSERT INTO Job_Location(Job_Location_Id, Country, States, City)
 select 101, 'United States', 'California', 'San Francisco' from dual union all
 select 102, 'United States', 'California', 'Los Angeles' from dual union all
 select 103, 'United States', 'New York', 'New York' from dual union all
 select 104, 'United States', 'Texas', 'Austin' from dual union all
 select 105, 'United States', 'Texas', 'Houston' from dual union all
 select 106, 'United States', 'Washington', 'Seattle' from dual union all
 select 107, 'United States', 'Illinois', 'Chicago' from dual union all
 select 108, 'United States', 'Georgia', 'Atlanta' from dual union all
 select 109, 'United States', 'Colorado', 'Denver' from dual union all
 select 110, 'United States', 'Florida', 'Miami' from dual;
 
-------- Inserting data into the table Job Category ------------------
 
INSERT INTO Job_Category(Job_Category_ID, Job_Type)
 select 101, 'ONSITE' from dual union all
 select 102, 'REMOTE' from dual union all
 select 103, 'HYBRID' from dual;
 
-------- Inserting data into the table Company ------------------
 
INSERT INTO Company(Company_ID, Company_Name, Company_Description, Industy_Type, Company_Size)
 select 101, 'TechSoft', 'TechSoft is a software company.', 'Technology', 150 from dual union all
 select 102, 'FoodMart', 'FoodMart is a supermarket chain.', 'Retail', 500 from dual union all
 select 103, 'GreenEnergy', 'GreenEnergy is an energy company.', 'Energy', 200 from dual union all
 select 104, 'SwiftBank', 'SwiftBank is a financial services provider.', 'Banking', 300 from dual union all
 select 105, 'MediCare', 'MediCare is a healthcare provider.', 'Healthcare', 350 from dual union all
 select 106, 'ABC Corp', 'ABC Corp is software company', 'Technology', 1000 from dual union all
 select 107, 'EduCenter', 'EduCenter is an educational services provider.', 'Education', 75 from dual;
 
-------- Inserting data into the table Skillset ------------------
 
INSERT INTO Skillset(Skillset_ID, Skill_Name, Skill_Type)
select 101, 'Java', 'TECHNICAL' from dual union all
select 102, 'Communication', 'SOFTSKILLS' from dual union all
select 103, 'Public Speaking', 'SOFTSKILLS' from dual union all
select 104, 'Python', 'TECHNICAL' from dual union all
select 105, 'MySQL', 'TECHNICAL' from dual union all
select 106, 'Problem Solving', 'SOFTSKILLS' from dual union all
select 107, 'Leadership', 'SOFTSKILLS' from dual union all
select 108, 'R Studio', 'TECHNICAL' from dual union all
select 109, 'Teamwork', 'SOFTSKILLS' from dual union all
select 110, 'Project Management', 'SOFTSKILLS' from dual union all
select 111, 'Data Analysis', 'TECHNICAL' from dual;
 
-------- Inserting data into the table Users ------------------

INSERT INTO USERS (User_ID, First_Name, Last_Name, Date_of_Birth, Gender, Phone_Number, Role_Type)
select 101, 'John', 'Doe', TO_DATE('1990-01-01', 'YYYY-MM-DD'), 'MALE', 1234567890, 'JOBSEEKER' from dual union all
select 102, 'Jane', 'Doe', TO_DATE('1995-02-14', 'YYYY-MM-DD'), 'FEMALE', 2345678901, 'JOBSEEKER' from dual union all
select 103, 'Bob', 'Smith', TO_DATE('1985-07-22', 'YYYY-MM-DD'), 'MALE', 3456789012, 'RECRUITER' from dual union all
select 104, 'David', 'Lee', TO_DATE('2003-04-15', 'YYYY-MM-DD'), 'MALE', 5678901234, 'JOBSEEKER' from dual union all
select 105, 'Sarah', 'Kim', TO_DATE('1991-09-28', 'YYYY-MM-DD'), 'FEMALE', 6789012345, 'JOBSEEKER' from dual union all
select 106, 'Emily', 'Wang', TO_DATE('1994-11-11', 'YYYY-MM-DD'), 'FEMALE', 8901234567, 'JOBSEEKER' from dual;

-------- Inserting data into the table Education ------------------

INSERT INTO Education(Degree_ID, Degree_Name, Degree_Type)
select 101, 'Engineering Management', 'Masters' from dual union all
select 102, 'Business Administration', 'Bachelors' from dual union all
select 103, 'Business Administration', 'Masters' from dual union all
select 105, 'Computer Science','Masters' from dual union all
select 104, 'Computer Science','Bachelors' from dual union all
select 107, 'Information System', 'Masters' from dual union all
select 106, 'Industrial Engineering','Masters' from dual;


-------- Inserting data into the table Job Post ------------------

INSERT INTO JOBPOST(JobPost_ID, Job_Title, Creation_Date, Job_Description, Created_By, Salary, Hiring_Status, Job_Location_Id, Job_Category_ID, Job_Company_Id)
select 101, 'Software Developer', TO_DATE('2022-02-15', 'YYYY-MM-DD'), 'We are seeking a skilled software developer to join our team.', user, 50000, 'AVAILABLE', 101, 101, 101 from dual union all
select 102, 'Marketing Manager', TO_DATE('2022-03-01', 'YYYY-MM-DD'), 'We are looking for an experienced marketing manager to lead our team.', user,100000, 'AVAILABLE', 102, 102, 102 from dual union all
select 103, 'Data Analyst', TO_DATE('2022-02-28', 'YYYY-MM-DD'), 'We are seeking a data analyst to help us make informed business decisions.', user, 60000,'AVAILABLE', 101, 103, 103 from dual union all
select 104, 'Finance Manager', TO_DATE('2022-03-15', 'YYYY-MM-DD'), 'We are looking for a finance manager to oversee our financial operations.', user, 120000,'AVAILABLE', 103, 102, 104 from dual union all
select 105, 'IT Support Specialist', TO_DATE('2022-02-20', 'YYYY-MM-DD'), 'We are seeking an IT support specialist to assist our employees with technical issues.', user,130000, 'AVAILABLE', 104, 101, 105 from dual union all
select 106, 'Sales Manager', TO_DATE('2022-03-20', 'YYYY-MM-DD'), 'We are seeking an experienced sales manager to lead our team and drive sales growth.', user, 4000,'AVAILABLE', 105, 102, 105 from dual union all
select 107, 'Project Manager', TO_DATE('2022-03-10', 'YYYY-MM-DD'), 'We are looking for a skilled project manager to oversee our projects and ensure they are completed on time and within budget.', user,140000, 'AVAILABLE', 106, 103, 101 from dual union all
select 108, 'HR Manager', TO_DATE('2022-03-01', 'YYYY-MM-DD'), 'We are looking for an experienced HR manager to oversee our HR department and manage employee relations.', user, 700000,'AVAILABLE', 108, 103, 103 from dual;

-------- Inserting data into the table Applications ------------------

INSERT INTO APPLICATIONS(Application_ID, Current_Status, Application_Date, Job_Post_ID, User_ID)
select 321, 'APPLIED', TO_DATE('2023-03-23', 'YYYY-MM-DD'), 101,105 from dual UNION ALL
select 322, 'REJECTED', TO_DATE('2023-02-10', 'YYYY-MM-DD'),  101, 102 from dual union all
select 323, 'HIRED', TO_DATE('2023-02-06', 'YYYY-MM-DD'),  102, 102 from dual union all
select 324, 'INTERVIEW_SCHEDULED', TO_DATE('2023-02-10', 'YYYY-MM-DD'),  105, 105 from dual union all
select 325, 'INTERVIEW_SCHEDULED', TO_DATE('2023-01-09', 'YYYY-MM-DD'),  103, 102 from dual union all
select 326, 'APPLIED', TO_DATE('2023-01-24', 'YYYY-MM-DD'),  103, 105 from dual union all
select 327, 'HIRED', TO_DATE('2023-02-22', 'YYYY-MM-DD'),  104, 105 from dual union all
select 328, 'APPLIED', TO_DATE('2022-12-30', 'YYYY-MM-DD'),  106, 102 from dual union all
select 329, 'APPLIED', TO_DATE('2023-02-21', 'YYYY-MM-DD'),  106, 104 from dual union all
select 330, 'APPLIED', TO_DATE('2023-02-09', 'YYYY-MM-DD'),  106, 106 from dual UNION ALL
select 331, 'INTERVIEW_SCHEDULED', TO_DATE('2023-01-10', 'YYYY-MM-DD'),  101, 101 from dual union all
select 332, 'HIRED', TO_DATE('2023-02-12', 'YYYY-MM-DD'),  101, 106 from dual;

-------- Inserting data into the table Application Tracking ------------------

INSERT INTO APPLICATION_TRACKING (APPLICATION_TRACKING_ID, STATUS, CHANGED_ON, MODIFIED_BY, APPLICATION_ID)
select 401, 'APPLIED', TO_DATE('3/23/2023', 'MM/DD/YYYY'), user, 321 from dual UNION ALL
select 402, 'APPLIED', TO_DATE('2/10/2023', 'MM/DD/YYYY'), user, 322 from dual UNION ALL
select 403, 'INTERVIEW_SCHEDULED', TO_DATE('2/23/2023', 'MM/DD/YYYY'), user, 322 from dual UNION ALL
select 404, 'REJECTED', TO_DATE('3/15/2023', 'MM/DD/YYYY'), user, 322 from dual UNION ALL
select 405, 'APPLIED', TO_DATE('1/13/2023', 'MM/DD/YYYY'), 'Jane Doe', 323 from dual UNION ALL
select 406, 'INTERVIEW_SCHEDULED', TO_DATE('1/28/2023', 'MM/DD/YYYY'), user, 323 from dual UNION ALL
select 407, 'HIRED', TO_DATE('2/6/2023', 'MM/DD/YYYY'), user, 323 from dual UNION ALL
select 408, 'APPLIED', TO_DATE('2/1/2023', 'MM/DD/YYYY'), 'Sarah Kim', 324 from dual UNION ALL
select 409, 'INTERVIEW_SCHEDULED', TO_DATE('2/10/2023', 'MM/DD/YYYY'), user, 324 from dual UNION ALL
select 410, 'APPLIED', TO_DATE('1/1/2023', 'MM/DD/YYYY'), 'Jane Doe', 325 from dual UNION ALL
select 411, 'INTERVIEW_SCHEDULED', TO_DATE('1/9/2023', 'MM/DD/YYYY'), user, 325 from dual UNION ALL
select 412, 'APPLIED', TO_DATE('1/24/2023', 'MM/DD/YYYY'), 'Sarah Kim', 326 from dual UNION ALL
select 413, 'APPLIED', TO_DATE('12/30/2022', 'MM/DD/YYYY'), 'Jane Doe', 328 from dual UNION ALL
select 414, 'APPLIED', TO_DATE('02/21/2023', 'MM/DD/YYYY'), 'David Lee', 329 from dual UNION ALL
select 415, 'APPLIED', TO_DATE('02/09/2023', 'MM/DD/YYYY'), 'Emily Wang', 330 from dual UNION ALL
select 416, 'APPLIED', TO_DATE('11/11/2022', 'MM/DD/YYYY'), 'John Doe', 331 from dual UNION ALL
select 417, 'INTERVIEW_SCHEDULED', TO_DATE('01/10/2023', 'MM/DD/YYYY'), user, 331 from dual UNION ALL
select 418, 'APPLIED', TO_DATE('12/17/2022', 'MM/DD/YYYY'), 'Sarah Kim', 327 from dual UNION ALL
select 419, 'INTERVIEW_SCHEDULED', TO_DATE('01/12/2023', 'MM/DD/YYYY'), user, 327 from dual UNION ALL
select 420, 'HIRED', TO_DATE('02/22/2023', 'MM/DD/YYYY'), user, 327 from dual UNION ALL
select 421, 'APPLIED', TO_DATE('08/09/2022', 'MM/DD/YYYY'), 'Emily Wang', 332 from dual UNION ALL
select 422, 'INTERVIEW_SCHEDULED', TO_DATE('08/12/2022', 'MM/DD/YYYY'), user, 332 from dual UNION ALL
select 423, 'HIRED', TO_DATE('02/12/2023', 'MM/DD/YYYY'), user, 332 from dual;

-------- Inserting data into the table Job Post Skill ------------------

INSERT INTO JOB_POST_SKILL(JobPostSkill_ID, Skillset_ID)
select 101, 101 from dual UNION ALL
select 101, 104 from dual UNION ALL
select 101, 105 from dual UNION ALL
select 102, 102 from dual UNION ALL
select 102, 103 from dual UNION ALL
select 102, 107 from dual UNION ALL
select 103, 105 from dual UNION ALL
select 103, 104 from dual UNION ALL
select 103, 108 from dual UNION ALL
select 104, 110 from dual UNION ALL
select 104, 111 from dual UNION ALL
select 104, 103 from dual UNION ALL
select 105, 102 from dual UNION ALL
select 105, 103 from dual UNION ALL
select 106, 109 from dual UNION ALL
select 106, 103 from dual UNION ALL
select 106, 102 from dual UNION ALL
select 107, 110 from dual UNION ALL
select 107, 102 from dual UNION ALL
select 108, 110 from dual UNION ALL
select 108, 102 from dual UNION ALL
select 108, 103 from dual;

-------- Inserting data into the table User skill ------------------

INSERT INTO User_Skill(User_ID, Skillset_ID)
select 101, 101 from dual UNION ALL
select 101, 104 from dual UNION ALL
select 101, 105 from dual UNION ALL
select 102, 101 from dual UNION ALL
select 102, 104 from dual UNION ALL
select 102, 105 from dual UNION ALL
select 102, 102 from dual UNION ALL
select 102, 103 from dual UNION ALL
select 102, 107 from dual UNION ALL
select 104, 109 from dual UNION ALL
select 104, 103 from dual UNION ALL
select 104, 102 from dual UNION ALL
select 105, 105 from dual UNION ALL
select 105, 102 from dual UNION ALL
select 105, 103 from dual UNION ALL
select 105, 110 from dual UNION ALL
select 105, 111 from dual UNION ALL
select 106, 109 from dual UNION ALL
select 106, 103 from dual UNION ALL
select 106, 103 from dual UNION ALL
select 106, 101 from dual UNION ALL
select 106, 104 from dual;

-------- Inserting data into the table User Education ------------------

INSERT INTO USER_EDUCATION (Users_ID, DEGREE_ID, START_DATE, END_DATE)
select 101, 104, TO_DATE('09/4/2020', 'MM/DD/YYYY'), TO_DATE('5/4/2024', 'MM/DD/YYYY') from dual UNION ALL
select 101, 107, TO_DATE('08/20/2024', 'MM/DD/YYYY'), TO_DATE('6/4/2026', 'MM/DD/YYYY')from dual UNION ALL
select 102, 104, TO_DATE('09/20/2020', 'MM/DD/YYYY'), TO_DATE('4/30/2024', 'MM/DD/YYYY')from dual UNION ALL
select 102, 103, TO_DATE('08/13/2024', 'MM/DD/YYYY'), TO_DATE('5/22/2026', 'MM/DD/YYYY')from dual UNION ALL
select 104, 102, TO_DATE('09/17/2020', 'MM/DD/YYYY'), TO_DATE('4/20/2024', 'MM/DD/YYYY')from dual UNION ALL
select 105, 104, TO_DATE('09/23/2020', 'MM/DD/YYYY'), TO_DATE('5/17/2024', 'MM/DD/YYYY')from dual UNION ALL
select 105, 107, TO_DATE('08/29/2024', 'MM/DD/YYYY'), TO_DATE('5/15/2026', 'MM/DD/YYYY')from dual UNION ALL
select 106, 104, TO_DATE('09/6/2020', 'MM/DD/YYYY'), TO_DATE('4/29/2024', 'MM/DD/YYYY')from dual UNION ALL
select 106, 101, TO_DATE('08/4/2024', 'MM/DD/YYYY'), TO_DATE('5/17/2026', 'MM/DD/YYYY')from dual;

-------- Inserting data into the table Job Education ------------------

INSERT INTO JOB_EDUCATION_REQ (JobPost_ID, Degree_ID)
select 101, 104 from dual UNION ALL
select 101, 105 from dual UNION ALL
select 102, 102 from dual UNION ALL
select 102, 103 from dual UNION ALL
select 102, 101 from dual UNION ALL
select 103, 101 from dual UNION ALL
select 103, 104 from dual UNION ALL
select 103, 105 from dual UNION ALL
select 103, 106 from dual UNION ALL
select 104, 101 from dual UNION ALL
select 104, 103 from dual UNION ALL
select 104, 102 from dual UNION ALL
select 105, 104 from dual UNION ALL
select 105, 105 from dual UNION ALL
select 105, 107 from dual UNION ALL
select 106, 102 from dual UNION ALL
select 106, 103 from dual UNION ALL
select 107, 101 from dual UNION ALL
select 107, 106 from dual UNION ALL
select 108, 101 from dual UNION ALL
select 108, 106 from dual;


commit;

-------------- Creating Views -----------------

------ 1. Acceptance rate for each company based on the number of people applied and hired ----
CREATE OR REPLACE VIEW ACCEPTANCE_RATES AS
SELECT      C.COMPANY_NAME, COUNT(CASE WHEN A.CURRENT_STATUS = 'HIRED' THEN 1 END) AS ACCEPTED_COUNT, COUNT(*) AS TOTAL_COUNT,
            ROUND((COUNT(CASE WHEN A.CURRENT_STATUS = 'HIRED' THEN 1 END) / COUNT(*)) * 100, 2) AS ACCEPTANCE_RATE
FROM        COMPANY C
JOIN        JOBPOST J ON C.COMPANY_ID = J.JOB_COMPANY_ID
JOIN        APPLICATIONS A ON J.JOBPOST_ID = A.JOB_POST_ID
GROUP BY    C.COMPANY_NAME;

------ 2. Number of job applications submitted by each user  ------
CREATE OR REPLACE VIEW USER_APPLICATION AS
SELECT      U.USER_ID, U.FIRST_NAME, U.LAST_NAME, COUNT(A.APPLICATION_ID) AS NUMBER_OF_APPLICATIONS
FROM        USERS U
JOIN        APPLICATIONS A ON U.USER_ID = A.USER_ID
GROUP BY    U.USER_ID, U.FIRST_NAME, U.LAST_NAME
ORDER BY    COUNT(A.APPLICATION_ID) DESC;

------- 3. The acceptance rate of people who got hired ----------
CREATE OR REPLACE VIEW JOBSEEKER_ANALYSIS AS
SELECT      U.USER_ID, U.FIRST_NAME, COUNT(CASE WHEN A.CURRENT_STATUS = 'HIRED' THEN 1 END) AS ACCEPTED_COUNT, COUNT(*) AS TOTAL_COUNT,
            ROUND((COUNT(CASE WHEN A.CURRENT_STATUS = 'HIRED' THEN 1 END) / COUNT(*)) * 100, 2) AS ACCEPTANCE_RATE
FROM        USERS U
JOIN        APPLICATIONS A ON U.USER_ID = A.USER_ID
GROUP BY    U.USER_ID, U.FIRST_NAME;


-------- 4. Top skills that most job posts require --------------
CREATE OR REPLACE VIEW TOP_SKILLS AS
SELECT      S.SKILL_NAME, COUNT(J.JOBPOSTSKILL_ID) AS MOST_WANTED_SKILL
FROM        SKILLSET S
JOIN        JOB_POST_SKILL J ON S.SKILLSET_ID = J.SKILLSET_ID
GROUP BY    S.SKILL_NAME
ORDER BY    COUNT(J.JOBPOSTSKILL_ID) DESC;


-------- 5. tracks the number of applications received for each job listing according to the job description ---------
CREATE OR REPLACE VIEW JOBPOST_ANALYSIS AS
SELECT                  J.JOB_TITLE, C.COMPANY_NAME, COUNT(A.APPLICATION_ID) AS NUMBER_OF_APPLICATIONS_RECEIVED, J.JOB_DESCRIPTION
FROM                    JOBPOST J
JOIN APPLICATIONS A ON  J.JOBPOST_ID = A.JOB_POST_ID
JOIN COMPANY C ON       C.COMPANY_ID = J.JOB_COMPANY_ID
GROUP BY                J.JOB_TITLE, C.COMPANY_NAME, J.JOB_DESCRIPTION
ORDER BY                COUNT(J.JOB_TITLE) DESC;

--------- 6. The report includes information on the number of job postings for each salary range,as well as the most listed job titles and industries for each salary range  -------
CREATE OR REPLACE VIEW SALARYBASED_JOB AS
SELECT
CASE
WHEN SALARY >= 0 AND SALARY <= 50000 THEN '0-50000'
WHEN SALARY > 50000 AND SALARY <= 100000 THEN '50001-100000'
WHEN SALARY > 100000 AND SALARY <= 150000 THEN '100001-150000'
ELSE 'Above 150000'
END AS SALARY_RANGE,
COUNT(*) AS NUMBER_OF_JOB_POSTINGS,
MAX(JOB_TITLE) AS MOST_LISTED_JOB_TITLE,
MAX(INDUSTY_TYPE) AS MOST_LISTED_INDUSTRY
FROM JOBPOST
JOIN COMPANY ON JOBPOST.JOB_COMPANY_ID = COMPANY.COMPANY_ID
GROUP BY
CASE
WHEN SALARY >= 0 AND SALARY <= 50000 THEN '0-50000'
WHEN SALARY > 50000 AND SALARY <= 100000 THEN '50001-100000'
WHEN SALARY > 100000 AND SALARY <= 150000 THEN '100001-150000'
ELSE 'Above 150000'
END;

--------- 7. Keeps a track on the application status for all the applied job and when the application status changes -------
CREATE OR REPLACE VIEW APPLICATION_STATUS AS
SELECT                          U.USER_ID, A.APPLICATION_ID, U.FIRST_NAME, U.LAST_NAME, JP.JOB_TITLE, C.COMPANY_NAME, JP.SALARY,
                                A.CURRENT_STATUS, A.APPLICATION_DATE, AT.STATUS, AT.CHANGED_ON, AT.MODIFIED_BY
FROM                            USERS U
JOIN APPLICATIONS A ON          U.USER_ID = A.USER_ID
JOIN JOBPOST JP ON              A.JOB_POST_ID = JP.JOBPOST_ID
JOIN COMPANY C ON               JP.JOB_COMPANY_ID = C.COMPANY_ID
JOIN APPLICATION_TRACKING AT ON A.APPLICATION_ID = AT.APPLICATION_ID
ORDER BY                        U.USER_ID, A.APPLICATION_ID, AT.CHANGED_ON;

--------- 8. Time taken by a company to hire a jobseeker ---------
CREATE OR REPLACE VIEW DECISISON_TIME as 
SELECT APPLICATION_ID, CHANGED_ON AS APPLIED_DATE, HIRED_DATE, HIRED_DATE - CHANGED_ON AS TIME_TAKEN_TO_HIRED
FROM (
  SELECT 
    APPLICATION_ID, 
    CHANGED_ON,
    (
      SELECT CHANGED_ON 
      FROM APPLICATION_TRACKING 
      WHERE APPLICATION_ID = a.APPLICATION_ID AND STATUS = 'HIRED'
    ) AS HIRED_DATE
  FROM APPLICATION_TRACKING a 
  WHERE STATUS = 'APPLIED'
)
WHERE HIRED_DATE IS NOT NULL;


--------- 9. Top jobs that are trending based on no.of applications made --------

CREATE OR REPLACE VIEW TRENDING_JOBS AS
SELECT                  J.JOB_TITLE, COUNT(A.APPLICATION_ID) AS NUM_APPLICATIONS
FROM                    JOBPOST J
JOIN APPLICATIONS A ON  J.JOBPOST_ID = A.JOB_POST_ID
GROUP BY                J.JOB_TITLE
ORDER BY                NUM_APPLICATIONS DESC
FETCH FIRST 3 ROWS ONLY;


--------- 10. Tracks the number of candidates each recruiter has sourced and those hired. 
----------The report includes information on the total number of candidates sourced, the number of candidates 
--------- that were hired, and the percentage of candidates that were hired   ----
CREATE OR REPLACE VIEW RECRUITER_ANALYSIS AS
SELECT      MODIFIED_BY AS RECRUITER, COUNT(APPLICATION_ID) AS TOTAL_CANDIDATES_SOURCED,
            SUM(CASE WHEN STATUS = 'HIRED' THEN 1 ELSE 0 END) AS HIRED_CANDIDATES,
            CONCAT(ROUND( SUM(CASE WHEN STATUS = 'HIRED' THEN 1 ELSE 0 END) / COUNT(APPLICATION_ID) * 100,2),'%') AS HIRED_PERCENTAGE
FROM        APPLICATION_TRACKING
WHERE MODIFIED_BY NOT IN (SELECT FIRST_NAME||' '||LAST_NAME FROM USERS WHERE ROLE_TYPE = 'JOBSEEKER')
GROUP BY    MODIFIED_BY;
