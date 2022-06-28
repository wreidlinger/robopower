<#
Title: robopower 
Mussion: robocopy via powershell
Author: Wolfgang Reidlinger
Version: v1.0
Documentation:
* robocopy https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy
Function:
Uses powershell to make the usage of robocopy even more pleasant. Define source/destination in txt files and script location in a variable and fire up.
Makes backup task very simple and easy.
Structure:
* define sources: in "input_sources.txt" in this format C:\Users\Testuser\Nextcloud\WORK (multiple sources possible, 1 source/path per line)
* define destination: in "input_destination.txt" in this format C:\Users\Testuser\Nextcloud\WORK or \\10.0.0.10\backup\customers\evilcorp
* robocopy-logfile: unilog logfile is writte to the same source as the ps1 file
* robopower-logfile: logfile is writte to the same source as the ps1 file
NEED to SET:
(1) if you want to use the .ps1 file as a windows task you have to set this:
"Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
(2) define the location of the .ps1 file in $script_location
#>

# get computername and write into variable
$hostname = $env:ComputerName
# define counter for unilog logfile name
$count = 0
# need to set the location of the .ps1 file | write script location into variable
$script_location = "D:\ADMIN\BACKUP\robopower-NAS"
# write logfile
"$(get-date -Format 'dd/MM/yyyy-HH:mm:ss') :: START robopower on $($hostname)" | Out-File "$($script_location)\robopower.log" -Append -Encoding ASCII


Write-Host `r`n
Write-Host "############################################################################"
Write-Host "# Thanks for running robopower v1.0                                        #"
Write-Host "# by Wolfgang Reidlinger, 2022                                             #"
Write-Host "############################################################################"
Write-Host `r`n
Write-Host "****************************************************************************"
Write-Host "* Source(s):                                                               *"
Write-Host "****************************************************************************"

# get sources from txt input file and write into array
$array_sources_input_file = Get-Content -Path @("$($script_location)\input_sources.txt")
foreach($sources in $array_sources_input_file)
{
    # print all sources (absolute path) on shell
    Write-Host $($sources)
    # write all sources (absolute path) into logfile
    "$(get-date -Format 'dd/MM/yyyy-HH:mm:ss') :: SOURCE: $($sources)" | Out-File "$($script_location)\robopower.log" -Append -Encoding ASCII
    # print sources root folder (no path) (for debugging)
    #$sources_root_folders = Split-Path $sources -Leaf
    #Write-Host "Sources root folders:" $sources_root_folders
}

# get destination from txt input file (only one destination possible)
$destination = Get-Content -Path "$($script_location)\input_destination.txt"
# print the destination
Write-Host `r`n
Write-Host "****************************************************************************"
Write-Host "* Destination:                                                             *"
Write-Host "****************************************************************************"
Write-Host $destination
# write destination into logfile
"$(get-date -Format 'dd/MM/yyyy-HH:mm:ss') :: DESTINATION: $($destination)" | Out-File "$($script_location)\robopower.log" -Append -Encoding ASCII

# run robocopy for every source folder
foreach($sources in $array_sources_input_file)
{
    # get source root folders, because robocopy do not copy this to destination
    # source: https://superuser.com/questions/379612/robocopy-does-not-copy-the-root-folder-and-its-time-stamp
    $sources_root_folders = Split-Path $sources -Leaf
    # get date and write into variable
    $timestamp = (Get-Date -Format "dd-MM-yyyy")
    # increase +1 in every loop and write to variable which is later used in the logfile name
    $count = $count+1
        
    # robocopy all sources to the destination
    Robocopy.exe "$sources" "$destination\$sources_root_folders" /MIR /XA:H /W:1 /MT:32 /DCOPY:T /Z /NP /unilog:"$($script_location)\robocopy-0$($count)-$($hostname)-$($timestamp).log"
    # write robocopy-logfile into robopower-logfile
    "$(get-date -Format 'dd/MM/yyyy-HH:mm:ss') :: LOGFILE: $($script_location)\robocopy-0$($count)-$($hostname)-$($timestamp).log" | Out-File "$($script_location)\robopower.log" -Append -Encoding ASCII
    # /MIR	Mirror a directory tree
    # /XA:H makes Robocopy ignore hidden files, usually these will be system files that we're not interested in.
    # /W:5 reduces the wait time between failures to 5 seconds instead of the 30 second default.
    # /MT:32 Creates multi-threaded copies with n threads. n must be an integer between 1 and 128. The default value for n is 8. For better performance, redirect your output using /log option.
    # /DCOPY:T :: COPY Directory Timestamps.
    # /z	Copies files in restartable mode. In restartable mode, should a file copy be interrupted, Robocopy can pick up where it left off rather than re-copying the entire file.
    # /NP	Specifies that the progress of the copying operation (the number of files or directories copied so far) will not be displayed.
    # /unilog:<logfile>	Writes the status output to the log file as Unicode text (overwrites the existing log file).
}

# write logfile
"$(get-date -Format 'dd/MM/yyyy-HH:mm:ss') :: END robopower on $($hostname)" | Out-File "$($script_location)\robopower.log" -Append -Encoding ASCII