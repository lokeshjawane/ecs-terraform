
# Summary
This terraform module is to manage project creation on AWS platform which calculate the subnet address based on given VPC CIRD.

**NOTE** : This module required Terraform version 12

## Used Variables
|Variable|Description|
|-|-|
|vpc_name|(required) Name of the VP|
|vpc_cidr|(required) CIDR for the VPC network|
|external_subnets|(optional) List of hash, to create public subnets, if not specified then module will calculate subnets|
|internal_subnets|(optional) List of hash, to create private subnets, if not specified then module will calculate subnets|
|environment|(required) Envronment name|

### Note:  
If list of HASH is not rpovided for subets, then TF create public and private subnets for each AZ based on number of AZ available in the region.
## Examples

### Create VPC with auto subnets calculation
```
provider "aws"{
}

module "test-vpc" {
source = "modules/vpc"
vpc_cidr = "172.168.0.0/16"
environment  = "prod"
vpc_name = "vpc-name"
}


output "external_subnets" {
value = "${module.test-vpc.external_autosubnets}"
}

output "intenal_subnets" {
value = "${module.test-vpc.internal_autosubnets}"
}
```

### Create VPC with custom preference

```
provider "aws"{
}

module "test-vpc" {
source = "modules/vpc"
vpc_cidr = "172.30.0.0/16"
environment  = "prod"
vpc_name = "vpc-name"
external_subnets = [
{name = "pubsub-1", cidr = "172.30.0.0/20", az = "ap-southeast-1a"},
{name = "pubsub-2", cidr = "172.30.32.0/20", az = "ap-southeast-1b"},
{name = "pubsub-3", cidr = "172.30.64.0/20", az = "ap-southeast-1c"}
]

internal_subnets = [
{name = "prisub-1", cidr = "172.30.96.0/20", az = "ap-southeast-1a"},
{name = "prisub-2", cidr = "172.30.128.0/20", az = "ap-southeast-1b"},
{name = "prisub-3", cidr = "172.30.150.0/20", az = "ap-southeast-1c"}
]
}

output "external_subnets" {
value = "${module.test-vpc.external_subnets}"
}

output "intenal_subnets" {
value = "${module.test-vpc.internal_subnets}"
}
```
