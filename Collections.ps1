#credit: https://www.petervanderwoude.nl/post/divide-a-collection-into-multiple-smaller-collections-in-configmgr-2012-via-powershell/

$CollectionName = "Collection Exact Name"

#$Devices = Get-CMDevice -CollectionName $CollectionName
$Devices = 80
$NumberOfDevices = $Devices.Count
$NumberOfDevicesPerCollection = "10"
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