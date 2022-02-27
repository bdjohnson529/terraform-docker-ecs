resource "aws_default_vpc" "default_vpc" {
}

resource "aws_default_subnet" "default_a" {
  availability_zone = "us-west-2a"

  tags = {
    Name = "Default subnet for us-west-2a"
  }
}

resource "aws_default_subnet" "default_b" {
  availability_zone = "us-west-2b"

  tags = {
    Name = "Default subnet for us-west-2b"
  }
}

resource "aws_default_subnet" "default_c" {
  availability_zone = "us-west-2c"

  tags = {
    Name = "Default subnet for us-west-2c"
  }
}
