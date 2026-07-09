output "cloudfront_website_url" {
  value       = "https://${aws_cloudfront_distribution.website_cdn.domain_name}"
  description = "Your secure, CDN-hosted website URL!"
}