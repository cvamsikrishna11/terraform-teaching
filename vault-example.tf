## To explain Hashicorp Vault Usage in Terraform

# Configure the AWS provider
provider "aws" {
  region = "us-west-2"
}

# Configure the Vault provider
provider "vault" {
  address = "http://vault.example.com:8200"
  token   = var.vault_token
}

# Read the database credentials from Vault
data "vault_generic_secret" "db_creds" {
  path = "secret/databases/prod"
}

# Create an RDS database instance
resource "aws_db_instance" "example" {
  engine         = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  name           = "example_db"

  username = data.vault_generic_secret.db_creds.data["username"]
  password = data.vault_generic_secret.db_creds.data["password"]

  # Other RDS configuration options...
}
