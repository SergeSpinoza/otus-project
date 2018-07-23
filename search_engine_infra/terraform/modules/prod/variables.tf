variable zone {
  description = "Zone"
  default     = "europe-west4-b"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}

variable prod_instance_count {
  description = "Production instance count"
  default     = "1"
}

variable prod_machine_type {
  description = "Production machine type"
  default     = "g1-small"
}

variable prod_disk_type {
  description = "Disk type"
  default     = "pd-standard"
}

variable prod_disk_size {
  description = "Disk size"
  default     = "30"
}
