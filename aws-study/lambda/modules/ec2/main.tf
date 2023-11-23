resource "aws_security_group" "allow_all" {
  name  = "allow_all"
  description = "Allow all traffic"
  vpc_id = var.vpc.vpc_id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Project = "${var.project}"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
  subnet_id              = "${var.vpc.intra_subnets[0]}"

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Project = "${var.project}"
  }
}

