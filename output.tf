#---------------------------------------------------------------------
# Scripts for ceation infrastructure with LBA and ASG (Amazon Servers)
# Output data
# TF (c) AG 2021
# Outputs parameters:
#   - Common parameters (user_id, region name, region description etc)
#   - Latest ami version information
#   - url wit dns-name of ELB
#----------------------------------------------------------------------

# Common parameters

output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "data_aws_region_name" {
  value = data.aws_region.current.name
}

output "data_aws_region_description" {
  value = data.aws_region.current.description
}

output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names
}

# Latest ami version
output "latest_ami_amazon" {
  value = data.aws_ami.latest_amazon_linux.name
}

output "latest_ami_amazon_id" {
  value = data.aws_ami.latest_amazon_linux.id
}

# url wit dns-name of ELB

output "web_ladbalancer_url" {
  value = aws_elb.web_elb_ter.dns_name
}
