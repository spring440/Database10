USE SQLSaturday;  
GO  
BACKUP DATABASE SQLSaturday  
TO DISK = 'C:\SQLServerBackups\SQLSaturday.Bak'  
   WITH FORMAT,  
      MEDIANAME = 'Z_SQLServerBackups',  
      NAME = 'Full Backup of SQLSaturday';  
GO  