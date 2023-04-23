
-- Kill system session for all users
SET SERVEROUTPUT ON;


BEGIN
    FOR i IN (SELECT serial#, sid FROM v$session WHERE username = 'JOBSEEKER1') 
    LOOP
        DBMS_OUTPUT.PUT_LINE('----- Killing session: ' || i.serial# || ',' || i.sid||'-----');
        EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION ''' || i.sid || ',' || i.serial# || ''' IMMEDIATE';
    END LOOP;
END;
/
BEGIN
    FOR i IN (SELECT serial#, sid FROM v$session WHERE username = 'RECRUITER1') 
    LOOP
        DBMS_OUTPUT.PUT_LINE('----- Killing session: ' || i.serial# || ',' || i.sid||'-----');
        EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION ''' || i.sid || ',' || i.serial# || ''' IMMEDIATE';
    END LOOP;
END;
/
BEGIN
    FOR i IN (SELECT serial#, sid FROM v$session WHERE username = 'SYS_ADMIN') 
    LOOP
        DBMS_OUTPUT.PUT_LINE('----- Killing session: ' || i.serial# || ',' || i.sid||'-----');
        EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION ''' || i.sid || ',' || i.serial# || ''' IMMEDIATE';
    END LOOP;
END;
/

-- deleting all users
DECLARE
  v_user_exists VARCHAR(1) := 'Y';
BEGIN
  FOR i IN (
    SELECT USERNAME
    FROM DBA_USERS
    WHERE USERNAME IN ('RECRUITER1','JOBSEEKER1', 'SYS_ADMIN')
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('----- Dropping user ' || i.USERNAME||' -----');
    BEGIN
      SELECT 'Y'
      INTO v_user_exists
      FROM DBA_USERS
      WHERE USERNAME = i.USERNAME;

      EXECUTE IMMEDIATE 'DROP USER ' || i.USERNAME || ' CASCADE';
      DBMS_OUTPUT.PUT_LINE('----- User ' || i.USERNAME || ' dropped successfully'||' -----');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('----- User does not exist -----');
    END;
  END LOOP;
END;
/


-- creates a user sysyem admin who can create tables and insert data
create user sys_admin identified by DAMG6210teammates;

-- grant privileges to system admin and give unnlimited quota
grant connect, resource to sys_admin with admin option;
alter user sys_admin quota unlimited on data;
grant create view to sys_admin with admin option;
grant create procedure to sys_admin with admin option;
grant create table to sys_admin;
grant create any sequence to sys_admin;
grant DROP any TABLE, DROP any SEQUENCE, drop any procedure TO sys_admin;

---- Creating other users 
create user recruiter1 identified by Recruiters1Right1 ;
grant connect to recruiter1;

create user jobseeker1 identified by Users1Right1;
grant connect to jobseeker1;