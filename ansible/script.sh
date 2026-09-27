# 1. Clean any existing ~/.ssh folder and generate a fresh key file
rm -rf /home/ansible/.ssh
mkdir -p /home/ansible/.ssh
chmod 700 /home/ansible/.ssh
#sudo apk add --no-cache sshpass



ssh-keygen -t rsa -b 2048 -N "" -f /home/ansible/.ssh/id_rsa
chmod 600 /home/ansible/.ssh/id_rsa
sudo apk add --no-cache sshpass
for i in $(seq 1 3); do
  echo "Copying SSH key to debian$i..."
  sshpass -p "ansible" ssh-copy-id -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ansible@debian$i
done

# 2. Distribute the public key to all 10 target nodes
for i in $(seq 1 10); do
  echo "Distributing key to target$i..."
  sshpass -p "ansible" ssh-copy-id -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ansible@target$i
done
