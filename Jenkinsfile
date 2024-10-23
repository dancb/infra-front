pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        GITHUB_TOKEN = credentials('GITHUB_TOKEN')  // Store token in Jenkins as secret text
    }

    stages {
        stage('Clone Repository and Setup') {
            steps {
                script {
                    // Check and install Terraform, curl, Python, and boto3 in a virtual environment
                    def terraform_installed = sh(script: 'which terraform', returnStatus: true)
                    if (terraform_installed != 0) {
                        echo 'Installing Terraform...'
                        sh '''
                        curl -O https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
                        unzip -o terraform_1.5.7_linux_amd64.zip
                        mv terraform /usr/local/bin/
                        '''
                    }

                    def curl_installed = sh(script: 'which curl', returnStatus: true)
                    if (curl_installed != 0) {
                        echo 'Installing curl...'
                        sh 'apt update && apt install -y curl'
                    }

                    def python_installed = sh(script: 'which python3', returnStatus: true)
                    if (python_installed != 0) {
                        echo 'Installing Python...'
                        sh 'apt update && apt install -y python3 python3-pip'
                    }

                    // Install python3-venv to enable virtual environment creation
                    echo 'Installing python3-venv...'
                    sh 'apt install -y python3-venv'

                    // Install dos2unix to convert line endings
                    def dos2unix_installed = sh(script: 'which dos2unix', returnStatus: true)
                    if (dos2unix_installed != 0) {
                        echo 'Installing dos2unix...'
                        sh 'apt update && apt install -y dos2unix'
                    }

                    // Create and activate virtual environment
                    sh '''
                    python3 -m venv venv  # Crear entorno virtual
                    . venv/bin/activate   # Activar entorno virtual
                    pip install boto3  # Instalar boto3 en el entorno virtual
                    '''

                    // Clone the repository
                    git url: 'https://github.com/dancb/infra-front.git', branch: 'main'
                }
            }
        }

        stage('Infra Pricing') {
            steps {
                script {
                    // Download and execute generate_terraform_plan.sh
                    sh '''
                    curl -H "Authorization: token ${GITHUB_TOKEN}" -L -o generate_terraform_plan.sh https://github.com/dancb/iacost/raw/main/generate_terraform_plan.sh
                    dos2unix generate_terraform_plan.sh  # Convertir el archivo a formato Unix
                    chmod +x generate_terraform_plan.sh
                    ./generate_terraform_plan.sh
                    '''

                    // Download and execute pricing_calc.py inside virtual environment
                    sh '''
                    curl -H "Authorization: token ${GITHUB_TOKEN}" -L -o pricing_calc.py https://raw.githubusercontent.com/dancb/iacost/main/pricing_calc.py
                    . venv/bin/activate  # Activar el entorno virtual
                    python3 pricing_calc.py  # Ejecutar el script
                    '''
                }
            }
        }

        stage('Deploy Terraform') {
            steps {
                script {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}
