variable zone {
  description = "Zone"
  default     = "europe-west4-b"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable gitlab_ci_machine_type {
  description = "Gitlab-ci machine type"
  default     = "n1-standard-1"
}

variable disk_image {
  description = "Disk image"
}

variable gitlab_ci_persistent_disk_type {
  description = "Persistent disk type"
  default     = "pd-standard"
}

variable gitlab_ci_persistent_disk_size {
  description = "Persistent disk size"
  default     = "40"
}

variable gitlab_ci_disk_type {
  description = "Disk type"
  default     = "pd-standard"
}

variable gitlab_ci_disk_size {
  description = "Disk size"
  default     = "40"
}

variable gitlab_new_disk {
  description = "Need to create disk"
  default     = "0"
}

variable gitlab_mount_disk {
  description = "Need to mount disk"
  default     = "1"
}
