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
                    def planStatus = sh(script: '''
                    curl -H "Authorization: token ${GITHUB_TOKEN}" -L -o generate_terraform_plan.sh https://raw.githubusercontent.com/dancb/iacost/main/generate_terraform_plan.sh
                    chmod +x generate_terraform_plan.sh

                    # Verificar si Terraform ya ha sido inicializado
                    if [ ! -d ".terraform" ]; then
                        echo "Terraform no está inicializado. Ejecutando terraform init..."
                        terraform init
                    else
                        echo "Terraform ya está inicializado."
                    fi

                    ./generate_terraform_plan.sh
                    ''', returnStatus: true)

                    // Validar si hubo cambios (planStatus == 1)
                    if (planStatus == 1) {
                        echo "Cambios detectados. Ejecutando pricing_calc.py..."
                        // Download and execute pricing_calc.py inside virtual environment
                        sh '''
                        echo "GITHUB_TOKEN: ${GITHUB_TOKEN}"  # Imprimir el valor de GITHUB_TOKEN
                        curl -H "Authorization: token ${GITHUB_TOKEN}" -L -o pricing_calc.py https://raw.githubusercontent.com/dancb/iacost/main/pricing_calc.py
                        . venv/bin/activate  # Activar el entorno virtual
                        python3 pricing_calc.py  # Ejecutar el script
                        '''
                    } else {
                        echo "No se detectaron cambios. Omitiendo la ejecución de pricing_calc.py."
                    }
                }
            }
        }

        stage('Deploy Terraform') {
            steps {
                script {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}
