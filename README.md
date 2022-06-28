Title: robopower  
Mission: robocopy via powershell  
Author: Wolfgang Reidlinger  
Version: v1.0  

Documentation:
* robocopy https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy

Function:
Uses powershell to make the usage of robocopy even more pleasant. Define source/destination in txt files and script location in a variable and fire up. Makes backup task very simple and easy.

Structure:
* define sources: in "input_sources.txt" in this format C:\Users\Testuser\Nextcloud\WORK (multiple sources possible, 1 source/path per line)
* define destination: in "input_destination.txt" in this format C:\Users\Testuser\Nextcloud\WORK or \\10.0.0.10\backup\customers\evilcorp
* robocopy-logfile: unilog logfile is writte to the same source as the ps1 file
* robopower-logfile: logfile is writte to the same source as the ps1 file

NEED to SET:
 1. if you want to use the .ps1 file as a windows task you have to set this:  
 "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
 2. define the location of the .ps1 file in $script_location
