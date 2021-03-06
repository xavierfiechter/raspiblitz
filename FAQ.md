# FAQ - Frequently Asked Questions

## How to update my RaspiBlitz (AFTER version 0.98)?

*Notice: Please be sure that your base image you started with was version 0.98 or greater. If you used the now deprecated XXupdateScripts.sh script to update before, you might have started with an older base image. If you never run that script, you're good.*

To prepare the RaspiBlitz update:

- main menu > OFF
- remove power
- remove SD card

Now download the new RaspiBlitz SD card image and write it to your SD card .. yes you simply overwrite the old one, it's OK, all your personal data is on the HDD (if you haven't done any manual changes to the system). See details about latest SD card image here: https://github.com/rootzoll/raspiblitz#scenario-2-start-at-home

If done successfully, simply put the SD card into the RaspiBlitz and power on again. Then follow the instructions on the display ... and dont worry, you dont need to re-download the blockchain again.

## How to update my RaspiBlitz (BEFORE version 0.98)?

You need to setup a new RaspiBlitz. So close all channels. Remove all funds from your Raspiblitz (cash-out). Go into terminal and run: `sudo /home/admin/XXleanHDD.sh` and then `sudo shutdown now`. This way you keep your blockchain data on the HDD, but your HDD is cleaned. Now follow again: https://github.com/rootzoll/raspiblitz#scenario-2-start-at-home

## Why do I need to re-burn my SD card for an update (AFTER version 0.98)? 

I know it would be nicer to run just an update script and you are ready to go. But then the scripts would need to be written in a much more complex way to be able to work with any versions of LND and Bitcoind (they are already complex enough with all the edge cases) and testing would become even more time consuming than it is now already. That's nothing a single developer can deliver. 

For some, it might be a pain point to make an update by re-burning a new sd card - especially if you added your own scripts or made changes to the system - but thats by design. It's a way to enforce a "clean state" with every update - the same state that I tested and developed the scripts with. The reason for that pain: I simply cannot write and support scripts that run on every modified system forever - that's simply too much work.

With the SD card update mechanism I reduce complexity, I deliver a "clean state" OS, LND/Bitcoind and the scripts tightly bundled together exactly in the dependency/combination like I tested them and its much easier to reproduce bug reports and give support that way.

Of course, people should modify the system, add own scripts, etc ... but if you want to also have the benefit of the updates of the RaspiBlitz, you have two ways to do it:

1. Contribute your changes back to the main project as pull requests so that they become part of the next update - the next SD card release.

2. Make your changes so that they survive an SD card update easily - put all your scripts and extra data onto the HDD AND document for yourself how to activate them again after an update. 

BTW there is a beneficial side effect when updating with a new SD card: You also get rid of any malware or system bloat that happened in the past. You start with a fresh system :)

## I have the full blockchain on another computer. How do I copy it to the RaspiBlitz?

Copying a already synced blockchain from another computer (for example your Laptop) can be a quick way to get the RaspiBlitz started. Also that way you synced and verified the blockchain yourself and not trusting the RaspiBlitz FTP/Torrent downloads (dont trust, verify).

One requirement is that the blockchain is from another bitcoin-core client with version greater or equal to 0.17.1 with transaction index switched on (`txindex=1` in the `bitcoin.conf`). 

But we dont copy the data via USB to the device, because the HDD needs to be formatted in EXT4 and that is usually not read/writeable by Windows or Mac computers. So I will explain a way to copy the data thru your local network. This should work from Windows, Mac, Linux and even from another already synced RaspiBlitz.

Both computers (your RaspberryPi and the other computer with the full blockchain on) need to be connected to the same local network. Make sure that bitcoin is stoped on the computer containing the blockchain. If your blockchain source is another RaspiBlitz run on the terminal `sudo systemctl stop bitcoind` and then go to the directory where the blochcian data is with `cd /mnt/hdd/bitcoin` - when copy/transfer is done later reboot a RaspiBlitz source with `sudo shutdown -r now`.

If everything of the above is prepared, start the setup of the new RaspiBlitz with a fresh SD card (like explained in the README) - its OK that there is no blockchain data on your HDD yet - just follow the setup. When you get to the setup-point `Getting the Blockchain` choose the COPY option. Starting from version 1.0 of the RaspiBlitz this will give you further detailed instructions how to transfere the blockchain data onto your RaspiBlitz. In short: On your computer with the blockchain data source you will execute SCP commands, that will copy the data over your Local Network to your RaspiBlitz. 

Once you finished all the transferes the Raspiblitz will make a quick-check on the data - but that will not guarantee that everything in detail was OK with the transfere. Check further FAQ answeres if you get stuck or see a final sync with a value below 90%.

## Why is taking my torrent download of the blockchain so long?

Its a lot of data and torrent seeds can not be garantuued. Normally it should be done within 24 hours. If it takes longer then 2 days consider to abort the torrent download by pressing 'x' and choose FTP download as fallback ... will also take some time, but should be more stable. If even that is not working - choose SYNC option, which will take over a week, but is the classic way to get the blockchain thru the bitcoin peer2peer network.   

## Why is my "final sync" taking so long?

First of all if you see a final sync over 90% and you can see from time to time small increase - you should be OK ... this can take some looong time to catch up with the network. Only in the case that you activly choose the `SYNC` option in the `Getting the Blockchain` a final sync under 90% is OK. If you did a torrent, a FTP or a copy from another computer and seeing under 90% somthing went wrong and the setup process is ignoring your prepared Blockchain and doing a full sync - which can almost take forever on a raspberryPi.

So if something is wrong (like mentioned above) then try again from the beginning. You need to reset your HDD for a fresh start: SSH in as admin user. Abort the final sync info with CTRL+c to get to the terminal. There run `sudo /home/admin/XXcleanHDD.sh -all` and follow the script to delete all data in HDD. When finsihed power down with `sudo shutdown now`. Then make a fresh SD card from image and this time try another option to get the blockchain. If you run into trouble the second time, please report an issue on GitHub.

## How to backup my Lightning Node?

CAUTION: Restoring a backup can lead to LOSS OF ALL CHANNEL FUNDS if it's not the latest channel state. There is no perfect backup solution for lightning nodes yet - this topic is in development by the community.

But there is one safe way to start: Store your LND wallet seed (list of words you got on wallet creation) in a safe place. Its the key to recover access to your on-chain funds - your coins that are not bound in an active channel.

Recovering the coins that you have in an active channel is a bit more complicated. Because you have to be sure that you really have an up to date backup of your channel state data. The problem is: If you post an old state of your channel, to the network this looks like an atempt to cheat, and your channel partner is allowed claim all the funds in the channel.

To really have a reliable backup, such feature needs to be part of the LND software. Almost every other solution would not be perfect. Thats why RaspiBlitz is not trying to provide a backup feature at the moment.

But you can try to backup at your own risk. All your Lightning Node data is within the `/mnt/hdd/lnd` directory. Just run a backup of that data when the lnd service is stopped.

## What is this mnemonic seed word list?

With the 24 word list given you by LND on wallet creation you can recover your private key (BIP 39). You should write it down and store it at a save place. 

For more background on mnemonic seeds see this video: https://www.youtube.com/watch?v=wWCIQFNf_8g

# How does PASSWORD D effects this seed?

On wallet creation you get asked if you want to protect your word seed list with an additional password. If you choose so, RaspiBlitz recommends you to use your PASSWORD D at this point.

To use a an additional password for your seed words is optional. If you choose so, you will need the password to recover your private key from your your seed words later on. Without this password your private key cannot be recovered from your seed words. So the password adds an additional layer of security, if someone finds your written down word list.

## How do I change the Name/Alias of my lightning node

Use the "Change Name/Alias of Node" option in the main menu. The RaspiBlitz will make a reboot after this.

## What to do when on SSH I see "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!"

This means, that he public ssh key of the RaspiBlitz has changed to the one you logged in the last time under that IP.

It's OK when happening during an update - when you changed the sd card image. If it's really happening out of the blue - check your local network setup for a second. Maybe the local IP of your RaspiBlitz changed? Is there a second RaspiBlitz connected? It's a security warning, so at least take some time to check if anything is strange. But also don't get to panic - when it's in your local network, normally it's some network thing - not an intruder.

To fix this and to be able to login with SSH again, you have to remove the old public key for that IP from your local client computer. Just run the following command (with the replaced IP of your RaspiBlitz): `ssh-keygen -R IP-OF-YOUR-RASPIBLITZ` or remove the line for this IP manually from the known_hosts file (see the path to the file in the warning message).

After that, you should be able to login with SSH again.

## When using Auto-Unlock, how much security do I lose?

The idea of the "wallet lock" in general, is that your private key / seed / wallet is stored in a encrypted way on your HDD. On every restart, you have to input the password once manually (unlock your wallet), so that the LND can read and write to the encrypted wallet again. This improves your security if your RaspiBlitz gets stolen or taken away - it loses power and then your wallet is safe - the attacker cannot access your wallet.

When you activate the "Auto-Unlock" feature of the RaspiBlitz, the password of the wallet gets stored on the RaspiBlitz. So if an attacker steals the RaspiBlitz physically, it's now possible for them to find the password and unlock the wallet.

## I connected my HDD but it still says 'Connect HDD' on the display?

Your HDD may have no partitions yet. SSH into the RaspiBlitz as admin (see command and password on display) and you should be offered the option to create a partition. If this is not the case:

Check/Exchange the USB cable. Connect the HDD to another computer and check if it shows up at all.

OSX: https://www.howtogeek.com/212836/how-to-use-your-macs-disk-utility-to-partition-wipe-repair-restore-and-copy-drives/

Windows: https://www.lifewire.com/how-to-open-disk-management-2626080

Linux/Ubuntu (desktop): https://askubuntu.com/questions/86724/how-do-i-open-the-disk-utility-in-unity

Linux/Raspbian (command line): https://www.addictivetips.com/ubuntu-linux-tips/manually-partition-a-hard-drive-command-line-linux/

## How do I shrink the QR code for connecting my Shango/Zap mobile phone?

Make the fonts smaller until the QR code fits into your (fullscreen) terminal. In OSX use `CMD` + `-` key. In LINUX use `CTRL`+ `-` key. On WINDOWS Putty go into the settings and change the font size: https://globedrill.com/change-font-size-putty

## Why is my bitcoin IP on the display red?

The bitcoin IP is red, when the RaspiBlitz detects that it cannot reach the port of bitcoin node from the outside. This means the bitcoin node can peer with other bitcoin nodes, but other bitcoin nodes cannot initiate a peering with you. Dont worry, you dont need a publicly reachable bitcoin node to run a (public) lightning node. If you want to change this however, you need to forward port 8333 on your router to the the RaspiBlitz. How to do this is different on every router.

## Why is my node address on the display red?

The node address is red, when the RaspiBlitz detects that it cannot reach the port of the LND node from the outside - when the device is behind a NAT or firewall of the the router. Your node is not publicly reachable. This means you can peer+openChannel with other public nodes, but other nodes cannot peer+openChannel with you. To change this you need to forward port 9735 on your router to the the RaspiBlitz. How to do this is different on every router.

## Why is my node address on the display yellow (not green)?

Yellow is OK. The RaspiBlitz can detect, that it can reach a service on the port 9735 of your public IP - this is in most cases the LND of your RaspiBlitz. But the RaspiBlitz cannot 100% for sure detect that this is its own LND service on that port - thats why its just yellow, not green. 
