module "appsbrokercluster" {
  source                   = "./modules/cluster"
  authorized_source_ranges = var.authorized_source_ranges
  bucket = module.appsbrokersqldatabase.samplesuji-gceme-artifacts.name
 // namespace = module.appsbrokerk8s.k8snamespace
}
module "appsbrokersqldatabase" {
  source  = "./modules/sql-database"
  network = module.appsbrokercluster.vpc-net-testproj.id
 //namespace = module.appsbrokerk8s.k8snamespace
}

module "appsbrokerk8s" {
  source  = "./modules/k8s"
  bucket = module.appsbrokersqldatabase.samplesuji-gceme-artifacts.name
 // namespace =module.namespace.name
 // namespace = module.appsbrokerk8s.k8snamespace
}