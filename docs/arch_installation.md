# Arch Installation

## Step 1: Connect to WiFi
1. `iwctl`
2. `station wlan0 get-networks`
3. `exit`
4. `iwctl --passphrase "{{passphrase}}" station wlan0 connect {{wifi-network}}`
    * **Note:** Replace `{{passphrase}}` and `{{wifi-network}}` with your actual WiFi credentials

## Step 2: Enable SSH
1. `systemctl status sshd`
2. If not active: `systemctl start sshd`
3. `passwd`
