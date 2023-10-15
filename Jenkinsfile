pipeline {
  agent any
    tools {
      maven 'maven3'
      jdk 'JDK13'
    }
    stages {      
        stage('Build maven ') {
            steps { 
                    sh 'pwd'      
                    sh 'ls -ltr'          
                    sh 'hostname'          
                    sh 'echo "test 5"'          
                    sh 'mvn clean install package'
            }
        }
        
        // stage('Copy Artifact') {
        //    steps { 
        //            sh 'pwd'
		//            sh 'cp -r target/*.jar docker'
        //    }
        // }
         
        stage('Build docker image') {
           steps {
               script {         
                 def customImage = docker.build('registration-app2', ".")
                 docker.withRegistry('https://manduacr123.azurecr.io', 'acr-demo') {
                 customImage.push("${env.BUILD_NUMBER}")
                 }                     
           }
        }
	  }
    }
}
