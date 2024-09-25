pipeline {
    agent any 
    
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
	GIT_TOKEN_CREDENTIALS_ID = 'git-pat-id' // Your PAT credential ID in Jenkins

    }
    
    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'b085035d-9661-4890-8c04-2d41743fa83a', 
                    url: 'https://github.com/bimal-root/cicd-end-to-end.git',
                    branch: 'main'
            }
        }

        stage('Build Docker') {
            steps {
                script {
                    sh '''
                    echo 'Build Docker Image'
                    docker build -t bimalrajsharma07/todoapp:v${BUILD_NUMBER} .
                    '''
                }
            }
        }

        stage('Push the artifacts') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh '''
                        echo 'Logging for Docker Push..'
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        '''
			sh '''
			echo 'Push to Repo'
                        docker push bimalrajsharma07/todoapp:v${BUILD_NUMBER}
                        '''
                    }
                }
            }
        }
        
        stage('Checkout K8S manifest SCM') {
            steps {
                git credentialsId: 'b085035d-9661-4890-8c04-2d41743fa83a', 
                    url: 'https://github.com/bimal-root/cicd-end-to-end.git',
                    branch: 'main'
		
		dir('k8s_Deploy'){
		    sh 'ls -la'
		}
            }
        }
        
        stage('Checkout K8S manifest & Push') {
            steps {
		dir('k8s_Deploy'){
                script {
                    withCredentials([string(credentialsId: GIT_TOKEN_CREDENTIALS_ID, variable: 'GIT_TOKEN')]) {
                        sh '''
			pwd
                        cat deploy.yaml
			ls -la
   			pwd
			sed -i "s/v21/v${BUILD_NUMBER}/g" deploy.yaml
                        cat deploy.yaml
			git config user.name "Bimal Sharma"
                        git config user.email "test@example.com"
                        git add deploy.yaml
                        git commit -m "Updated the deploy yaml | Jenkins Pipeline"
                        git push https://bimal-root:${GIT_TOKEN}@github.com/bimal-root/cicd-end-to-end.git HEAD:main
                        '''  
		    	}
                    }
                }
            }
        }
    }
}

