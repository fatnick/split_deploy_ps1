This is a partly a Powershell learning project intended to automate a common task for myself and other SCCM admins deploying softwares and sequences to many devices, but with variable demands places upon them in complex network environments. 

As a SCCM admin you will be familiar with variables at play: Deployment size, scheduling, bandwidth availability, project deadlines, and WAN/LAN link speeds, capabilities of the local SCCM Distribution Point. SCCM admins usually have to manually create these deployments by varying size, schedules/intervals, limit on concurrent device and other concerns. If you need this script then you will already know   roughly the variables I am speaking about from experience, ie: how many devices you can you do at once, every 1.5 hrs, starting at $DateTime etc. Just pluck them into the script and go to the pub already! Its a friday for god sakes (deployment times are always fridays or weekend :-/

The main Script will execute all the steps, but ive broken it up into steps as I'm learning powershell :-)

1. Break a collection up into parts by n device count.
2. Create a schedule  based on start time and defined interval
3. Deploy the task seqquence to each collection, based on the schedule, looping through

----------- Snip of main ------------

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

