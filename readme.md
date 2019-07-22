This is a partly a Powershell learning project intended to automate a common task for Smyself and other CCM admins deploying to many devices, but with variable demands and complex network environments. 
Depending on schedules, bandwidth availability, project deadlines, and WAN/LAN link speeds and the capabilities of the local Distribution Point, SCCM admins usually have to manually create deployments by varying size, schedules/intervals, limit on concurrent device and other concerns. If you need this script then you will already know your variables roughly from experience: how many devices can you do at once, every 1.5 hrs, starting at $DateTime etc.

The main Script will execute all the steps, but ive broken it up into steps as I'm learning powershell :-)

1. Break a collection up into parts by n device count.
2. Create a schedule  based on start time and defined interval
3. Deploy the task seqquence to each collection, based on the schedule.

---------------------- Snippet--------

<# Breaks a $CollectionName up into chunks by $Count with number of devices named "$CollectionName-Group1", then creates a deployment of $TaskSequenceID starting at $StartDate and $StartTime with $DelayMinute intervals.

Example of deploymnet script used:

$DeploymentScript = Start-CMTaskSequenceDeployment -CollectionName $CollectionName -TaskSequencePackageId $TaskSequenceID -DeployPurpose Required -DeploymentAvailableDay $AvailableDateFormat -DeploymentAvailableTime $AvailableTime -Schedule $Schedule -RerunBehavior RerunIfFailedPreviousAttempt -AllowUsersRunIndependently $False -SendWakeupPacket $true -DeploymentExpireTime $StartDate.adddays(1) -SystemRestart $true -SoftwareInstallation $true
#>

#Declare variables

$CollectionName = "Collection Exact Name"
$TaskSequenceID = "DC10000C"  #as seen by you SCCM server
$StartDate = "30.12.2019" #formatted for your locale for wmi tinme format
$StartTime = "17:00"          #formatted for your time
$DelayMinutes = "60"

