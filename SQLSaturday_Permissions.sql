CREATE LOGIN cherylHuber WITH PASSWORD = 'zzyzx2017',DEFAULT_DATABASE=SQLSaturday;
CREATE LOGIN Mushkablat WITH PASSWORD = 'abcde2017',DEFAULT_DATABASE=SQLSaturday;
CREATE LOGIN visitor WITH PASSWORD = 'abcde2017',DEFAULT_DATABASE=SQLSaturday;
CREATE USER cherylAnn FOR LOGIN cherylHuber;
CREATE USER virginia FOR LOGIN Mushkablat;
CREATE USER visitorUser FOR LOGIN visitor;
ALTER ROLE db_owner ADD MEMBER cherylAnn;
ALTER ROLE db_owner ADD MEMBER virginia;
ALTER ROLE db_datareader ADD MEMBER visitorUser;
