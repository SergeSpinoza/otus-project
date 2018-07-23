resource "google_compute_disk" "gitlab-files" {
  name  = "gitlab-files"
  type  = "${var.gitlab_ci_persistent_disk_type}"
  zone = "${var.zone}"
  size = "${var.gitlab_ci_persistent_disk_size}"
  labels {
    environment = "gitlab-ci"
  }
}

resource "google_compute_instance" "gitlab-ci" {
  name         = "gitlab-ci"
  machine_type = "${var.gitlab_ci_machine_type}"
  zone         = "${var.zone}"
  tags         = ["web-servers", "gitlab-ci"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
      size  = "${var.gitlab_ci_disk_size}"
      type  = "${var.gitlab_ci_disk_type}"
    }
  }

  network_interface {
    subnetwork    = "int-net-default-24"
    access_config = {}
  }

  metadata {
    ssh-keys = "otusproj:${file(var.public_key_path)}"
  }

  service_account {
    scopes = ["compute-rw"]
  }

  attached_disk {
    source = "${google_compute_disk.gitlab-files.self_link}"
  }
}

resource "null_resource" "new-disk" {
  count = "${var.gitlab_new_disk ? 1 : 0}"

  connection {
    host        = "${element(google_compute_instance.gitlab-ci.*.network_interface.0.access_config.0.assigned_nat_ip, 0)}"
    type        = "ssh"
    user        = "otusproj"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/create-new-disk.sh"
  }
}

resource "null_resource" "mount-disk" {
  count = "${var.gitlab_mount_disk ? 1 : 0}"

  connection {
    host        = "${element(google_compute_instance.gitlab-ci.*.network_interface.0.access_config.0.assigned_nat_ip, 0)}"
    type        = "ssh"
    user        = "otusproj"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "${path.module}/files/fstab"
    destination = "/tmp/fstab"
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }
}
