# Automatic Semantic Versioning

This container exposes a `calculate_semver` script that will automatically calculate the next incremental semantic version for a GitHub repository by analyzing the existing releases and the labels on pull requests closed since.

Expected Labels on Pull Requests:
- `patch`
- `minor`
- `major`

## Usage

To use, run the container with your github repository mounted to it (or using the `docker.inside` functionality in Jenkins) and just run `calculate_semver`. It will simply output the next semantic version that should be used.

** Jenkins Example: **

```js
withCredentials([usernamePassword(credentialsId: '<your_github_credentials_id>', passwordVariable: 'GH_TOKEN', usernameVariable: 'GH_USER')]) {
    withEnv(['GH_ORG=<your_github_org>', 'GH_REPO=<your_github_repo>']) {
        docker.image('laiello/automatic-semver:latest').inside('-u 0') {
            checkout scm
            NEXT_VERSION = sh (
                script: 'calculate_semver',
                returnStdout: true
            ).trim()
        }
    }
}
```

_Note: If using Jenkins, ensure that `Fetch Tags` is enabled._

## Required Environment Variables

** Human Defined: **

- `GH_ORG` - GitHub Organization
- `GH_REPO` - GitHub Repository
- `GH_TOKEN` - Used for reading the repository details

** Jenkins Provided: **

- `BRANCH_NAME` - Used in calculating the version (anything other than master gets a build version)
- `GIT_COMMIT` - Used in calculating build versions (automatically shortened to eight characters)
