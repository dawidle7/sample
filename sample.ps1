function check_if_installed{
    if($args[1] -notcontains $args[0]){
        Write-Host ($args[0].FullName +" is not installed")
    }
}


if ($PSVersionTable.Platform) {
    Write-Host "This is not Windows, exiting" 
    break
}

#package manager is a given so we do not have to check for that, but posh needs to be 4 or more
if($PSVersionTable.PSVersion.Major -lt 4) {break}


Write-Host ("Running as "+($env:USERNAME))
#Requires -RunAsAdministrator
#we need to be able to run installers



$installed_packages=Get-Package |Select-Object Name
#package manager does not seem to be able to deliver a listing of the installed files, at least yet
Write-Host "Retrieved list of installeds"

$files=get-childitem -path \* -exclude Windows,'Program Files','Program Files (x86)',Users | get-childitem -recurse | Select-Object FullName
Write-Host "Retrieved list of files"

foreach($queried_file in $files){check_if_installed $queried_file [ref]$installed_packages}
