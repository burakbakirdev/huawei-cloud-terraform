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



