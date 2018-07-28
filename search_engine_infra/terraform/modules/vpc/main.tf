# Create internal network
resource "google_compute_network" "int_net_default" {
  name                    = "int-net-default"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "int_net_default_24" {
  name          = "int-net-default-24"
  ip_cidr_range = "10.5.0.0/24"
  network       = "${google_compute_network.int_net_default.self_link}"
}

# Allow SSH
resource "google_compute_firewall" "firewall_ssh" {
  name    = "ssh-to-int-net-default"
  network = "int-net-default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = "${var.source_ranges_to_ssh}"
  depends_on = ["google_compute_subnetwork.int_net_default_24"]
}

# Allow search engine ui
resource "google_compute_firewall" "firewall_search_engine_ui" {
  name    = "search-engine-ui-default"
  network = "int-net-default"

  allow {
    protocol = "tcp"
    ports    = ["8000"]
  }

  target_tags = ["search-engine-ui"]
  source_ranges = "${var.source_ranges_to_search_engine_ui}"
  depends_on = ["google_compute_subnetwork.int_net_default_24"]
}

# Allow ICMP
resource "google_compute_firewall" "firewall_icmp" {
  name    = "icmp-to-int-net-default"
  network = "int-net-default"

  allow {
    protocol = "icmp"
  }

  source_ranges = "${var.source_ranges_all}"
  depends_on = ["google_compute_subnetwork.int_net_default_24"]
}

# Allow HTTP and HTTPS
resource "google_compute_firewall" "firewall_http" {
  name    = "http-to-int-net-default"
  network = "int-net-default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  target_tags = ["web-servers"]
  source_ranges = "${var.source_ranges_all}"
  depends_on = ["google_compute_subnetwork.int_net_default_24"]
}

# Allow grafana
resource "google_compute_firewall" "firewall_allow_grafana" {
  name    = "grafana-default"
  network = "int-net-default"

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }

  target_tags = ["grafana"]
  source_ranges = "${var.source_ranges_to_monitoring}"
  depends_on = ["google_compute_subnetwork.int_net_default_24"]
}

# Allow prometheus
resource "google_compute_firewall" "firewall_allow_prometheus" {
  name    = "prometheus-default"
  network = "int-net-default"

  allow {
    protocol = "tcp"
    ports    = ["9090"]
  }

  target_tags = ["prometheus"]
  source_ranges = "${var.source_ranges_to_monitoring}"
  depends_on = ["google_compute_subnetwork.int_net_default_24"]
}

# Allow alertmanager
resource "google_compute_firewall" "firewall_allow_alertmanager" {
  name    = "alertmanager-default"
  network = "int-net-default"

  allow {
    protocol = "tcp"
    ports    = ["9093"]
  }

  target_tags = ["alertmanager"]
  source_ranges = "${var.source_ranges_to_monitoring}"
  depends_on = ["google_compute_subnetwork.int_net_default_24"]
}

# Allow internal network
resource "google_compute_firewall" "firewall_allow_int" {
  name    = "allow-int-to-int-network"
  network = "int-net-default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = "${var.source_ranges_int}"
  depends_on = ["google_compute_subnetwork.int_net_default_24"]
}
