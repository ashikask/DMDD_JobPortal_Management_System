
-- System admin creation

create user sys_admin identified by DAMG6210teammates;

-- Grant privileges to system admin and give unlimited quota
grant connect, resource to sys_admin;

alter user sys_admin quota unlimited on data;
grant create view to sys_admin;

-- creates a recruiter 
create user recruiter1 identified by Recruiters1Right1 ;

-- granting privileges that the recruiter 
grant connect to recruiter1;
grant select,delete,update,insert on sys_admin.jobpost to recruiter1;
grant select,update on sys_admin.applications to recruiter1;
grant select on sys_admin.Acceptance_Rates to recruiter1;
grant select on sys_admin.Recruiter_Analysis to recruiter1;
grant select on sys_admin.jobseeker_profile to recruiter1;
grant select on sys_admin.jobpost_analysis to recruiter1;
grant select on sys_admin.application_status to recruiter1;