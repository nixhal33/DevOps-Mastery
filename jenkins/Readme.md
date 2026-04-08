markdown

# 🚀 Jenkins Practice & CI/CD Lab

This folder contains all my hands-on practice for Jenkins. I'm using this to learn how to automate builds and deployments for my Java/React apps.

## 📁 What's Inside?

*   **Pipeline Scripts (`/pipelines`)**: My `Jenkinsfile` examples using Groovy (Declarative style).
*   **Docker Integration**: How I build images and push them to Docker Hub using Jenkins.
*   **Multi-Stage Builds**: Practices on keeping images tiny during the CI/CD process.
*   **Scripts**: Shell scripts used inside Jenkins stages for cleanup and testing.

## 🛠 Project Workflow

1.  **Code**: Write code on my host machine and push to GitHub.
2.  **Trigger**: Jenkins detects the push (via Webhooks or Polling).
3.  **Build**: Jenkins spins up a container, runs `npm install` or `maven build`.
4.  **Test**: Running unit tests automatically.
5.  **Deploy**: If everything is green, Jenkins deploys the app to my EC2/VM.

## 📝 Key Concepts I've Mastered

- [x] **Jenkins Installation**: Setting it up on Linux/Docker.
- [x] **Plugins**: Installed Docker, GitHub, and Pipeline plugins.
- [x] **Credentials**: Managing DockerHub/AWS keys safely in Jenkins.
- [x] **Blue Ocean**: Visualizing the pipeline steps.

## 🚀 How to Run
1. Open Jenkins Dashboard.
2. Create a "New Item" -> "Pipeline".
3. Point the "Pipeline Script from SCM" to this GitHub repo.
4. Hit **Build Now**.

