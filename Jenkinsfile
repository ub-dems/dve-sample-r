pipeline {
  agent any {
    stages {
      stage('Setup') {
        steps {
          echo "%%> [setup] : create runtime container images "
          sh './build.sh setup'
        }
      }
      stage('Deps') {
        steps {
          echo "%%> [deps] : install dependencies from renv.lock snapshot "
          sh './runtime.sh R -e \'"renv::restore()"\' '
        }
      }
      stage('Build') {
        steps {
          echo "%%> [build] : devtoots::build() in runtime container"
          sh './runtime.sh build build'
        }
      }
      stage('Test') {
        steps {
          echo "%%> [test] : devtoots::tests() in runtime container"
          sh './runtime.sh build test'
        }
      }
      stage('Check') {
        steps {
          echo "%%> [test] : devtoots::check() in runtime container"
          sh './runtime.sh build check'
        }
      }
      stage('Pack') {
        steps {
          echo "%%> [pack] : pack project in local image"
          sh './worker.sh pack'
        }
      }
      stage('Push') {
        steps {
          echo "%%> [pack] : push project image to remote registry"
          sh './worker.sh push'
        }
      }
      stage('Docs') {
        steps {
          echo "%%> [docs] : process man, readme, vignettes in runtime container"
          sh './runtime.sh build docs'
        }
      }
      stage('Clean') {
        steps {
          echo "%%> [clean] : clean build intermediate files"
          sh './runtime.sh build clean'
        }
      }
    }
  }
}
