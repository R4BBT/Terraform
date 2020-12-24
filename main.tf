# VM configuration for Minecraft server
provider "google" {
    project = "jenkins-299411"    
    region = "us-central1"
    zone = "us-central1-f"
}

resource "google_compute_disk" "default" {
  description = "Persistent Disk for Minecraft server"
  name  = "mc-disk"
  type  = "pd-ssd"
  zone  = "us-central1-f"
  image = "ubuntu-os-cloud/ubuntu-1604-xenial-v20201210"
  size = "10" #Size in GB
  physical_block_size_bytes = 4096
}

resource "google_compute_instance" "vm_instance" {
  name         = "mc-server"
  machine_type = "f1-micro" #f1-micro because it's free

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-xenial-v20201210" #The exact image could be found using the command gcloud compute images list | grep ubuntu
      type = "pd-ssd"
    }
  }

  attached_disk {
    source = "mc-disk"
    mode = "READ_WRITE"
  }

  metadata_startup_script = "apt-get install screen -y"

  network_interface {
    # A default network is created for all GCP projects
    network = "default" 
    access_config { # This empty line allows for ephemeral external IP to be assigned to the VM
    }
  }

  service_account {
    scopes = ["compute-full", "storage-full"]
  }
}