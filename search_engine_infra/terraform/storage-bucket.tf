provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

### Bucket for terraform state
module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.1.1"
  name    = ["docker-201808-terraform-storage-bucket-1"]
}

output storage-bucket_url {
  value = "${module.storage-bucket.url}"
}
