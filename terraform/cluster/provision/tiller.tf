module tiller {
  source = "../../modules/k8s/tiller"

  namespace = "tiller-system"
}



# resource kubernetes_cluster_role_binding tiller {
#   count = "${length(var.users)}"

#   metadata {
#     name = "tiller-${lookup(var.users[count.index], "username")}"

#     labels {
#       "app.kubernetes.io/name"       = "helm"
#       "app.kubernetes.io/component"  = "tiller"
#       "app.kubernetes.io/managed-by" = "terraform"
#     }
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = "cluster-admin"
#   }

#   subject {
#     kind      = "ServiceAccount"
#     name      = "tiller"
#     namespace = "${lookup(var.users[count.index], "username")}"
#     api_group = ""
#   }

#   depends_on = [
#     "kubernetes_namespace.this",
#     "kubernetes_service_account.tiller",
#   ]
# }

# # Deployment
# resource kubernetes_deployment tiller {
#   count = "${length(var.users)}"

#   metadata {
#     name      = "tiller-deploy"
#     namespace = "${lookup(var.users[count.index], "username")}"

#     labels {
#       "app.kubernetes.io/name"       = "helm"
#       "app.kubernetes.io/component"  = "tiller"
#       "app.kubernetes.io/managed-by" = "terraform"
#       "app.kubernetes.io/version"    = "${var.tiller_version}"
#     }
#   }

#   spec {
#     replicas = "${var.tiller_replicas}"

#     selector {
#       match_labels {
#         app  = "helm"
#         name = "tiller"
#       }
#     }

#     template {
#       metadata {
#         labels {
#           app  = "helm"
#           name = "tiller"
#         }
#       }

#       spec {
#         service_account_name = "tiller"

#         container {
#           name              = "tiller"
#           image             = "${var.tiller_image}"
#           image_pull_policy = "IfNotPresent"

#           port {
#             name           = "tiller"
#             container_port = 44134
#           }

#           port {
#             name           = "http"
#             container_port = 44135
#           }

#           env {
#             name  = "TILLER_NAMESPACE"
#             value = "${lookup(var.users[count.index], "username")}"
#           }

#           env {
#             name  = "TILLER_HISTORY_MAX"
#             value = "${var.tiller_max_history}"
#           }

#           liveness_probe {
#             http_get {
#               path = "/liveness"
#               port = 44135
#             }

#             initial_delay_seconds = 1
#             timeout_seconds       = 1
#           }

#           readiness_probe {
#             http_get {
#               path = "/readiness"
#               port = 44135
#             }

#             initial_delay_seconds = 1
#             timeout_seconds       = 1
#           }

#           volume_mount {
#             mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
#             name       = "${element(kubernetes_service_account.tiller.*.default_secret_name, count.index)}"
#             read_only  = true
#           }
#         }

#         volume {
#           name = "${element(kubernetes_service_account.tiller.*.default_secret_name, count.index)}"

#           secret {
#             secret_name = "${element(kubernetes_service_account.tiller.*.default_secret_name, count.index)}"
#           }
#         }
#       }
#     }
#   }

#   depends_on = [
#     "kubernetes_namespace.this",
#     "kubernetes_service_account.tiller",
#     "kubernetes_cluster_role_binding.tiller",
#   ]
# }

# resource kubernetes_service tiller {
#   metadata {
#     labels {
#       "app.kubernetes.io/name"       = "helm"
#       "app.kubernetes.io/component"  = "tiller"
#       "app.kubernetes.io/managed-by" = "terraform"
#     }

#     name      = "tiller-deploy"
#     namespace = "${lookup(var.users[count.index], "username")}"
#   }

#   spec {
#     port {
#       name        = "tiller"
#       port        = 44134
#       target_port = "tiller"
#     }

#     selector {
#       app  = "helm"
#       name = "tiller"
#     }

#     type = "${var.tiller_service_type}"
#   }

#   depends_on = [
#     "kubernetes_namespace.this",
#     "kubernetes_service_account.tiller",
#     "kubernetes_cluster_role_binding.tiller",
#     "kubernetes_deployment.tiller",
#   ]
# }