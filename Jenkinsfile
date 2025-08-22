pipeline {
    agent any

    environment {
        // Azure credentials from Jenkins secrets
        AZURE_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        AZURE_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        AZURE_TENANT_ID       = credentials('AZURE_TENANT_ID')
        AZURE_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
    }

    stages {
        stage('Terraform Plan') {
            steps {
                bat '''
                   cd 'C:\Users\kamak\Documents\Terraform\VMSS'
                   terraform init'
                   terraform plan -out=tfplan
                   '''
            }
        }

        stage('Terraform Apply') {
            steps {
                bat '''
                  terraform apply -auto-approve tfplan
                  '''
            }
        }
    }
}
