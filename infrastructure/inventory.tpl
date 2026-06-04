[bastion]
instance_a ansible_host=${instance_a_public_ip}

[frontend]
instance_e ansible_host=${instance_e_private_ip}

[worker]
instance_b ansible_host=${instance_b_private_ip}
instance_d ansible_host=${instance_d_private_ip}

[database]
instance_c ansible_host=${instance_c_private_ip}

[database_secondary]
instance_f ansible_host=${instance_f_private_ip}

[worker:vars]
ansible_ssh_common_args='-o ForwardAgent=yes -o ProxyJump=ec2-user@${instance_a_public_ip}'

[frontend:vars]
ansible_ssh_common_args='-o ForwardAgent=yes -o ProxyJump=ec2-user@${instance_a_public_ip}'

[database:vars]
ansible_ssh_common_args='-o ForwardAgent=yes -o ProxyJump=ec2-user@${instance_a_public_ip}'

[database_secondary:vars]
ansible_ssh_common_args='-o ForwardAgent=yes -o ProxyJump=ec2-user@${instance_a_public_ip}'

[all:vars]
ansible_user=ec2-user
ansible_ssh_private_key_file=/Users/tatianatudor/Desktop/devops/tatiana-project1.pem

primary_db_host=${instance_c_private_ip}
secondary_db_host=${instance_f_private_ip}