today's session about ssh.

so what i am learning this are as below

basically ssh means secure shell where we can do remote login to other computers using the ssh service. if we have ip address of the any remote computer and their password then we can login into that remote system with ease. btw i already know about the ssh as i have already learned bout it but yeah practice makes man perfect so why not again this will boost my skills and again from today's session i will gain more new knowledge from it. 

first i have to install the ssh service and to install the ssh i used : "sudo dnf install openssh-server -y" and this -y flag will install all the related dependencies to openssh without any question asked. and now first to check if the installation is happened or not i grepped the service using: "rpm -qa | grep openssh" whereas rpm -qa will list all the package and grep will grab only the openssh naming on the service. so after that i checked the service status using: "systemctl status sshd" and reminder sshd is the service name for the openssh.

i started it using: "systemctl start/enable sshd" and enabled it. and i can see the service has started.

now what i did after that is try to login the remote computer or say my host computer from my system: my vm is centos9s and from my vm i tried to gain access of my host computer ie: "ssh username@ipaddress" eg: "ssh nixhal@192.168.100.10" and it will ask me for the password for the host computer and i entered the passwd and gain the access of my host system using the vm system. and similarly we can do the same using the host system to vm system and vice versa. i did it same and became successful without any problemo.

now after that i came up with the configs of sshd and the file was "vim /etc/ssh/sshd_config" and there so many words there like all were commented out now i can even login as a root of my host system but only if the rootpermitlogin is written as yes then i can and if not then i can't get the access as root and i can even allow to set specific no. of users who can access the system and on.

ie: i used "allowusers nixhal devops broadway" which shows that only these users can access the system and if the "permitrootlogin yes" written in the config then these users if known the root passwd then they can even gain the root access of the system. and similarly i can even set the number of groups that can access the system for that the config should be written as : "allowgroups redhat blackhat" which i have created inside my vm system.

and main important thing: always restart the sshd services if there's any changes has been made inside the config or any config of the services to have them work as you want like after adding these rules in the config, i restarted the services: "systemctl restart sshd" and this restarted the system and i can see the rules has been applied successfully.

also found out that in ubuntu system like linux mint flavor, here while creating user ie: useradd nixhal won't create the directory for the nixhal user and will provide only shell for login, so to even give home directory, we have to give useradd -m nixhal and then only user directory will be given to user and also to change the shellinto bash shell, vi into etc file and simply change that sh into bash and save it and now can login as bash shell.

===================================================================================================================

day 7 of more deep diving into the ssh.

so what i did today from where i am starting is that i added now a username with ip address on it. ie : allowusers neha@192.168.xxx.xxx from this now only or any remote machine can acess neha user in host. whereas username is the user from host machine but ip address is from the remote machine which means only that the remote machine can access the host machine user named neha with remote machine ip as this :192.168.xxx.xxx

so also learned that if Put *@192.168.1.0/24 given in allowusers then this will give access to those network that comes from 1to255 or how much it accepts universally. and yeah this is basically one of the most of the important config rules mostly used in ssh. and through this i can access all the users in the host machine through remote machine.

also from today's session i got to know that we devops mostly work on cloud and while doing ssh, we don't in most of the cases don't get provided with the passwords so we need to make some configs into the ssh configs. like we in cloud do almost all the works in automation so for that asking password is also kinda hindrance to the automation process but that doesn't mean we change the configs like there's one rule where it says nopassword to login we shouldn't use that but insted there's a key which is known as private and public ssh key. where private key is the key that only contain whereas public key means all the other public can get access to those keys.

so to create this ssh key i am using the cmd: ssh-keygen

==================================================================================================================

Day 8: today i didn't go on with my syllabus. today from my instructor, i got informed that i should use vmware workstation pro as for better vm usage and grow my skills more. meanwhile i was working on downloading the vmware workstation pro, i will also provide the short guidance to download this vmware too for other's easiness if they were to ever know to how to install vmware for free. btw i came up too many errors. but first i created a account for broadcom support portal where i created id and login there. or just simply follow the bulleted list from this link: "https://www.configserverfirewall.com/ubuntu-linux/install-vmware-workstation-linux-mint-22/" here contains detailed way to install vmware. but in my case, i did all the things to install the vm but my kernel was too new for the vmware to work on it. so after all i found, main error was my kernel which was too new for the most of the vmware workstation. so i later on researched and found that 6.17 is on the experimental state and is kinda unstable so i decided and got recommended to boot my system on 6.8.0.101 generic version so i did that while booting state, i stopped booting process and selected advanced option for linux mint and selected the booting kernel: 6.8.0.101 generic version and booted my system. and after that i first removed everything so i don't get problem later so to remove the vm previous installation: i did this: "sudo vmware-installer -u vmware-workstation" cmd and press yes to remove all the previous installation. so after that i installed it again on my system, and after that i installed important tools for guest editions: "sudo apt install build-essential dkms linux-headers-$(uname -r) -y" and it's further needed dependencies for module build: "sudo vmware-modconfig --console --install-all" and yeah boom vm installation also completed no that long error of very new linux kernel as i have already booted it up with 6.8.0.101 generic version. now one thing is still remained as i wanted this version 6.8.0.101 version to boot up everytime i start the system so to make that possible :
1. sudo nano /etc/default/grub : i edited the grub menu here.
2.	GRUB_DEFAULT=saved
	GRUB_SAVEDEFAULT=true
	GRUB_TIMEOUT=5
	Here, first lines from there i edited this line in the grub file.

3. sudo update-grub : updating the grub menu
4. i removed the previous latest linux kernel 6.17.0.14 generic: "sudo apt remove linux-image-6.17.0-14-generic"
and then it's header files "sudo apt remove linux-headers-6.17.0-14-generic"and to get it remove completely from my system "sudo apt autoremove" and updating the grub menu "sudo update-grub" and reboot the system "sudo reboot"
and after that while boot menu came up i selected the 6.8.0.101 for my vmware configuration stabaliztion from the advanced menu and yeah i selected and from onwards whenever i start my system, it's gonna permanently boot from the kernel that i wanted.

now i am currently installing new vm ubuntu latest desktop version 24 and for today's session and due to vagrant related frequent errors i wasn't able to post these 2 days constantly as it was draining me mentally. but now i am decided i am the one who runs the house so i decied to change the party and go back to how before i learned the linux in my before system. so this much for today.

