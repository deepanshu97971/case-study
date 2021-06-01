try{
    node{
        def mavenHome
        def mavenCMD
        def docker
        def dockerCMD
        def scannerHome
        def tagName = "1.0"
        
        stage('Preparation')
        {
            echo "Preparing Jenkins environemt"
            mavenHome = tool name: "maven3.8", type: 'maven'
            mavenCMD = "${mavenHome}/bin/mvn"
            docker = tool name: 'docker', type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'
            dockerCMD = "$docker/bin/docker"
            scannerHome = tool name: 'sonar'
        }
        
        stage('git checkout')
        {
           echo "Checking out the code from git repository..."
           git 'https://github.com/deepanshu97971/case-study.git'
        }
        
        stage('Build, Test and Package')
        {
            echo 'Build, Test and Package'
            sh "${mavenCMD} clean site package"
        }
        
        stage('Sonar Scan')
        {
            echo "Scanning application for vulnerabilities..."
            withSonarQubeEnv(credentialsId: 'sonar-key', installationName:'sonar')
            {
                sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=Test -Dsonar.projectName=Test -Dsonar.projectVersion=1.0 -Dsonar.sources=/var/lib/jenkins/workspace/$JOB_NAME/src -Dsonar.host.url=http://34.136.243.113:9000 -Dsonar.language=java -Dsonar.java.binaries=target"
            }
        }
        
        stage('publish report')
        {
            echo "Publishing HTML report for test cases.."
            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/case-study/target/site', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: ''])
        }
        
        stage('Build Docker Image')
        {
            echo "Building docker image for application"
            sh "${dockerCMD} build -t deepanshu97971/case-study:${tagName} ."
        }
        
        stage("Push Docker Image to DockerHub")
        {
            echo "Pushing image to docker hub"
            withCredentials([usernamePassword(credentialsId: 'dockerHubPassword', passwordVariable: 'dockerPasswd', usernameVariable: 'dockerUser')])
            {
                sh "${dockerCMD} login -u ${dockerUser} -p ${dockerPasswd}"
                sh "${dockerCMD} push deepanshu97971/case-study:${tagName}"
            }
        }
        
        stage('Deploy Application')
        {
            echo "Installing desired softwares.."
            echo "Bring docker service up and running"
            echo "Deploying application"
            ansiblePlaybook credentialsId: 'ssh', disableHostKeyChecking: true, installation: 'ansible 2.9.21', inventory: '/etc/ansible/hosts', playbook: 'deploy-playbook.yml'
        }
        
    }
}

catch(Exception err)
{
    echo "Excpetion occurred"
    currentBuild.result = "FAILURE"
}

finally
{
    echo 'Sending email with build status'
    emailext attachLog: true, body: '$DEFAULT_CONTENT', subject: '$DEFAULT_SUBJECT', to: '$DEFAULT_RECIPIENTS'
}
