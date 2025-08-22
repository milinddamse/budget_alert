pipeline {
    agent any
 
    environment {
        // Azure credentials
        AZURE_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        AZURE_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        AZURE_TENANT_ID       = credentials('AZURE_TENANT_ID')
        AZURE_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
    }
 
    stages {
        stage('Terraform Plan') {
            steps {
                sh 'terraform init'
                sh 'terraform plan -out=tfplan'
            }
        }
 
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
 
    post {
        // This stage will run after a successful build. You can trigger it manually
        // or through a separate, dedicated "destroy" job.
        success {
            stage('Terraform Destroy') {
                steps {
                    echo 'Destroying resources...'
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}
