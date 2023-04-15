
set serveroutput on

-- running all the procedures in job_application_package
exec sys_admin.JOB_APPLICATION_PACKAGE.Update_Application_Status(325,'REJECTED');
EXEC sys_admin.JOB_APPLICATION_PACKAGE.APPLICATION_DETAILS('REJECTED', sysdate, 111,105);


-- running all the procedures in post_job_package
exec sys_admin.POST_JOB_PACKAGE.Update_Job_Post(105,'EXPIRED');
EXEC sys_admin.POST_JOB_PACKAGE.JOBPOST_DETAILS('Software Developer', sysdate, 'We are seeking a skilled software developer to join our team.', user, 50000, 'AVAILABLE', 101, 101, 102);


select * from sys_admin.Acceptance_Rates;
select * from sys_admin.Recruiter_Analysis;
select * from sys_admin.jobpost_analysis;
select * from sys_admin.application_status;
select * from sys_admin.location_wise_job_postings;