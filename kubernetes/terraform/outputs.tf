output "k8s_infra_east" {
  value = module.k8s_infra_east
}

output "k8s_infra_west" {
  value = module.k8s_infra_west
}

output "worker_lb_east" {
  value       = nifcloud_load_balancer.east.dns_name
}

output "worker_lb_west" {
  value       = nifcloud_load_balancer.west.dns_name
}
