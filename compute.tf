resource "aws_security_group" "main" {
  name        = "patientping-empty"
  description = "Placeholder security group for PatientPing server"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "placeholder"
  }
}

resource "aws_security_group" "patientping-public" {
  name        = "patientping-public"
  description = "Allow public access"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "patientping-sg-public"
  }
}

resource "aws_security_group_rule" "patientping_public_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.patientping-public.id
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow web traffic for PatientPing site"
}

resource "aws_security_group_rule" "patientping_public_egress" {
  type              = "egress"
  security_group_id = aws_security_group.patientping-public.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_network_interface" "main" {
  subnet_id       = aws_subnet.public_a.id
  security_groups = [aws_security_group.main.id, aws_security_group.patientping-public.id]
}

resource "aws_key_pair" "main" {
  key_name   = "patientping-key"
  public_key = file(var.ssh_public_key_path)
}

resource "aws_instance" "web" {
  ami      = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  key_name = aws_key_pair.main.key_name

  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_a.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.main.id, aws_security_group.patientping-public.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2.name


  tags = {
    Name = "patientping-web"
  }
}

resource "aws_ami_from_instance" "web" {
  count              = var.is_local ? 0 : 1
  name               = "patientping-web-base"
  source_instance_id = aws_instance.web.id
}

resource "aws_launch_template" "web" {
  count       = var.is_local ? 0 : 1
  name        = "patientping-web-launcher"
  description = "Launch template for t3.micro with PatientPing app presinstalled"

  image_id      = aws_ami_from_instance.web[count.index].id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.main.key_name

  network_interfaces {
    subnet_id                   = aws_subnet.public_a.id
    associate_public_ip_address = false
    security_groups             = [aws_security_group.patientping-public.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp3"
    }
  }

}

