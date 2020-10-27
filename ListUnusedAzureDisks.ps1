<#  
.SYNOPSIS   
     Report unused disks space for Azure VMs
.DESCRIPTION  
<#  
.SYNOPSIS   
     Report Azure VMs unused disks space
.DESCRIPTION  
Azure automation runbook that reports the unused disk space by the Azure VMs. You can use azure automation schedule feature to execute this runbook on regular basis to keep track of unused disks residing on azure storage.

Prereq:     
    1. Automation PS Credential Asset with userid and password to Azure subscription
 

.PARAMETER azureSubscriptionName
     String: Azure Subscription Name

.PARAMETER azureOrgIdCredName 
    String - Name of PS Credential asset
    Example: AzureOrgIDCredential


.EXAMPLE  
  Get-UnusedDisksDetails "Subscription Name" "PSCredential Asset Name"
.NOTES  
    Author: Razi Rais  
    Link: http://www.razibinrais.com/blog/2015/04/11/blog.htm
    Last Updated: 4/11/2015   
#>

workflow Get-UnusedDisksDetails
{
    param ( [string]$azureSubscriptionName ,
            [string]$azureOrgIdCredName 
          ) 


$azureOrgIdCredential = Get-AutomationPSCredential -Name  $azureOrgIdCredName 
Write-Verbose ("[Information] Using account | " + $azureOrgIdCredential.UserName +" |")
$discardOutput = Add-AzureAccount -Credential $azureOrgIdCredential 
$discardOutput = Select-AzureSubscription -SubscriptionName $azureSubscriptionName 
Write-Verbose "[Success] Azure subscription selected | $azureSubscriptionName |"  

 
 $disks = inlinescript { 
     $totalDisksSizeGB = 0
     $totalDisksCount = 0;
     $list = "DiskName,DiskSpace(GB),OS,AbsoulteUri" + "`n"
     
     Get-AzureDisk | where { !$_.AttachedTo } | % { $totalDisksSizeGB = $totalDisksSizeGB + $_.DiskSizeInGB ; $totalDisksCount++; 
        $list +=  $_.DiskName + "," + $_.DiskSizeInGB + "," + $_.OS + "," + $_.MediaLink.AbsoluteUri + "`n"; 
        }
     
     
     if ($totalDisksSizeGB -igt 1000) { $list +="Total unused disks size: " + $totalDisksSizeGB / 1000 + "(TB)" + "`n"  }
     else { $list +="Total unused disks size: " + $totalDisksSizeGB + "(GB)" + "`n" }
     $list += "Total number of unused disks: $totalDisksCount" + "`n"
     
      return $list
 }
 
$alldisks = $disks.Split("`n")
    Write-Output $alldisks[$alldisks.Count-2] #Total number of unused disks
    Write-Output $alldisks[$alldisks.Count-3] #Total unused disks size
    $csvData = ""
    for($count =0; $count -le $alldisks.Count -4 ; $count++) 
    {
        $csvData += $alldisks[$count] + "`n"
    } 
   Write-Output $csvData
 
   return $disks;
  
}