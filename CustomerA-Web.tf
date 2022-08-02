module "autoscale_group_web_a" {
  source = "cloudposse/ec2-autoscale-group/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"

  namespace   = "boundary"
  stage       = "test"
  environment = "demo"
  name        = "CustomerA-Web"

  image_id                    = data.hcp_packer_image.ubuntu-web.cloud_image_id
  instance_type               = "t2.small"
  security_group_ids          = [module.controllers.security_group_id]
  subnet_ids                  = local.public_subnets
  health_check_type           = "EC2"
  min_size                    = 2
  max_size                    = 5
  key_name                    = var.key_name
  wait_for_capacity_timeout   = "5m"
  associate_public_ip_address = true

  # All inputs to `block_device_mappings` have to be defined
  block_device_mappings = [
    {
      device_name  = "/dev/sda1"
      no_device    = "false"
      virtual_name = "root"
      ebs = {
        encrypted             = true
        volume_size           = 20
        delete_on_termination = true
        iops                  = null
        kms_key_id            = null
        snapshot_id           = null
        volume_type           = "standard"
      }
    }
  ]

  tags = {
    owner = "CustomerA"
    type  = "Web"
  }

  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = false
  cpu_utilization_high_threshold_percent = "70"
  cpu_utilization_low_threshold_percent  = "20"
}
