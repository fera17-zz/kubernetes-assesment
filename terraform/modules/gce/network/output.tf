output network_name {
  value = "${google_compute_network.this.name}"
}

output network_link {
  value = "${google_compute_network.this.self_link}"
}

output public_subnetwork_name {
  value = "${google_compute_subnetwork.public.name}"
}


output public_subnetwork_link {
  value = "${google_compute_subnetwork.public.self_link}"
}

output private_subnetwork_name {
  value = "${google_compute_subnetwork.public.name}"
}


output private_subnetwork_link {
  value = "${google_compute_subnetwork.public.self_link}"
}