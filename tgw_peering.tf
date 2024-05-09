resource "aws_ec2_transit_gateway" "tgw-singapore" {
  provider = aws.dev-singapore
  description = "tgw-singapore"
  amazon_side_asn = 64512
    auto_accept_shared_attachments = "enable"
  transit_gateway_cidr_blocks = ["10.0.0.0/16"]
  tags = {
    Name = "tgw-singapore"
  }
}

resource "aws_ec2_transit_gateway" "tgw-virginia" {
    provider = aws.dev-virginia
    description = "tgw-virginia"
    amazon_side_asn = 64513
        auto_accept_shared_attachments = "enable"
    transit_gateway_cidr_blocks = ["10.1.0.0/16"]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-singapore" {
  provider = aws.dev-singapore
  subnet_ids = [aws_subnet.vpc_subnet_singapore.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw-singapore.id
  vpc_id = aws_vpc.vpc_singapore.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-virginia" {
  provider = aws.dev-virginia
  subnet_ids = [aws_subnet.vpc_subnet_virginia.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw-virginia.id
  vpc_id = aws_vpc.vpc_virginia.id
}


resource "aws_ec2_transit_gateway_peering_attachment" "tgw-peering" {
  provider           = aws.dev-singapore
  transit_gateway_id = aws_ec2_transit_gateway.tgw-singapore.id
  peer_region = "us-east-1"
  peer_transit_gateway_id = aws_ec2_transit_gateway.tgw-virginia.id
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tgw-peering-accepter" {
  provider           = aws.dev-virginia
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tgw-peering.id
}

resource "aws_ec2_transit_gateway_route" "tgw-route-singapore-1" {
  provider               = aws.dev-singapore
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw-singapore.association_default_route_table_id
  destination_cidr_block = "10.1.0.0/16"
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-singapore.id

}

resource "aws_ec2_transit_gateway_route" "tgw-route-virginia-1" {
  provider = aws.dev-virginia
  destination_cidr_block         = "10.0.0.0/16"
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw-virginia.association_default_route_table_id
    transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.tgw-peering-accepter.id
}
