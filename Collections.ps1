#< Splits a large collection up into smaller into $n devices per collection.

$CollectionName = "Collection Exact Name"

#$Devices = Get-CMDevice -CollectionName $CollectionName
$Devices = 80          #Used for testing. Dont have sccm at home, so cant query/test.
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
