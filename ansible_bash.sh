# Install Ansible
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible

# Install python and dependencies
sudo apt install python -y
sudo apt install python-pip -y
sudo pip install --upgrade pip -y

# Installing
pip3 install awscli # aws command line interface ----> allows us to
sudo pip install boto -y
sudo pip install boto3 -y
