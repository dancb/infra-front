pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        GITHUB_TOKEN = credentials('GITHUB_TOKEN')  // Store token in Jenkins as secret text
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    // Check and install Terraform, curl, Python, and boto3
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

                    def boto3_installed = sh(script: 'python3 -m pip show boto3', returnStatus: true)
                    if (boto3_installed != 0) {
                        echo 'Installing boto3...'
                        sh 'pip3 install boto3'
                    }

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
                    chmod +x generate_terraform_plan.sh
                    ./generate_terraform_plan.sh
                    '''

                    // Download and execute pricing_calc.py
                    sh '''
                    curl -H "Authorization: token ${GITHUB_TOKEN}" -L -o pricing_calc.py https://github.com/dancb/iacost/blob/main/pricing_calc.py
                    python3 pricing_calc.py
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
