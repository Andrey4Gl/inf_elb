# Inf ELB
Terraform script for creation simple infrastructure for ELB and ASG (with amzon linux servers) in AWS.
Created by:
   - Server will be launched in the default subnets
   - Launch configuration for Amazon Linux (kernel 5.10) with nginx
   - ELB
   - Autoscaling group

## Parametrs define in variables.tf file:

 1. Region - region (by default "eu-central-1")
 2. Project owner - pr_owner (by default = "Ownrer_of_project")
 3. Name of key file - key_name (by default "ga-frank")
 4. File name of user data source - usr_dt_src_file (by default user_data.sh)
 5. List of allow ports - allow_ports (by default ["80", "443", "22"])
 6. Max size for ASG - maxsize (by default 2)
 7. Min size for ASG - minsize (by default 2)
 8. ELB capacity - elbcap (by default 2)

## Outputs:

 - Url wit dns-name of ELB
 - Common parameters (user_id, region name, region description etc)
 - Latest ami version information
