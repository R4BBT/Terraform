# VM configuration for Minecraft server
# Project configuration
provider "google" {
    project = "jenkins-299411" #This is the test project I currently have set up
    region = "us-central1"
    zone = "us-central1-f"
}


# Configure a new network for the minecraft server (Optional, not included in the tutorial)
resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
}

# Compute instance disk configuration
resource "google_compute_disk" "default" {
  description = "Persistent Disk for Minecraft server"
  name  = "mc-disk"
  type  = "pd-ssd"
  zone  = "us-central1-f"
  image = "ubuntu-os-cloud/ubuntu-1604-xenial-v20201210"
  size = "10" #Size in GB
  physical_block_size_bytes = 4096
}

# Compute instance configuration
resource "google_compute_instance" "vm_instance" {
  name = "mc-server"
  machine_type = "f1-micro" #f1-micro because it's free, but it really should be N1-standard-1 or higher
  tags = ["minecraft-server"] 

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-xenial-v20201210" #This exact image could be found using the command gcloud compute images list | grep ubuntu
      type = "pd-ssd"
    }
  }

  attached_disk {
    source = "mc-disk"
    mode = "READ_WRITE"
  }

  metadata_startup_script = "./start.sh"

  network_interface {
    # A default network is created for all GCP projects
    network = "minecraft-network" 
    access_config { # This empty line allows for ephemeral external IP to be assigned to the VM
    }
  }

  service_account {
    scopes = ["compute-full", "storage-full"]
  }
}

# Configuring firewall rules for Ingress
resource "google_compute_firewall" "default" {
  name    = "minecraft-rule"
  network = "default" # Or the minecraft-server network we just created
  direction = "INGRESS"
  priority = "100"
  
  allow {
    protocol = "all"
  }

  allow {
    protocol = "tcp"
    ports    = ["22, 25565"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["minecraft-server"]
}

#Configure backup storage bucket
resource "google_storage_bucket" "default" {
  name          = "mcbackup122420"
  location      = "US-central1"
  project = "jenkins-299411"
  force_destroy = true
  storage_class = "STANDARD"
  uniform_bucket_level_access = true #Allows IAM permission instead of ACL permission for easier management
  versioning {
    enabled = true
  }
}