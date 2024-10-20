pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/dancb/infra-front.git', branch: 'main'
            }
        }
        stage('Deploy Terraform') {
            steps {
                script {
                    // Verificar si Terraform está instalado
                    def terraform_installed = sh(script: 'which terraform', returnStatus: true)
                    
                    if (terraform_installed != 0) { // Si Terraform no está instalado
                        echo 'Terraform no está instalado. Procediendo con la instalación.'
                        sh '''
                        curl -O https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
                        unzip -o terraform_1.5.7_linux_amd64.zip
                        mkdir -p terraform-bin
                        mv terraform terraform-bin/
                        '''
                        env.PATH = "${env.WORKSPACE}/terraform-bin:${env.PATH}"
                    } 
                    
                    // Ejecutar Terraform
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}
