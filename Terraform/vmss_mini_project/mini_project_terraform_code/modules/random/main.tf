terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
    }
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}