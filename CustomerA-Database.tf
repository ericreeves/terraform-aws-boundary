#
# EC2 Web Application
#
data "hcp_packer_iteration" "ubuntu" {
  bucket_name = "ubuntu-postgres"
  channel     = "production"
}

data "hcp_packer_image" "ubuntu_us_west_2" {
  bucket_name    = "ubuntu-postgres"
  cloud_provider = "aws"
  iteration_id   = data.hcp_packer_iteration.ubuntu.ulid
  region         = "us-west-2"
}

resource "aws_instance" "postgres" {
  ami                         = data.hcp_packer_image.ubuntu_us_west_2.cloud_image_id
  instance_type               = var.controller_instance_type
  key_name                    = "eric-hashi"
  associate_public_ip_address = true
  subnet_id                   = local.public_subnets[0]
  vpc_security_group_ids      = [module.controllers.security_group_id]

  tags = {
    Name  = "CustomerA-Database"
    owner = "CustomerA"
    type  = "Database"
  }
}

resource "aws_eip" "postgres" {
  instance = aws_instance.postgres.id
  vpc      = true
}

resource "aws_eip_association" "postgres" {
  instance_id   = aws_instance.postgres.id
  allocation_id = aws_eip.postgres.id
}
