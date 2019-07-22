<# Ttemplate for how to create a New-CMSchedule powershell object, and does some formatting for wmi\locale and checks logic.
 As an example will create a create deployment for a SCCM task sequence (available 01.09.2013 08:00, enforced 25.12.2015 17:00, not overriding maintenance window).
 Deployment script can be declared as a variable, and should work simliarly for apps, programs, update packages as it does here for task sequence:
 # Example: $Deployment = Start-CMTaskSequenceDeployment -CollectionName $Collection -TaskSequencePackageId $TaskSequenceID -DeployPurpose Required -DeploymentAvailableDay $AvailableDateFormat -DeploymentAvailableTime $AvailableTime -Schedule $Schedule -RerunBehavior RerunIfFailedPreviousAttempt -AllowUsersRunIndependently $True
 #>

#Declare variables DD.MM.YYYY
$AvailableDate = "20.07.2019"
$AvailableTime = "08:00"
$EnforcementDate = "20.07.2019"
$EnforcementTime = "09:00"
$Deplyment = "Your deploy script here "

# Format available date
Write-Host "AvailableDate  is $AvailableDate"
$AvailableDate = $AvailableDate.Split(".")
$AvailableDateFormat = $AvailableDate[2]+"/"+$AvailableDate[1]+"/"+$AvailableDate[0]
Write-Host "AvailableDate formated is $AvailableDateFormat"
# Check available date
If ($AvailableDateFormat -as [DateTime]) {
    Write-Host "AvailableDate ok"
}
Else {
    Write-Host "Error - AvailableDate not ok"
	Exit
}

# Check available time
Write-Host "AvailableTime is $AvailableTime"
If ($AvailableTime -as [DateTime]) {
    Write-Host "AvailableTime ok"
}
Else {
    Write-Host "Error - AvailableTime not ok"
	Exit
}

# Format enforcement date
Write-Host "EnforcementDate is $EnforcementDate"
$EnforcementDate = $EnforcementDate.Split(".")
$EnforcementDateFormat = $EnforcementDate[2]+"/"+$EnforcementDate[1]+"/"+$EnforcementDate[0]
Write-Host "EnforcementDate formated is $EnforcementDateFormat"
# Check enforcement date
If ($EnforcementDateFormat -as [DateTime]) {
    Write-Host "EnforcementDate ok"
}
Else {
    Write-Host "Error - EnforcementDate not ok"
	Exit
}

# Check enforcement time
Write-Host "EnforcementTime is $EnforcementTime"
If ($EnforcementTime -as [DateTime]) {
    Write-Host "EnforcementTime ok"
}
Else {
    Write-Host "Error - EnforcementTime not ok"
	Exit
}

# Format Enforcement date/time for WMI (Schedule object)
$EnforcementTimeWMIformat = Get-Date $EnforcementTime -format t
$EnforcementDateTimeWMIformat = $EnforcementDate[1]+"/"+$EnforcementDate[0]+"/"+$EnforcementDate[2]+" "+$EnforcementTimeWMIformat
Write-Host "EnforcementDateTime formated for WMI (Schedule object) is $EnforcementDateTimeWMIformat"

# Check if availability is before enforcement
$AvailableDateTime = $AvailableDateFormat +" "+$AvailableTime
$EnforcementDateTime = $EnforcementDateFormat +" "+ $EnforcementTime
If ((Get-Date $AvailableDateTime) -lt (Get-Date $EnforcementDateTime)) {
    Write-Host "Availablity is set before Enforcement, schedule ok"
}
Else {
    Write-Host "Error - Enforcement set before availability"
	Exit
}

<# Create deployment. NOt doing this, as this is just the schedule step.

$Schedule = New-CMSchedule -Nonrecurring -Start $DeployEnforcementDateTime
Try {
    $Deployment = Start-CMTaskSequenceDeployment -CollectionName $Collection -TaskSequencePackageId $TaskSequenceID -DeployPurpose Required -DeploymentAvailableDay $AvailableDateFormat -DeploymentAvailableTime $AvailableTime -Schedule $Schedule -RerunBehavior RerunIfFailedPreviousAttempt -AllowUsersRunIndependently $True
    Write-Host "Deployment created"
} 
Catch {
	Write-Host "Error - Exception caught in creating deployment : $error[0]"
    Exit
} 
#>
