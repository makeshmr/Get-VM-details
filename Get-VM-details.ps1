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