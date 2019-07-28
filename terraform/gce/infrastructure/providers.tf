provider google {
  project = "${var.project}"
  region  = "${var.region}"
  version = "~> 1.20"
}

terraform {
  backend "gcs" {}
}

provider template {
  version = "2.1.2"
}

provider tls {
  version = "2.0"
}

provider local {
  version = "~> 1.3"
}