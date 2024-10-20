# Configuración del proveedor de AWS
provider "aws" {
  region = var.aws_region  # Se utilizará una variable para la región
}

# Creación del bucket S3
resource "aws_s3_bucket" "mi_bucket" {
  bucket = var.bucket_name  # Nombre del bucket desde variable

  # Etiquetas para el bucket
  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# Creación del bucket S3
resource "aws_s3_bucket" "mi_bucket2" {
  bucket = "unbucketpuessss12112222" # Nombre del bucket desde variable

  # Etiquetas para el bucket
  tags = {
    Name        = "unbucketpuessss12112222"
    Environment = var.environment
  }
}

# Creación del bucket S3
resource "aws_s3_bucket" "mi_bucket3" {
  bucket = "unbucketpuessss12112222" # Nombre del bucket desde variable

  # Etiquetas para el bucket
  tags = {
    Name        = "unbucketpuessss1211222233"
    Environment = var.environment
  }
}
