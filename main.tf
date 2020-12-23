provider "google" {
    project = "{{jenkins-299411}}"    
    region = "us-central1"
    zone = "us-central1-f"
}

resource "google_compute_disk" "default" {
  name  = "test-disk"
  type  = "pd-ssd"
  zone  = "us-central1-f"
  image = "debian-9-stretch-v20200805"
  labels = {
    environment = "dev"
  }
  physical_block_size_bytes = 4096
}

resource "google_compute_instance" "vm_instance" {
  name         = "mc-server"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "Ubuntu 16.04 LTS"
      type = "pd-standard"
    }
  }
  metadata_startup_script = "URL here"

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}