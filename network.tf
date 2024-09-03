resource "huaweicloud_vpc" "vpc" {
  name                  = "vpc-web"
  cidr                  = "192.168.0.0/16"
  enterprise_project_id = "4e943fe2-c61e-4166-a40e-0882f7cf3d92"
}
resource "huaweicloud_vpc_subnet" "subnet1" {
  name       = "subnet-web"
  cidr       = "192.168.10.0/24"
  gateway_ip = "192.168.10.1"
  vpc_id     = huaweicloud_vpc.vpc.id
  dns_list   = ["100.125.1.250", "100.125.128.250"]
}
resource "huaweicloud_vpc_subnet" "subnet2" {
  name       = "subnet-app"
  cidr       = "192.168.20.0/24"
  gateway_ip = "192.168.20.1"
  vpc_id     = huaweicloud_vpc.vpc.id
  dns_list   = ["100.125.1.250", "100.125.128.250"]
}
resource "huaweicloud_vpc_subnet" "subnet3" {
  name       = "subnet-db"
  cidr       = "192.168.30.0/24"
  gateway_ip = "192.168.30.1"
  vpc_id     = huaweicloud_vpc.vpc.id
  dns_list   = ["100.125.1.250", "100.125.128.250"]
}

resource "huaweicloud_networking_secgroup" "mysecgroup" {
  name                 = "terraform-secgroup"
  description          = "Sec group created by terraform."
  delete_default_rules = true
}
resource "huaweicloud_networking_secgroup_rule" "secgroup_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.mysecgroup.id
}

