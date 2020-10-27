Report Azure VMs unused disks space
===================================

            
**Description**

If you’re using Azure VMs in your organization one of the common governance challenge is to identify the unused disk space that was just lying around in azure storage unused and cost company money unnecessarily. This usually happens
 when vms are deleted but vhds are kept so to make sure that data is not lost or just disks are marked for deletion but then no-one actually remembers/take care of that.


Whatever the reason is I’ve a simple solution for it: use this azure automation runbook that reports the unused disk space You can also use azure automation schedule feature to execute this runbook on regular basis and keep track of unused disks residing
 on the storage. 

More details can be found on blog post: **www.razibinrais.com/blog/2015/04/11/blog.htm**

** **




        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
