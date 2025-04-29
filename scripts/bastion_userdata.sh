# scripts/bastion_userdata.sh
#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y docker.io mysql-client awscli
sudo systemctl start docker
sudo systemctl enable docker