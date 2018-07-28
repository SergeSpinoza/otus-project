resource "google_compute_instance" "monitoring" {
  name         = "monitoring"
  machine_type = "${var.mon_machine_type}"
  zone         = "${var.zone}"
  tags         = ["monitoring", "web-servers", "grafana", "prometheus", "alertmanager"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
      size  = "${var.mon_disk_size}"
      type  = "${var.mon_disk_type}"
    }
  }

  network_interface {
    subnetwork    = "int-net-default-24"
    access_config = {}
  }

  metadata {
    ssh-keys = "otusproj:${file(var.public_key_path)}"
  }
}
