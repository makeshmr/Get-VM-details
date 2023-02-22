# Get-VM-details using PowerCLI

Often when new VMs are deployed to keep the track of them we need to fetch some details such as the UUID of the VM, the host, Cluster, Datacenter, and VCenter where the VM is deployed.

This is a PowerShell function called **`Get-VM-details`** that takes an array of VM names as input which we needed and returns various details about each VM, such as its UUID, guest operating system, hostname, cluster name, and data center.

```jsx
Function Get-VM-details {
          Param (
                     [Parameter(Mandatory = $True)]
                     [Array]$VMList
                  )
                 foreach ($VM in $VMList){

             Get-VM -Name $VM | Select Name,
 @{N ='UUID';E={$_.ExtensionData.Config.Uuid}},
 @{N ='GuestOS';E={$_.ExtensionData.Guest.GuestFullName}},
 @{N ='HostName';E={$_.VMHost}},
 @{N ='Cluster';E={$_.VMHost.Parent}},
 @{N ='DataCenter'; E={Get-DataCenter}}
              }
             }
```

Here is a brief explanation of what each line does:
1. **`Param`**: Defines the function parameter(s).
2. **`$VMList`**: An array parameter that is marked as mandatory, which means the user must provide a value for it when calling the function.
3. **`foreach ($VM in $VMList)`**: Loop iterates over each VM name in the **`$VMList`** array.
4. **`Get-VM -Name $VM`**: This cmdlet retrieves the virtual machine with the given name.
5. **`Select`**: This cmdlet selects specific properties of the virtual machine object to display in the output.
6. **`@{N='UUID';E={$_.ExtensionData.Config.Uuid}}`**: This is a calculated property that returns the UUID of the virtual machine.
7. **`@{N='GuestOS';E={$_.ExtensionData.Guest.GuestFullName}}`**: This is a calculated property that returns the guest operating system of the virtual machine.
8. **`@{N='HostName';E={$_.VMHost}}`**: This is a calculated property that returns the hostname of the virtual machine.
9. **`@{N='Cluster';E={$_.VMHost.Parent}}`**: This is a calculated property that returns the cluster name of the virtual machine.
10. **`@{N='DataCenter';E={Get-DataCenter}}`**: This is a calculated property that returns the data center of the virtual machine

```jsx
Connect-VIServer -Server 100.64.**.**  -User "username" -Password "Password"
```
This command will connect to the vCenter Server at "100.64.**.**" using the username "username" and password "Password". You can replace these values with the appropriate information for your environment.

We will define a PowerShell array consisting of VMs for which we needed to fetch details. Here we defined  **`$myArray`**  as the array consisting of the list of VM names.
```jsx
$myArray = @('test1','AIR_VSPC_BKP001','Spectrum-2','SPECTRUM-01')
```

**`Import-Module`**command is attempting to import the **`Get-VM-details.ps1`** PowerShell script located in **`D:\PowerCLI\`** directory as a module in current session.

```jsx
Import-Module D:\PowerCLI\Get-VM-details.ps1
```
**`Get-VM-details`**is a PowerCLI cmdlet imported that retrieves virtual machines and the information required from the vCenter Servers. Here is how it works.

```jsx
Get-VM-details $myArray | Export-Excel D:\Details_fetching\VM_details.xlsx
```

**`Get-VM-details`** to retrieve the details of virtual machines specified in the **`$myArray`** array. It then exports the details of the virtual machines to an Excel file named **`VM_details.xlsx`**
 in the **`D:\Details_fetching\`**directory.

We have exported the details to an Excel file named **`VM_details.xlsx`**   in the **`D:\Details_fetching\`** directory.

| Name | UUID | GuestOS | HostName | Cluster | DataCenter |
| --- | --- | --- | --- | --- | --- |
| test1 | 42179f89-ccd9-2efb-0741-d0e1291414d2 | Microsoft Windows Server 2016 or later (64-bit) | vpemgmth08 | ARCON-CLUSTER | New_MGMT-Airoli |
| AIR_VSPC_BKP001 | 42172368-014f-65c7-c21c-da99017f9a07 | Microsoft Windows Server 2016 or later (64-bit) | 100.64.61.15 | ARCON-CLUSTER | New_MGMT-Airoli |
| Spectrum-2 | 4217c50b-b8c4-9bbf-babb-60ae55fe3fb8 | Microsoft Windows Server 2012 (64-bit) | vpemgmth06 | MGMTPOD-New | New_MGMT-Airoli |
| SPECTRUM-01 | 42177f4d-6b95-05dd-5378-59ba727bdab0 | Microsoft Windows Server 2012 (64-bit) | vpemgmth05 | MGMTPOD-New | New_MGMT-Airoli |
