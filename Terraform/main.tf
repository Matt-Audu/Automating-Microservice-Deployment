provider "aws" {
  region = var.aws_region
}

#Deployment instance
resource "aws_instance" "main" {
  ami             = "ami-005fc0f236362e99f"
  instance_type   = "t2.large"
  security_groups = [aws_security_group.group1.name]
  key_name        = "TF_key"
  tags = {
    Name = var.server_names[0]
  }
}

# Generate Ansible inventory file
resource "local_file" "ansible_inventory" {
  filename = "inventory.ini"
  content  = <<EOT
[main]
${aws_instance.main.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/matt/Hng-stage4-task/Terraform/tfkey.pem
EOT
}

# Trigger Ansible playbook
resource "null_resource" "run_ansible" {
  depends_on = [local_file.ansible_inventory]

  provisioner "local-exec" {
    command = "cd ../Ansible && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook.yml"
  }
}


#Elastic IP
resource "aws_eip" "eip1" {
  instance = aws_instance.main.id
}

#Security group
resource "aws_security_group" "group1" {
  name        = "Production"
  description = "Allow inbound and outbound traffic"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "egress" {
    iterator = port
    for_each = var.egress
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

#SSH .pem key
resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey.pem"
}
