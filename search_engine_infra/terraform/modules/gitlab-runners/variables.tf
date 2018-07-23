variable zone {
  description = "Zone"
  default     = "europe-west4-b"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable gitlab_runners_machine_type {
  description = "Gitlab-ci runners machine type"
  default     = "g1-small"
}

variable disk_image {
  description = "Disk image"
}

variable gitlab_runners_disk_type {
  description = "Disk type"
  default     = "pd-standard"
}

variable gitlab_runners_disk_size {
  description = "Disk size"
  default     = "20"
}
