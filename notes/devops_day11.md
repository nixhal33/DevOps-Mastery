day 11/13 of more deep dive into ansible

Ok so what i did was i setup my entire ansible nodes like masternode and workernodes and i took a break and later on for more practice i opened my system and i see something was not right. 

The correct hostname was not getting connected to vm even though ip and hostnames were both correct. But then i got hit with dynamic ip thing. This session i must say pure configuration settings session. And then i checked ip of my system and saw that dynamc ip thing has already started which was previously 39 as my masternode and workernodes were changed into 1.60 n 61. And then i got pissed like really pissed all the things are already done again i have to deal with this thing. And then i decided to set static ip and then i first removed whatever there was inside the directory netplan and there was that 50-init-cfg.yaml thing and i removed that thing and pasted another thing without doing anything like save changes using netplan like netplan generate and netplan apply. And yeah somehow the ip didn't work and i removed that file too that named i recently renamed new file to create a new network plan ie: 01-netcfg.yaml. this i duno didn't work and i also basically havent tried to apply changes using netplan too ie: netplan generate & netplan apply. and i got annoyed with this one. i turned my pc off for a while as it was also heating a bit much.

after my mind and my pc both cooled down and i checked why my pc got so much heated and i opened my pc cheked the ram consumption using: "free -mh" cmd and i see ram is totally empty and clear. after that i opened my vm both 3 vms master-node and workernodes1&2 and smth got in my mind like let me check the ram consumed by my each vms. and i saw that my each vms are taking 2 gb of memory which means 6gb are already eaten by my vm and now i first need to replinsh my ram for my host machine. so i set my main masternode vm to 1gb of ram and worker vms to 512mb of ram each and then i started my all vms and checked my free ram and this is the output:

               total        used        free      shared  buff/cache   available
Mem:           7.6Gi       3.9Gi       1.1Gi       2.0Gi       5.0Gi       3.7Gi
Swap:          3.8Gi       757Mi       3.1Gi

no my host system became bit faster. now another problem arised again. now what is that since i already deleted that netplan config from the /etc/netplan directory, and this is all in my master-node as i am trying to configure my master-node netplan. now i created a new file called 01-netcfg.yaml and put these words inside the fil:
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:
      dhcp4: no
      addresses:
        - 192.168.1.10/24   # Use .10 for Master, .11 for Worker1, .12 for worker2 etc.
      routes:
        - to: default
          via: 192.168.1.1 
      nameservers:
      addresses: 
        - 8.8.8.8 
        - 1.1.1.1
so here main thing most important is identation here, just a simple identation causes the config to get error and i also got error 2 times and both were involved in identation problem. so after this what i saved this config as it was correct config after 2 errors and saved it and then i checked it using ip a cmd to check the ip as it is saved or not and i see yes it's there as ip a showed. and now i already need to set static ip for each worker nodes too and that's what i did for both machines. saved it and all set. 

I also made save changes in my host system "/etc/hosts" and entered there my files as: 192.168.1.10  master-node and saved and also done similarly for my workernodes too. after that i restarted my ssh services for both my hosts and vms using "sudo systemctl restart ssh" and no error got and then i did ssh to my masternode first and i see this prompt: "nix@master-node password:" but my vm system username and hostname are "nixhal@master-node" so why did this happened i got confused, and as i already know there's isn't any user named nix whose hostname was master-node. but previously when i setup all the settings for my vm, everything went good and no error were occured why is that i got confused and i researched for a bit and then found out that that during my previous session, i was user as nixhal and the password was also same too and i got no problem while doing all this and then after that finally a perfect configuration has finally setup from my side all the problem arise and then today's session was bit problematic but yeah every problems were came out on my head and i can see why each and every errors i was getting on point and understood every errors too. and i have explained each errors too. 

after this i switched to nixhal user in my host system and then tried to login using ssh hostname of my vms and then guess what i was getting inside the vms without any password as in previous session i set my vms with my passwordless authentication as i already pasted my host pub key into my all vms and then as a nixhal user i can login into each vm using ssh without any password.

Even though i can do login and out easily there's still i felt a bit problem or say i don't want do that too like switch to nixhal user. so for that or to get rid of that what i did first was create a pub key by  being nix as a user and pasted that pub key into my each vms and it's all set and then i created a config file into my .ssh file ie: "vim /.ssh/config" and then i put these as a contents inside the config:
Host master-node
    HostName master-node
    User nixhal

Host workernode1
    HostName workernode1
    User nixhal

Host workernode2
    HostName workernode2
    User nixhal
inside my host nix user and then saved restarted ssh again and then now i tried ssh as nix ie: ssh master-node and boom now finally i see it's getting login without any password even as a nix now and after this i ssh into master-node, the first thing i did was to check as if ansible was pinging the worker nodes or not ie: 
"ansible -m ping servers" as i saved groupname as servers in "/etc/ansible/hosts" and i did ping but damn the ping wasn't happening. why is that i wasn't confused this time cuz the hostname as workernode1 & 2 ip are changed and set to permanent ip/static ip which is 11 and 12 so what i did after this ping is first i "sudo vim /etc/hosts" and there i see the hosts ip as "192.168.1.40 & 49" and i changed their ip to brand new static ip ie: 192.168.1.11 & 12 and saved it and then again i tried to ping again my workervms using my masternode vm ie: "ansible -m ping servers" and this was the output:


[WARNING]: Host 'workernode2' is using the discovered Python interpreter at '/usr/bin/python3.12', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.20/reference_appendices/interpreter_discovery.html for more information.
workernode2 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.12"
    },
    "changed": false,
    "ping": "pong"
}
[WARNING]: Host 'workernode1' is using the discovered Python interpreter at '/usr/bin/python3.12', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.20/reference_appendices/interpreter_discovery.html for more information.
workernode1 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.12"
    },
    "changed": false,
    "ping": "pong"
}

hell yeah now no more breakage during my work now i can finally work now. ok that's it for my session, I know i haven't deep dived into the ansible as it is much more important to have a stable system rather than getting problem on each and every road while configuring the ansible and learning it. now my system is fully stable, all ip's set to static, all pub key are passwordless ssh are happening without any problem now. I am all to set to fully deep dive into the ansible.