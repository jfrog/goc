node {
    cleanWs()
    subject = 'jfrog'
    repo = 'goc'
    sh 'rm -rf temp'
    sh 'mkdir temp'
    def goRoot = tool 'go-1.11'

    dir('temp') {
        gocWorkspace = pwd()
        stage('Clone') {
            sh 'git clone https://github.com/jfrog/goc.git'
        }
        stage('Go Install') {
            dir("$repo") {
                withEnv(["GO111MODULE=on", "GOROOT=$goRoot", "GOPATH=${gocWorkspace}", "PATH+GOROOT=${goRoot}/bin", "JFROG_CLI_OFFER_CONFIG=false"]) {
                    sh 'go version'
                    sh 'go install'
                    sh 'jfrog -version'
                    print "Publishing version: $version"
                    publishGocVersion()
                }
            }
        }
    }
}

def publishGocVersion() {
    def architectures = [
            [pkg: 'goc-linux-386', goos: 'linux', goarch: '386', fileExtention: ''],
            [pkg: 'goc-linux-amd64', goos: 'linux', goarch: 'amd64', fileExtention: ''],
            [pkg: 'goc-mac-386', goos: 'darwin', goarch: 'amd64', fileExtention: ''],
            [pkg: 'goc-windows-amd64', goos: 'windows', goarch: 'amd64', fileExtention: '.exe']
    ]
    for (int i = 0; i < architectures.size(); i++) {
        def currentBuild = architectures[i]
        stage("Build and Upload ${currentBuild.pkg}") {
            buildAndUpload(currentBuild.goos, currentBuild.goarch, currentBuild.pkg, currentBuild.fileExtention)
        }
    }
}

def uploadToBintray(pkg, fileName) {
    sh """#!/bin/bash
        jfrog bt u $gocWorkspace/$repo/$fileName $subject/$repo/$pkg/$VERSION /$VERSION/$pkg/ --user=$USER_NAME --key=$KEY
    """
}

def buildAndUpload(goos, goarch, pkg, fileExtension) {
    sh "GOOS=$goos GOARCH=$goarch GO111MODULE=on go build"
    def fileName = "goc$fileExtension"
    uploadToBintray(pkg, fileName)
    sh "rm $fileName"
}