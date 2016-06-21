# Jenkins
Jenkins docker image extended from [jenkinsci/docker](https://github.com/jenkinsci/docker).

## Usage

```sh
docker run \
    -p 8080:8080 -p 50000:50000 \
    -v /your-local-folder:/var/jenkins_home \
    --name kndjenkins \
    konnektid/jenkins
```

## Additions
This image comes with a few additions on top of the Jenkins base image.

**Tools:**

- NodeJS 6
- Ansible

**Plugins:**

- Pipeline
- GitHub Authentication plugin
- GitHub Branch Source Plugin
- NodeJS Plugin
- Ansible Plugin
- embeddable-build-status
- ANSI Color Plugin
- Priority Sorter Plugin
