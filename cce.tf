resource "huaweicloud_vpc" "myvpc" {
  name = "myvpc"
  cidr = "192.168.0.0/16"
}

resource "huaweicloud_vpc_subnet" "mysubnet" {
  name          = "mysubnet"
  cidr          = "192.168.0.0/16"
  gateway_ip    = "192.168.0.1"
  primary_dns   = "100.125.1.250"
  secondary_dns = "100.125.21.250"
  vpc_id        = huaweicloud_vpc.myvpc.id
}

resource "huaweicloud_vpc_eip" "myeip" {
  enterprise_project_id = "4e943fe2-c61e-4166-a40e-0882f7cf3d92"
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "mybandwidth"
    size        = 8
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

resource "huaweicloud_cce_cluster" "mycce" {
  name                   = "mycce"
  flavor_id              = "cce.s1.small"
  vpc_id                 = huaweicloud_vpc.myvpc.id
  subnet_id              = huaweicloud_vpc_subnet.mysubnet.id
  container_network_type = "overlay_l2"
  eip                    = huaweicloud_vpc_eip.myeip.address
  charging_mode          = "postPaid"
  enterprise_project_id  = "4e943fe2-c61e-4166-a40e-0882f7cf3d92"
}

resource "huaweicloud_compute_keypair" "mykeypair" {
  name       = "mykeypair"
}

resource "huaweicloud_cce_node" "mynode" {
  cluster_id            = huaweicloud_cce_cluster.mycce.id
  name                  = "myccenode"
  flavor_id             = "t6.large.1"
  availability_zone     = data.huaweicloud_availability_zones.myaz.names[0]
  key_pair              = huaweicloud_compute_keypair.mykeypair.name
  charging_mode         = "postPaid"
  enterprise_project_id = "4e943fe2-c61e-4166-a40e-0882f7cf3d92"

  root_volume {
    size       = 40
    volumetype = "SAS"
  }
  data_volumes {
    size       = 100
    volumetype = "SAS"
  }
}
