packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}
variable "aws_region" {
  type    = string
  default = "us-west-2"
}

source "amazon-ebs" "al2" {
  region = var.aws_region

  source_ami_filter {
    filters = {
      name = "amzn2-ami-hvm-*-x86_64-gp2"
    }
    owners      = ["137112412989"]
    most_recent = true
  }

  instance_type = "t3.micro"
  ssh_username  = "ec2-user"
  vpc_id           = "vpc-09216058ff8b25b5f"
  subnet_id        = "subnet-03014bd375d7df245"
  ami_name = "my-test-ami"
}

build {
  name    = "basic-ami"
  sources = ["source.amazon-ebs.al2"]

  provisioner "shell" {
    inline = [
      "echo 'Hello from Packer!'",
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl enable httpd"
    ]
  }
 post-processor "manifest" {
    output = "manifest.json"
  }
}
