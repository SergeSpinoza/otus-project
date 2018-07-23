resource "google_compute_instance" "gitlab-runners" {
  name         = "gitlab-runners"
  machine_type = "${var.gitlab_runners_machine_type}"
  zone         = "${var.zone}"
  tags         = ["gitlab-runners"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
      size  = "${var.gitlab_runners_disk_size}"
      type  = "${var.gitlab_runners_disk_type}"
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
}

