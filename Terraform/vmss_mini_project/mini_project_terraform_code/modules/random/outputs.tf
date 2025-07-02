output "suffix" {
  description = "Random suffix for unique naming"
  value       = random_id.suffix.hex
}