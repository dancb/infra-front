variable "aws_region" {
  description = "La región de AWS donde se creará el bucket"
  type        = string
  default     = "us-east-1"  # Puedes cambiar la región por defecto
}

variable "bucket_name" {
  description = "El nombre del bucket S3"
  type        = string
  default     = "buckets3-ejecutado-x-jenkins-deforma-automatizada-123"
}

variable "environment" {
  description = "El entorno del bucket (ej. Desarrollo, Producción)"
  type        = string
  default     = "Desarrollo"
}

