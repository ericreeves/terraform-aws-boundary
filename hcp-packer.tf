data "hcp_packer_iteration" "ubuntu-web" {
  bucket_name = "ubuntu-web"
  channel     = "production"
}

data "hcp_packer_image" "ubuntu-web" {
  bucket_name    = "ubuntu-web"
  cloud_provider = "aws"
  iteration_id   = data.hcp_packer_iteration.ubuntu-web.ulid
  region         = "us-west-2"
}
