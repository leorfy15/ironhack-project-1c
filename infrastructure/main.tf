data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "vpc-tatiana"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = var.az_a
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = var.az_b
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = var.az_a
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = var.az_b
}

resource "aws_security_group" "sg_a" {
  name   = "tatiana-security-group-a"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "tatiana_key" {
  key_name   = "tatiana-project1"
  public_key = file("/Users/tatianatudor/Desktop/devops/tatiana-project1.pub")
}
resource "aws_instance" "instance_a" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.sg_a.id]
  key_name               = aws_key_pair.tatiana_key.key_name

  instance_market_options {
    market_type = "spot"
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "tatiana-instance-a"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tatiana-igw"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "tatiana-public-route-table"
  }
}
resource "aws_route_table_association" "public_assoc_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "tatiana-nat-eip"
  }
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "tatiana-nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}
resource "aws_route_table_association" "private_assoc_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }


  tags = {
    Name = "tatiana-private-route-table"
  }
}

resource "aws_security_group" "sg_b" {
  name   = "tatiana-security-group-b"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_a.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_a.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tatiana-security-group-b"
  }
}
resource "aws_security_group" "sg_c" {
  name   = "tatiana-security-group-c"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_a.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "sg_e" {
  name   = "tatiana-security-group-e"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_a.id]
  }

  ingress {
    from_port   = 8080
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
  from_port   = 8081
  to_port     = 8081
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "instance_b" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_a.id
  vpc_security_group_ids = [aws_security_group.sg_b.id]

  key_name = aws_key_pair.tatiana_key.key_name

  instance_market_options {
    market_type = "spot"
  }
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "tatiana-instance-b"
  }
}
resource "aws_instance" "instance_d" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_b.id
  vpc_security_group_ids = [aws_security_group.sg_b.id]

  key_name = aws_key_pair.tatiana_key.key_name

  instance_market_options {
    market_type = "spot"
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "tatiana-instance-d"
  }
}
resource "aws_instance" "instance_e" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_b.id
  vpc_security_group_ids = [aws_security_group.sg_e.id]

  key_name = aws_key_pair.tatiana_key.key_name

  instance_market_options {
    market_type = "spot"
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "tatiana-instance-e"
  }
}
resource "aws_instance" "instance_c" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_a.id
  vpc_security_group_ids = [aws_security_group.sg_c.id]

  key_name = aws_key_pair.tatiana_key.key_name

  instance_market_options {
    market_type = "spot"
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "tatiana-instance-c"
  }
}

resource "aws_instance" "instance_f" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.private_b.id

  vpc_security_group_ids = [aws_security_group.sg_c.id]

  key_name = aws_key_pair.tatiana_key.key_name

  instance_market_options {
    market_type = "spot"
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "tatiana-instance-f-postgres-replica"
  }
}
resource "aws_lb" "vote_alb" {
  name               = "tatiana-vote-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.sg_a.id]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  tags = {
    Name = "tatiana-vote-alb"
  }
}
resource "aws_lb_target_group" "vote_tg" {
  name     = "tatiana-vote-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
resource "aws_lb_target_group_attachment" "instance_a" {
  target_group_arn = aws_lb_target_group.vote_tg.arn
  target_id        = aws_instance.instance_a.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "instance_e" {
  target_group_arn = aws_lb_target_group.vote_tg.arn
  target_id        = aws_instance.instance_e.id
  port             = 8080
}
resource "aws_lb_listener" "vote_listener" {
  load_balancer_arn = aws_lb.vote_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vote_tg.arn
  }
}
resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory.ini"

  content = templatefile("${path.module}/inventory.tpl", {
    instance_a_public_ip = aws_instance.instance_a.public_ip
    instance_e_public_ip = aws_instance.instance_e.public_ip

    instance_b_private_ip = aws_instance.instance_b.private_ip
    instance_c_private_ip = aws_instance.instance_c.private_ip
    instance_d_private_ip = aws_instance.instance_d.private_ip
    instance_f_private_ip = aws_instance.instance_f.private_ip
  })
}