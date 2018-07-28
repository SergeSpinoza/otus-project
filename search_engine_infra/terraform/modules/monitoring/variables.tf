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

variable mon_machine_type {
  description = "Production machine type"
  default     = "g1-small"
}

variable mon_disk_type {
  description = "Disk type"
  default     = "pd-standard"
}

variable mon_disk_size {
  description = "Disk size"
  default     = "40"
}
