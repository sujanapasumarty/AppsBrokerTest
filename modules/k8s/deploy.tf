// this file contains the deployments


// create a deployment
resource "kubernetes_deployment" "sca-project-depl" {
  metadata {
    name = "flask-deployment"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  spec {
    replicas = var.deployment_replica
    selector {
      match_labels = {
        run = "uwsgi"
        app = "flask"
      }
    }
    template {
      metadata {
        labels = {
          run = "uwsgi"
          app = "flask"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.kube_sa.metadata[0].name
        container {
            name = "flask"
            image = "${var.container_image}"
            port {
              container_port = 5000
            }
          
            env {
                name = "SQL_PASS"
                value = data.google_storage_bucket_object_content.db_pass.content
            }
            env {
                name = "SQL_USER"
                value = data.google_storage_bucket_object_content.db_user.content

            }
            env {  
                name = "SQL_HOST"
                value = var.db_host
            }
            env {
                name = "SQL_DB"
                value = data.google_storage_bucket_object_content.db.content

            }
            env {
                name = "API_KEY"
                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.iex_cred.metadata[0].name
                    key  = "token"
                  }
                } 
              }
         }
        container {  
            name = "cloud-sql-proxy"
            image = "gcr.io/cloudsql-docker/gce-proxy:1.17"
            command = [
              "/cloud_sql_proxy",
              "-instances=${data.google_storage_bucket_object_content.db_connection.content}=tcp:5432"
              ]
            security_context {
              run_as_non_root = true
            }
          } 
        }
     
     
      } 
   }
}