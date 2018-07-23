terraform {
  backend "gcs" {
    bucket = "docker-201808-terraform-storage-bucket-1"
    prefix = "terraform/prod"
  }
}
