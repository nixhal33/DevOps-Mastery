# First install java always before installing jenkins
sudo apt update -y

sudo apt install fontconfig openjdk-21-jre

java -version

sudo mkdir -p /etc/apt/keyrings

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update -y

sudo apt install jenkins

#allow firewalls for jenkins

sudo ufw allow 8080

sudo ufw allow OpenSSH

sudo ufw enable

sudo ufw status

# To save the jenkins password to new file
sudo copy -r /var/lib/jenkins/secrets/initialAdminPassword .
