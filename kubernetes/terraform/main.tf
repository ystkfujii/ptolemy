locals {
  region_west = "jp-west-1"
  region_east = "jp-east-1"
  az_west     = "west-11"
  az_east     = "east-11"

  prefix = "plm"

  instance_key_name = "homek8slab"

  instance_type_bn = "e-medium"
  instance_type_px = "e-medium"
  instance_type_cp = "e-medium"
  instance_type_wk = "e-medium"

  private_network_cidr = "192.168.50.0/23"
  instances_cp_west = {
    "cp01" : { private_ip : "192.168.50.13/23" }
  }
  instances_cp_east = {
    "cp01" : { private_ip : "192.168.51.13/23" }
  }
  instances_wk_west = {
    "wk01" : { private_ip : "192.168.50.23/23" }
    "wk02" : { private_ip : "192.168.50.24/23" }
  }
  instances_wk_east = {
    "wk01" : { private_ip : "192.168.50.23/23" }
    "wk02" : { private_ip : "192.168.51.24/23" }
  }

  private_ip_bn_west = "192.168.50.2/23"
  private_ip_px_west = "192.168.50.3/23"
  private_ip_bn_east = "192.168.51.2/23"
  private_ip_px_east = "192.168.51.3/23"
}

#####
# Provider
#
provider "nifcloud" {
  region = local.region_west
  alias  = "west"
}

provider "nifcloud" {
  region = local.region_east
  alias  = "east"
}

#####
# Elastic IP
#

# elastic ip
resource "nifcloud_elastic_ip" "bn_west" {
  provider = nifcloud.west

  ip_type           = false
  availability_zone = local.az_west
  description       = "bastion"
}
resource "nifcloud_elastic_ip" "px_west" {
  provider = nifcloud.west

  ip_type           = false
  availability_zone = local.az_west
  description       = "egress"
}
resource "nifcloud_elastic_ip" "bn_east" {
  provider = nifcloud.east

  ip_type           = false
  availability_zone = local.az_east
  description       = "bastion"
}
resource "nifcloud_elastic_ip" "px_east" {
  provider = nifcloud.east

  ip_type           = false
  availability_zone = local.az_east
  description       = "egress"
}

#####
# Module
#
module "k8s_infra_west" {
  source  = "github.com/ystkfujii/terraform-nifcloud-k8s-infrastructure"
  providers = {
    nifcloud = nifcloud.west
  }

  availability_zone = local.az_west
  prefix            = local.prefix

  private_network_cidr = local.private_network_cidr

  instance_key_name = local.instance_key_name

  instance_type_bn = local.instance_type_bn
  instance_type_px = local.instance_type_px
  instance_type_cp = local.instance_type_cp
  instance_type_wk = local.instance_type_wk

  instances_cp      = local.instances_cp_west
  instances_wk      = local.instances_wk_west

  elasticip_bn = nifcloud_elastic_ip.bn_west.public_ip
  elasticip_px = nifcloud_elastic_ip.px_west.public_ip

  private_ip_bn = local.private_ip_bn_west
  private_ip_px = local.private_ip_px_west
}

module "k8s_infra_east" {
  source  = "github.com/ystkfujii/terraform-nifcloud-k8s-infrastructure"
  providers = {
    nifcloud = nifcloud.east
  }
  # version = "0.0.5"

  availability_zone = local.az_east
  prefix            = local.prefix

  private_network_cidr = local.private_network_cidr

  instance_key_name = local.instance_key_name

  instance_type_bn = local.instance_type_bn
  instance_type_px = local.instance_type_px
  instance_type_cp = local.instance_type_cp
  instance_type_wk = local.instance_type_wk

  instances_cp      = local.instances_cp_east
  instances_wk      = local.instances_wk_east

  elasticip_bn = nifcloud_elastic_ip.bn_east.public_ip
  elasticip_px = nifcloud_elastic_ip.px_east.public_ip

  private_ip_bn = local.private_ip_bn_east
  private_ip_px = local.private_ip_px_east
}

#####
# Security Group
#
resource "nifcloud_security_group_rule" "any_from_another_reasion_east" {
  provider = nifcloud.east
  security_group_names = concat(
    [for v in module.k8s_infra_east.security_group_name : v],
  )
  type        = "IN"
  protocol    = "ANY"
  cidr_ip     = local.private_network_cidr
}
resource "nifcloud_security_group_rule" "any_from_another_reasion_west" {
  provider = nifcloud.west
  security_group_names = concat(
    [for v in module.k8s_infra_west.security_group_name : v],
  )
  type        = "IN"
  protocol    = "ANY"
  cidr_ip     = local.private_network_cidr
}
