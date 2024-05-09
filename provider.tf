provider "aws" {
  region = "us-east-1"
  alias = "dev-virginia"
}

provider "aws" {
  region = "ap-southeast-1"
  alias = "dev-singapore"
}
