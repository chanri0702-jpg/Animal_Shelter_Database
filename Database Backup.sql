-- BACKUP SCRIPT FOR ANIMAL SHELTER DATABASE


BACKUP DATABASE AnimalShelterDB
TO DISK = 'C:\Databasebackups\AnimalShelterBD.bak'
WITH FORMAT,
     MEDIANAME = 'AnimalShelterBackup',
     NAME = 'Full Backup of AnimalShelterDB';

