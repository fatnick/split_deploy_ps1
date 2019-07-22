<# Breaks a $CollectionName up into chunks by $Count with number of devices named "$CollectionName-Group1", then creates a deployment of $TaskSequenceID starting at $StartDate 
and $StartTime with $DelayMinute intervals.
$DeploymentScript = Start-CMTaskSequenceDeployment -CollectionName $CollectionName -TaskSequencePackageId $TaskSequenceID -DeployPurpose Required -DeploymentAvailableDay $AvailableDateFormat -DeploymentAvailableTime $AvailableTime -Schedule $Schedule -RerunBehavior RerunIfFailedPreviousAttempt -AllowUsersRunIndependently $False -SendWakeupPacket $true -DeploymentExpireTime $StartDate.adddays(1) -SystemRestart $true -SoftwareInstallation $true
This is the full script that contains all the parts 1) SplitCollections + 2) ScheduleDeployment + 3) CreateDeployment, but right now I have left out SpliCollection step, and need to finalise the for loop to execute on each collection.
#>

#Declare variables
$CollectionName = "Collection Exact Name"
$TaskSequenceID = "DC10000C"  #as seen by you SCCM server
$StartDate = "30.12.2019" #formatted for your locale for wmi tinme format
$StartTime = "17:00"          #formatted for your time
$DelayMinutes = "60"
# Create deployment for the task sequence (available 01.09.2013 08:00, enforced 25.12.2015 17:00, not overriding maintenance window)
$AvailableDate = $StartDate
$AvailableTime = "08:00"
$EnforcementDate = $StartDate
$EnforcementTime = "17:01" #must be at least 1 min after available time
$ExecuteDeploymentScript = "Start-CMTaskSequenceDeployment -CollectionName $CollectionName -TaskSequencePackageId $TaskSequenceID -DeployPurpose Required -DeploymentAvailableDay $AvailableDateFormat -DeploymentAvailableTime $AvailableTime -Schedule $Schedule -RerunBehavior RerunIfFailedPreviousAttempt -AllowUsersRunIndependently $False -SendWakeupPacket $true -DeploymentExpireTime $StartDate.adddays(2) -SystemRestart $true -SoftwareInstallation $true"

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

# Create deployment
$Schedule = New-CMSchedule -Nonrecurring -Start $DeployEnforcementDateTime
Try {
    $Deployment = Start-CMTaskSequenceDeployment -CollectionName $Collection -TaskSequencePackageId $TaskSequenceID -DeployPurpose Required -DeploymentAvailableDay $AvailableDateFormat -DeploymentAvailableTime $AvailableTime -Schedule $Schedule -RerunBehavior RerunIfFailedPreviousAttempt -AllowUsersRunIndependently $True
    Write-Host "Deployment created"
} 
Catch {
	Write-Host "Error - Exception caught in creating deployment : $error[0]"
    Exit
} 
# Create deployment for the task sequence (available 01.09.2013 08:00, enforced 25.12.2015 17:00, not overriding maintenance window)

$StartDate = (get-date -Hour 20 -Minute 30 -Second 0)
$Schedule = New-CMSchedule -Start $StartDate.adddays(0) -Nonrecurring

#Execute the 1st deployment.
$DeploymentScript
