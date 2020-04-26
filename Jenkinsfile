pipeline {
    agent any

    environment {
        rzg_ems_frontend_git = 'git@172.17.34.3:rzg-projects/ems/web/rzg-ems-frontend.git' 
        rzg_ems_gitid = '9f36fcfc-702f-4495-a6e3-6f9e0d8f813e'  

    }

    options{
        retry(1) 
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 2, unit: 'HOURS') 
    }
    parameters {
    //choice(name: 'path_ems2', choices: '/usr/share/nginx/html\n/usr/share/nginx/html_energy\n/opt/test', description: '前端目录地址')
    choice(name: 'host', choices: '172.18.20.76', description: '选择需要部署的主机')

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

            dir ( "${env.WORKSPACE}/rzg-ems-frontend/" ) {

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

            dir ( "${env.WORKSPACE}/rzg-ems-frontend/" ) {

                sh '''
                    npm run prod
                '''
            }

        }
        }
        






        stage('更新到开发前端') {

            steps {

            dir ( "${env.WORKSPACE}/rzg-ems-frontend/" ) {

                sh '''
                      yes 2>/dev/null | sudo cp -rf dist/*   /usr/share/nginx/html
                '''
            }

        }
        }





    }




}
