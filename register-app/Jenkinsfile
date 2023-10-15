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
                    sh './register-app/mvn  clean install package'
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
                 def customImage = docker.build('mandu/petclinic', "./register-app")
                 docker.withRegistry('https://manduacr123.azurecr.io', 'acr-demo') {
                 customImage.push("${env.BUILD_NUMBER}")
                 }                     
           }
        }
	  }
    }
}
