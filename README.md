# Deploy Microservice Application using Docker, Terraform and Ansible

## Prerequisites
- Install Terraform and Ansible in your linux(ubuntu), WSL or Macbook
- Purchase a domain name
- Install AWS CLI
- Configure Terraform access with AWS

### Clone Git repository
```
git clone https://github.com/Matt-Audu/infra-hng-stage4
``` 

### Set up your environment
- Add the path to your SSH key at ansible_inventory block in main.tf
```
#resource "local_file" "ansible_inventory" {
  filename = "inventory.ini"
  content  = <<EOT
[main]
${aws_instance.main.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${path.module}<path/to/Terraform/tfkey.pem>
EOT
}
```
- Comment out Ansible Config in Main.tf
```
/*
resource "local_file" "ansible_inventory" {
  filename = "inventory.ini"
  content  = <<EOT
[main]
${aws_instance.main.public_ip} ansible_user=matt ansible_ssh_private_key_file=${path.module}Terraform/tfkey.pem
EOT
}

# Trigger Ansible playbook
resource "null_resource" "run_ansible" {
  depends_on = [local_file.ansible_inventory]

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook.yml"
  }
}
*/
```
### Provision Deployment server
- Provision your deployment instance to generate public IP for Domain name
```
terraform init
Run terraform plan
Run terraform apply
```
### Map Public Ip to Domain name
- Create an A record
- Create a CNAME record with wildcard subdomain option

### Configure Ansible
- Disable Host key Checking
```
vi ~/.ansible.cfg
```
- Paste this settings 
```
[defaults]
host_key_checking = False
```

### Configure domain name and subdomain for traefik
- Head over to https://github.com/Matt-Audu/DevOps-Stage-4
- Edit docker-compose.yml 
- Edit domain name and subdomains for the various services to your own

### Deploy infrastructure
- Remove comment from Ansiblerblock in Terraform/main.tf
- Run terraform init
- Run terraform apply -auto-approve

### Access Endpoints

- Frontend: https://domain.com is https://mattaudu.xyz
- Auth API: https://auth.domain.com is https://auth.mattaudu.xyz
- Todos API: https://todos.domain.com is https://todos.mattaudu.xyz
- Users API: https://users.domain.com is https://users.mattaudu.xyz

