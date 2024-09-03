provider "huaweicloud" {
  region     = var.hw_region_name
  access_key = var.hw_access_key
  secret_key = var.hw_secret_key
}

# resource "huaweicloud_vpc" "example" {
#   name = "terraform_vpc_test"
#   cidr = "192.168.0.0/16"
# }

# resource "huaweicloud_vpc_subnet" "mynet" {
#   name       = "my-new-terraform-subnet"
#   vpc_id     = huaweicloud_vpc.example.id
#   cidr       = "192.168.1.0/24"
#   gateway_ip = "192.168.1.1"
# }

data "huaweicloud_availability_zones" "myaz" {}

data "huaweicloud_compute_flavors" "myflavor" {
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  performance_type  = "normal"
  cpu_core_count    = 1
  memory_size       = 1
}

data "huaweicloud_images_image" "myimage" {
  name        = "Ubuntu 18.04 server 64bit"
  most_recent = true
}

# data "huaweicloud_vpc_subnet" "mynet" {
#   name = huaweicloud_vpc_subnet.mynet.name
# }

# data "huaweicloud_networking_secgroup" "mysecgroup" {
#   name = "sg-burak-test"
# }

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!@#$%*"
}

resource "huaweicloud_compute_instance" "myinstance" {
  name                  = "terraform-ecs"
  admin_pass            = random_password.password.result
  image_id              = data.huaweicloud_images_image.myimage.id
  flavor_id             = data.huaweicloud_compute_flavors.myflavor.ids[0]
  availability_zone     = data.huaweicloud_availability_zones.myaz.names[0]
  security_group_ids    = [huaweicloud_networking_secgroup.mysecgroup.id]
  charging_mode         = "postPaid"
  enterprise_project_id = "4e943fe2-c61e-4166-a40e-0882f7cf3d92"

  network {
    uuid = huaweicloud_vpc_subnet.subnet2.id
  }
}


resource "huaweicloud_vpc" "vpc_1" {
  name = var.vpc_name
  cidr = var.vpc_cidr
}

resource "huaweicloud_vpc_subnet" "subnet_1" {
  vpc_id      = huaweicloud_vpc.vpc_1.id
  name        = var.subnet_name
  cidr        = var.subnet_cidr
  gateway_ip  = var.subnet_gateway
  primary_dns = var.primary_dns
}

data "huaweicloud_networking_secgroup" "mysecgroup" {
  name = "default"
}

data "huaweicloud_compute_flavors" "mybiggerflavor" {
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  performance_type  = "normal"
  cpu_core_count    = 2
  memory_size       = 4
}


resource "huaweicloud_compute_instance" "mycompute" {
  name                  = "mycompute_${count.index}"
  image_id              = data.huaweicloud_images_image.myimage.id
  flavor_id             = data.huaweicloud_compute_flavors.mybiggerflavor.ids[0]
  availability_zone     = data.huaweicloud_availability_zones.myaz.names[0]
  security_group_ids    = [data.huaweicloud_networking_secgroup.mysecgroup.id]
  charging_mode         = "postPaid"
  enterprise_project_id = "4e943fe2-c61e-4166-a40e-0882f7cf3d92"
  network {
    uuid = huaweicloud_vpc_subnet.subnet_1.id
  }
  count = 2
}

resource "huaweicloud_networking_vip" "vip_1" {
  network_id = huaweicloud_vpc_subnet.subnet_1.id
}

# associate ports to the vip
resource "huaweicloud_networking_vip_associate" "vip_associated" {
  vip_id = huaweicloud_networking_vip.vip_1.id
  port_ids = [
    huaweicloud_compute_instance.mycompute[0].network.0.port,
    huaweicloud_compute_instance.mycompute[1].network.0.port
  ]
}
