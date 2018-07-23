variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west4"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}

variable zone {
  description = "Zone"
  default     = "europe-west4-b"
}

### GITLAB-CI INSTANCE ###
##########################

variable gitlab_ci_machine_type {
  description = "Gitlab-ci machine type"
}

variable gitlab_ci_persistent_disk_type {
  description = "Persistent disk type"
}

variable gitlab_ci_persistent_disk_size {
  description = "Persistent disk size"
}

variable gitlab_ci_disk_type {
  description = "Disk type"
}

variable gitlab_ci_disk_size {
  description = "Disk size"
}

variable gitlab_new_disk {
  description = "Need to create disk"
}

variable gitlab_mount_disk {
  description = "Need to mount disk"
}

### GITLAB-CI RUNNERS INSTANCE ###
##################################

variable gitlab_runners_machine_type {
  description = "Gitlab-ci runners machine type"
}

variable gitlab_runners_disk_type {
  description = "Disk type"
}

variable gitlab_runners_disk_size {
  description = "Disk size"
}

### PROD INSTANCE ###
#####################

variable prod_instance_count {
  description = "Production instance count"
}

variable prod_machine_type {
  description = "Production machine type"
}

variable prod_disk_type {
  description = "Disk type"
}

variable prod_disk_size {
  description = "Disk size"
}
