provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "vcp" {
  source                            = "../modules/vpc"
  source_ranges_to_ssh              = ["0.0.0.0/0"]
  source_ranges_to_search_engine_ui = ["0.0.0.0/0"]
  source_ranges_all                 = ["0.0.0.0/0"]
  source_ranges_int                 = ["10.5.0.0/24"]
  source_ranges_to_monitoring       = ["0.0.0.0/0"]
}

module "gitlab-ci" {
  source                         = "../modules/gitlab-ci"
  public_key_path                = "${var.public_key_path}"
  private_key_path               = "${var.private_key_path}"
  zone                           = "${var.zone}"
  disk_image                     = "${var.disk_image}"
  gitlab_ci_machine_type         = "${var.gitlab_ci_machine_type}"
  gitlab_ci_persistent_disk_type = "${var.gitlab_ci_persistent_disk_type}"
  gitlab_ci_persistent_disk_size = "${var.gitlab_ci_persistent_disk_size}"
  gitlab_ci_disk_size            = "${var.gitlab_ci_disk_size}"
  gitlab_ci_disk_type            = "${var.gitlab_ci_disk_type}"
  gitlab_new_disk                = "${var.gitlab_new_disk}"
  gitlab_mount_disk              = "${var.gitlab_mount_disk}"
}

module "gitlab-runners" {
  source                      = "../modules/gitlab-runners"
  public_key_path             = "${var.public_key_path}"
  zone                        = "${var.zone}"
  disk_image                  = "${var.disk_image}"
  gitlab_runners_machine_type = "${var.gitlab_runners_machine_type}"
  gitlab_runners_disk_type    = "${var.gitlab_runners_disk_type}"
  gitlab_runners_disk_size    = "${var.gitlab_runners_disk_size}"
}

module "prod" {
  source              = "../modules/prod"
  public_key_path     = "${var.public_key_path}"
  zone                = "${var.zone}"
  disk_image          = "${var.disk_image}"
  prod_instance_count = "${var.prod_instance_count}"
  prod_machine_type   = "${var.prod_machine_type}"
  prod_disk_size      = "${var.prod_disk_size}"
  prod_disk_type      = "${var.prod_disk_type}"
}

module "monitoring" {
  source           = "../modules/monitoring"
  public_key_path  = "${var.public_key_path}"
  zone             = "${var.zone}"
  disk_image       = "${var.disk_image}"
  mon_machine_type = "${var.mon_machine_type}"
  mon_disk_size    = "${var.mon_disk_size}"
  mon_disk_type    = "${var.mon_disk_type}"
}
