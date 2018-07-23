resource "google_compute_instance" "production" {
  count        = "${var.prod_instance_count}"
  name         = "prod-${count.index}"
  machine_type = "${var.prod_machine_type}"
  zone         = "${var.zone}"
  tags         = ["production", "search-engine-ui"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
      size  = "${var.prod_disk_size}"
      type  = "${var.prod_disk_type}"
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
