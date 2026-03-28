day 12 on starting brand new topic with practical knowledge.

so i installed 3 vms with naming masternode as nixhal1 and workernode 1&2 as nixhal2 & 3. after installing vm i changed each hostname according to their purpose likewise i used here as masternode and workernode as it will be much better to distinguish my machines and the working purpose of their nature too.

so after that i also learned today that you don't exactly need an ip address to ssh into the computer. Basically, what i did was first i checked the ip address of workernode 1 & 2 and i took their ip both 1 & 2 and then i login into masternode and edited the hosts file ie: "sudo vim /etc/hosts" and then at last i put their ip address and i put their hostname ie:

127.0.0.1	localhost
127.0.1.1	Nixpc

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

192.168.1.11 	master-node
192.168.1.11 	www.web2.com

i saved it and checked it and tried to login using nixhal1@master-node and yeah i can login inside the masternode but the thing is ansible should be for automation and it's obvious that it will ask for password for ssh into the another machine. so basically now i need to do a passwordless ssh and to do that i need to create a sshkey for that passwordless entry into the system so what i did was first i checked if .ssh directory is present in the home directory or not and if not then i used this command "ssh-keygen" and yeah i see it's there i can see the files.

so after that what i did was first i get inside the file and see there's a file called id_ed24325 & id_ed23443.pub which is without pub is a private ssh key and with pub is a public ssh key. I also got an interesting fact about these ssh keys. cuz there's a two types of ssh keys ie: id_ed1234 & id_rsa whereas id_ed1243

Their key diffs are given below:

id_rsa: This is the older standard (RSA). It’s widely compatible with almost every system, even very old ones.

id_ed25519: This is the modern standard (Ed25519). It is:
    i.More Secure: Offers stronger security with a much smaller key size.
    ii.Faster: It connects and authenticates more quickly than RSA.
    iii.Default: Most modern versions of OpenSSH (since late 2023) now generate Ed25519 keys by default instead of RSA. 

with that said i restarted the ssh service and btw in centos it's sshd for the ssh service and in ubuntu it's ssh for the service name. ok now after this i copied that pub one and then pasted that key on my masternode inside the .ssh file and inside there was file called authorized_keys and inside the file i pasted the public key and restart and enabled both the system master and worker node1 and from worker node i tried to ssh without any password then ie: ssh nixhal1@master-node which i already set in /etc/hosts as : 192.168.1.11  	master-node (note: master-node is officially my masternode and it's the hostname of the master node too.) and i see boom the ssh login has been successfull without any password.

and then after that i installed ansible on my worker node as worker node is the one that must have ansible and master-node will control that ansible so it doesn't need to have ansible installed in it.

i dunno but today i literally got way too much confused with ansible and this ssh keys. first confusion was that to do ssh and that's basically passwordless ssh, that thing got me confused took me entire days to figure it out and another was that after installation of ansible, i need to create a "sudo vim /etc/ansible/hosts" and put the file as given below:
[groupname which can be anything]
master-node

doing this was a big mistake from my side because i haven't made changes in my masternode and this was stupid of me that i used this master-node inside the masternode i duno why i did that, probably i didn't got gist of it as per me. imma be more detail with my mistakes, i literally had no idea or gist of how ssh communication and password connection works and even though i somehow made that passwordless connection and somehow got ansible downloaded using ansible website and steps to download it all followed and downloaded and after there had to be ansible folder inside the /etc file but there wasn't i thought something is wrong but still i created the directory myself and vim hosts inside the directory and put the data inside the file ie:

[server]
master-node

matter of fact, i am inside the master node and my stupid ass thought this was good idea, how tf am i gonna do when i am giving my own name, as a master node i need to have the worker nodes and their hosts ie: vim /etc/hosts should be edited and given name as the workernodes hostnames and their ip address but i didn't do that and got a fatal error too. btw i also got three different vms and named as nixhal1 2 3 which is absolutely wrong as they all need to have a same name and i got confused and after some times, i asked for help with my instructur like i am doing these things wrong what exactly i need to do to correct my self?  He corrected me the entire things and then followed his every steps and things he told me.

so to correct the errors myself what i did are these things:
on first case, i deleted and removed all the vms that i previously created and created a new vms using same username as a nixhal and same password for each vms and their hostnames also set as master-node & workernode1&2 and that's how i first created vms. and after that i configured first the ssh of workernode1 and 2 what i did first was i grepped all the ip address of workernodes and then i copied their ip and hostname into the master node's "vim /etc/hosts" and i pasted their things like this: 
nixhal@master-node:~/.ssh$ cat /etc/hosts
127.0.0.1 localhost
127.0.1.1 nixhal

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

192.168.1.40 workernode1
192.168.1.49 workernode2

and like that i did in master nodes first and tried ssh first using passwd authentication and i passed on that thing but i def know that ansbile is an agentless ssh communication config tool and for that i must setup passwordless ssh login system and to do that i first created the pubkey of my master node using "ssh-keygen" and that's not needed when i checked inside my ".ssh/" directory which is basically on the home directory of my username ie: "cd /home/nixhal/.ssh" and inside there's a file called id_ed1244 & id_ed1244.pub. btw this id_ed is a modern day ssh key which is much more secure than the previous and traditional id_rsa & id_rsa.pub keys. so for passwordless ssh login, i copied my masternode ssh pub key to my workernode 1 and pasted inside the ".ssh/authorized_keys" file and saved it and restarted it and then i tried ssh but now without using full name i just used for ssh ie: "ssh workernode1" & "ssh workernode2" and boom yeah the passwordless ssh connection has been secured. and after that i went into my masternode and one thing that is true is that i got cleared on ssh section is that from master to worker as a masternode we are pushing the configuration to the worker nodes so the master node must have ansible installed otherwise it won't work and other worker nodes don't need the ansible as master is the one controlling all the configuration of these workernodes. After this i used ansible website to install the ansible according to their steps: 
    1. sudo apt update -y
    2. sudo apt install software-properties-common -y
    3. sudo add-apt-repository --yes --update ppa:ansible/ansible
    4. sudo apt install ansible -y

and ansible installed and after that i this time checked inside the /etc/ansible directory is made or not and there is indeed the directory present there so after that and btw the hosts file was already present there and i checked that host file and there were many more configs inside that hosts file and i didn't delete it, as i renamed that hosts to hosts.bak and kept inside the same directory and created a new hosts file ie: "vim hosts" and now inside that file i wrote this line:
    [server]
    workernode1 
    workernode2
and saved it and came to my working directory and tried to ping the worker vms to see the ping would work or not and i did that using this command : "ansible -m ping servers" and boom this time the application and the ping is 100% successful and this was the output too:

nixhal@master-node:~/.ssh$ ansible -m ping servers
[WARNING]: Host 'workernode1' is using the discovered Python interpreter at '/usr/bin/python3.12', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.20/reference_appendices/interpreter_discovery.html for more information.
workernode1 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.12"
    },
    "changed": false,
    "ping": "pong"
}
[WARNING]: Host 'workernode2' is using the discovered Python interpreter at '/usr/bin/python3.12', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.20/reference_appendices/interpreter_discovery.html for more information.
workernode2 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.12"
    },
    "changed": false,
    "ping": "pong"
}

and i think today's session, i got really confused and then all things cleared out and i am now kinda exhausted from today's session too. i think that's it for today's session and from tomorrow session, i will do further deep dive into the ansible.