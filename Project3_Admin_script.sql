
-- System admin creation

create user sys_admin identified by DAMG6210teammates;

grant connect, resource to sys_admin;

alter user sys_admin quota unlimited on data;