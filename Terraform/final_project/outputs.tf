output "frontend_load_balancer_public_ip" {
  description = "Public IP address of the frontend load balancer"
  value       = module.vmss_frontend.load_balancer_public_ip
}

output "backend_internal_lb_ip" {
  description = "Private IP address of the backend internal load balancer"
  value       = module.vmss_backend.internal_lb_private_ip
}

output "ssh_nat_pool_info" {
  description = "SSH NAT Pool information for frontend VMSS instances"
  value       = module.vmss_frontend.ssh_nat_pool_info
}