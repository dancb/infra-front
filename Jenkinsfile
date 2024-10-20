pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')  // Usar el ID que configuraste
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')  // Usar el ID que configuraste
    }
    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/dancb/infra-front.git', branch: 'main'
            }
        }
        stage('Deploy Terraform') {
            steps {
                script {
                    def terraform_installed = sh(script: 'which terraform', returnStatus: true)
                    
                    if (terraform_installed != 0) {
                        echo 'Terraform no está instalado. Procediendo con la instalación.'
                        sh '''
                        curl -O https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
                        unzip -o terraform_1.5.7_linux_amd64.zip
                        mkdir -p terraform-bin
                        mv terraform terraform-bin/
                        '''
                        env.PATH = "${env.WORKSPACE}/terraform-bin:${env.PATH}"
                    } 
                    
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}
