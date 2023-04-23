set serveroutput on

-- running all procedure in job_seeker_package

EXEC sys_admin.job_seeker_package.apply_job('APPLIED',SYSDATE,102,105);
EXEC SYS_ADMIN.JOB_SEEKER_PACKAGE.check_job_application_status(p_user_phoneNumber => 1234567890);
EXEC SYS_ADMIN.JOB_SEEKER_PACKAGE.search_job_degree(p_user_phoneNumber => 1234567890);
EXEC SYS_ADMIN.JOB_SEEKER_PACKAGE.search_job_skill(p_user_phoneNumber => 1234567890);


-- All the Views jobseeker can view
select * from sys_admin.top_skills;
select * from sys_admin.trending_jobs;
select * from sys_admin.jobseeker_analysis;
select * from sys_admin.user_application;
select * from sys_admin.salarybased_job;