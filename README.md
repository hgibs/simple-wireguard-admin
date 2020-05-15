# simple-wireguard-admin
A collection of a few scripts for easily managing wireguard from the command line. Just run these scripts to add/remove users to your 
existing wireguard set up.

### How to install:
1) Sign in as a user with sudo priveleges on the server running wireguard
2) Clone the repo and install qrencode: (you can copy and paste this)
```bash
git clone https://github.com/hgibs/simple-wireguard-admin.git
cd simple-wireguard-admin
cp config.cfg.defaults config.cfg
sudo apt install -y qrencode
```
3) Edit the `config.cfg` file to match your set up.
4) Review all the scripts and ensure they don't do anything bad! You should never run scripts you find on the internet willy-nilly, 
especially ones you run as root. i.e. `cat *`

#### Notes:
- Please have `SaveConfig = true` enabled in your wg0.conf
- This assumes your instance is running \*nix.
- This does not re-use IP addresses after they are removed, if you plan on adding more than 9999 clients before resetting and
creating a new configuration, I'd recommend using a different, more fully featured set up.
- You're required to use IPv4 and IPv6 addresses on your routed VPN, get with the times!

### How to use:
##### Add a new user:
`./create-key.sh [identifier]` i.e. `./create-key.sh [my-phone]`
