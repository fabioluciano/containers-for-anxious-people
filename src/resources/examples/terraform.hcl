resource "aws_subnet" "subnet-public-1" {
  vpc_id            = "${aws_vpc.vpc-devops.id}"
  cidr_block        = "${cidrsubnet(aws_vpc.vpc-devops.cidr_block, 8, 1)}"
  ipv6_cidr_block   = "${cidrsubnet(aws_vpc.vpc-devops.ipv6_cidr_block, 8, 1)}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  map_public_ip_on_launch = true

  tags {
    Name = "${cidrsubnet(aws_vpc.vpc-devops.cidr_block, 8, 2)} - subnet-public-1"
  }
}
