# simple-wireguard-admin
A collection of a few scripts for easily managing wireguard from the command line. Just run these scripts to add/remove users to your existing wireguard set up.

### How to install:
1) Sign in as a user with sudo priveleges on the server running wireguard
2) Clone the repo and install qrencode:
```bash
git clone https://github.com/hgibs/simple-wireguard-admin.git
sudo apt install -y qrencode
```

#### Notes:
- This assumes your instance is running \*nix.
- These scripts assume your wireguard directory is /etc/wireguard

### How to use:
##### Add a new user:
`./create-key.sh [identifier]` i.e. `./create-key.sh [my-phone]`
