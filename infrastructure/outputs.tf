output "instance_a_public_ip" {
  value = aws_instance.instance_a.public_ip
}

output "vpc_id" {
  value = aws_vpc.main.id
}
output "instance_b_private_ip" {
  value = aws_instance.instance_b.private_ip
}
output "instance_c_private_ip" {
  value = aws_instance.instance_c.private_ip
}
output "instance_d_private_ip" {
  value = aws_instance.instance_d.private_ip
}

output "instance_e_private_ip" {
  value = aws_instance.instance_e.private_ip
}
output "instance_f_private_ip" {
  value = aws_instance.instance_f.private_ip
}
output "alb_dns_name" {
  value = aws_lb.vote_alb.dns_name
}