variable source_ranges_to_ssh {
  description = "Allowed IP addresses to SSH"
  default     = []
}

variable source_ranges_to_search_engine_ui {
  description = "Allowed IP addresses to search engine UI"
  default     = []
}

variable source_ranges_all {
  description = "Allowed all IP addresses"
  default     = ["0.0.0.0/0"]
}

variable source_ranges_int {
  description = "Ranges of internal network"
  default     = []
}

variable source_ranges_to_monitoring {
  description = "Allowed IP addresses to monitoring systems"
  default     = []
}