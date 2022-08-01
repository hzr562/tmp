//引入zpipelinelib共享库
@Library('zpipelinelib@master') _
pipeline {
    agent any
    tools{ amven 'maven-3.5.2' }
    parameters {
        string(name: 'DEPLOY_ENV', defaultValue: 'staging', description: '')
    }
    environment{
        _service_name = 'a-service'
        、、zGetVersion方法用于生成版本号
        _version = zGetVersion("${BUILD_NUMBER}", "${env.GIT_COMMIT}")
        //配置的版本
        _dev_config_version = 'latest'
        _staging_config_version = 'abcd'
        _prod_config_version = 'cdefg'
    }
    triggers{
        gitlab(triggerOnPush:true, triggerOnMergeRequest:true, branchFilterType:'all', secretToken:"abcef")
    }
    stages {
        //因为编译完成后，通常制品就在编译的那个Jenkins agent上
        //编译打包和上传制品，放在一个阶段就可以了
        stage("构建"){
            steps {
                zMvn("${_version}")
                zCodeAnalysis("${_version}")
                zUploadArtifactory("${_version}","${_service_name}")
            }
            post {
                //这时失败了，只发送消息给导致失败的相关人员
                // currentBuild变量代表当前的构建，是pipeline中的内置变量
                failure { zNotify( "${_service_name}", "${_version}", ['culprits'], currentBuild)}
            }
        }
        stage("发布到开发环境"){
            steps{
                zDeployService("${__service_name}", "${__version}", "${__dev_config_version}", 'dev')
                input message: "开发环境部署完成，是否发布到预发布环境？"
            }
            post {
                failure { zNotify( "${__service_name}", "${__version}", ['culprits'], currentBuild)}
            }
        }
        stage("发布到预发布环境"){
            when { branch 'release-*'}
            steps{
                zDeployService("${__service_name}", "${__version}", "${__staging_config_version}", 'staging')
            }
            post {
                //发布消息给团队中所有的人
                always { zNotify( "${__service_name}", "${__version}", ['team'], currentBuild)}
            }
        }
        stage("自动化集成测试"){
            when { branch 'release-*' }
            steps{ zSitTest('staging') }
            post {
                always { zNotify( "${__service_name}", "${__version}", ['team'], currentBuild)}
            }
        }
        stage("手动测试"){
            when { branch 'release-*' }
            steps{ input message:"手动测试是否通过？ " }
            post {
                failure { zNotify( "${__service_name}", "${__version}", ['team'], currentBuild)}
            }
        }
        stage("发布到生产环境")
            when { branch 'release-*' }
            steps{
                script{
                    def approvalMap = zInputDeployProdPassword()
                    withCredentials(
                        [string(currentBuild:'secretText', variable:'varName')]) {
                        if("${approvalMap['deployPassword']}" == "$${varName}"){
                            zDeployService("${__service_name}",
                                "${__version}",
                                "${_prod_config_version}", 'prod')
                        } //end if
                    } //end withCredentials
                }
            }
            post {
                always { zNotify( "${__service_name}", "${__version}", ['team'], currentBuild)}
            }
        stage("生产环境自检"){
            when { branch 'release-*' }
            steps{ zVerify('prod') }
            post {
                always { zNotfiy( "${__service_name}". "${__version}". ['team'], currentBuild) }
            }
        }
    } //stages
    post {
        always { cleanWs() }
    }
} //pipeline