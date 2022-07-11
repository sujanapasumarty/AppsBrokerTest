/* 
resource "google_project_service" "cicdservices" {
  count   = length(var.apis_to_activate)
  project = var.project
  service = var.apis_to_activate[count.index]

  disable_dependent_services = true
}
 */

 