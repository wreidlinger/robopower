```
Title:    robopower  
Mission:  robocopy via powershell  
Author:   Wolfgang Reidlinger  
Version:  v1.1
```

# Documentation:
- Microsoft robocopy: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy

# Function:
Uses powershell to make the usage of robocopy even more pleasant. Define source/destination in txt files and script location in a variable and fire up. Makes backup task very simple and easy.

# Structure:
* define sources: in ```input_sources.txt``` in this format ```C:\Users\Testuser\Nextcloud\WORK``` (multiple sources possible, 1 source/path per line)
* define destination: in ```input_destination.txt``` in this format ```C:\Users\Testuser\Nextcloud\WORK``` or ```\\10.0.0.10\backup\customers\evilcorp```(currently only one destionation is possible)
* robocopy-logfile: unilog logfile is writte to the same source as the ps1 file
* robopower-logfile: logfile is writte to the same source as the ps1 file

# NEED to SET:
 1. if you want to use the .ps1 file as a windows task you have to set this via powershell:  
 ```Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser```
 2. define the location of the ```.ps1``` file in ```$script_location```
 3. ```$log_location_backup``` -> define location of the logfiles at the backup destination

# TODO
- check if \log directory is there, if not created!
- add function to support multiple destinations
