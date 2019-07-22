#< Splits a large collection up into smaller into $n devices per collection.
 # this will be the first step out of 3.
 #>
 
$CollectionName = "Collection Exact Name"

#$Devices = Get-CMDevice -CollectionName $CollectionName        #Uncomment when connected to SCCM
$Devices = 80                                                   #Used for testing at home with no connection to SCCM.
$NumberOfDevices = $Devices.Count
$n = "10"
    [math]::ceiling($NumberOfDevices / $NummberOfCollections)


$NewCollectionName = "$CollectionName $i"
New-Item -Name $NewCollectionName `
    #-LimitingCollectionName $CollectionName

$NewDevices = Get-Random -InputObject $Devices `
    -Count $NumberOfDevicesPerCollection
foreach ($NewDevice in $NewDevices) {
    #Add-CMDeviceCollectionDirectMembershipRule `
        -CollectionName $NewCollectionName -Resource $NewDevice
}

$Devices = $Devices | Where-Object { $NewDevices -notcontains $_ }
 $NumberOfDevicesLeft = $Devices.Count
 $NummberOfCollectionsLeft = $NummberOfCollections-$i
 if ($NummberOfCollectionsLeft -gt 0) {
     $NumberOfDevicesPerCollection = `
        [math]::ceiling($NumberOfDevicesLeft / $NummberOfCollectionsLeft)
 }
