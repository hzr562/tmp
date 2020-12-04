pipeline {
    //日照港开发环境
    agent any

    environment {
        rzg_ems_frontend_git = 'git@172.17.34.3:rzg-platform/integrated-services/protal-group/example-group/rzg-example-frontend' 
        rzg_ems_gitid = '9f36fcfc-702f-4495-a6e3-6f9e0d8f813e'  
    }



    options{
        retry(2) 
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 2, unit: 'HOURS') 
    }

    stages {
        stage('清理旧构建') {
  
            steps {
                sh 'printenv'
                cleanWs() 

            }
        }

        stage('拉取最新前端代码') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: "*/master"]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'CleanBeforeCheckout']], submoduleCfg: [], userRemoteConfigs: [[credentialsId: "${rzg_ems_gitid}", url: "${rzg_ems_frontend_git}"]]])

            }
        }
       
        stage('更新依赖') {



            steps {

            dir ( "${env.WORKSPACE}" ) {

                sh '''
                npm config set disturl https://mirrors.huaweicloud.com/nodejs
                npm config set sass_binary_site https://mirrors.huaweicloud.com/node-sass
                npm install --registry=https://mirrors.huaweicloud.com/repository/npm/
                '''
            }

        }
        }

        stage('开始编译') {

            steps {

            dir ( "${env.WORKSPACE}" ) {

                sh '''
                    npm run prod
                '''
            }

        }
        }
    

        stage('更新到开发前端') {

            steps {

            dir ( "${env.WORKSPACE}" ) {

                sh '''
                      yes 2>/dev/null | sudo cp -rf dist/*    /usr/share/nginx/example
                '''
            }

        }
        }

    }




}

