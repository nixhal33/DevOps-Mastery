devops_day12.md

Today's the day of learning finally deep diving into the ansible and after my entire setup is now stable i am going more into deep of the ansible. 

So, first thing first, i used this cmd "ansible -m ping servers" which pings my 2 workernodes and returns if the ping is connected or not. 

I ran command module to see the info about the workernodes or the machines that are related or comes under the servers group and to do that i did: ansible -m command -a "hostnamectl" servers and this command gave me the entire details related to the connected systems ie: workernodes 1 & 2. this was the result:

[WARNING]: Host 'workernode1' is using the discovered Python interpreter at '/usr/bin/python3.12', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.20/reference_appendices/interpreter_discovery.html for more information.
workernode1 | CHANGED | rc=0 >>
 Static hostname: workernode1
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: 7005e708cf964531956fa41cc3d8f8ec
         Boot ID: 77c9e4d78353441b80f862a89710d8b9
  Virtualization: vmware
Operating System: Ubuntu 24.04.4 LTS
          Kernel: Linux 6.8.0-106-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform
Firmware Version: 6.00
   Firmware Date: Thu 2020-11-12
    Firmware Age: 5y 4month 6d

and also to check what kind of os in remote machine i used this cmd ansible -m command -a "cat /etc/os-release" servers and this was the output
[WARNING]: Host 'workernode1' is using the discovered Python interpreter at '/usr/bin/python3.12', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.20/reference_appendices/interpreter_discovery.html for more information.
workernode1 | CHANGED | rc=0 >>
PRETTY_NAME="Ubuntu 24.04.4 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.4 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo

and now i changed a little bit in hosts file of the ansible as i changed the group for workernode 2 and set for the workernode2 as worker group name ie:
	[servers]
	workernode1

	[worker]
	workernode2

and i tried to ping it again using : "ansible -m ping worker" and i can see the output as ping was successful and tried to check my vm machine type like on which machine is my vm workernode is on using this cmd "ansible -m command -a "cat /etc/os-release" worker" and i see the output has shown me the system. 

and i tried another one that is if i want to get all the nodes details about their system or anything about my related nodes info the i used this command: 'ansible -m command -a "cat /etc/os-release" all' and despite of whatever the groupname of the system it will be shown if the ip and the system are connected on.

basically, this ansible -m commands are known as "AD-HOC" commands which is basically called one liner commands bascially we use this ad-hoc commands to test something like test anything in just a seconds like if want to check the ram consumption of my vms then i can hit immediately : 'ansible -m command -a "free -h" all' which will me show all the ram consumption of all the vms connected to my masternode and i can see and determine how many rams and vms are getting consumed in seconds.

so in ansible basically, there are two types of command system whereas ad-hoc commands are one timer commands or say one task commands and there another is a playbook which means multiple tasks at one time or multiple time.

and after this what i tried to do add the group into my all workernodes using this command
: ansible -m group -a "name=devops state=present" all and state=present means add group or make group and if instead of present if there's absent then that means delete or remove the group and while doing so i got error ie:
[ERROR]: Task failed: Module failed: groupadd: Permission denied.
groupadd: cannot lock /etc/group; try again later.

Origin: <adhoc 'group' task>

{'action': 'group', 'args': {'name': 'devops', 'state': 'present'}, 'timeout': 0, 'async_val': 0, 'poll': 15}

workernode2 | FAILED! => {
    "ansible_fact￼
￼
￼
￼
s": {
        "discovered_interpreter_python": "/usr/bin/python3.12"
    },
    "changed": false,
    "msg": "groupadd: Permission denied.\ngroupadd: cannot lock /etc/group; try again later.\n",
    "name": "devops"
}

which is basically a permission denied to make group and that's the reason to put the same password for all the vms. and to run this command as a root i used this command: nixhal@master-node:~$ ansible -m group -a "name=devops state=present" all --become -K

and i see the output as seen down below as devops as a group when i tried to see using it "ansible -m command 'cat /etc/group' all" and i saw there devops at below of the file and basically to create a user i used the same command: "ansible -m user -a "name=devops state=present" servers --become -K" and to check it again i used:
"ansible -m command -a "cat /etc/passwd" all" and i see that group is being made again.

and another command is that while creating a new user, to put that user into a existing groupname i used this command: "ansible -m user -a "name=narendra state=present groups=devops" all --become -K" and this devops group has been previously created by me already and i also saw that in servers group, there's workernode1 and that workernode's user narendra has been added to groups of devops. and to remove the user from the system using ansible ie used: "ansible -m user -a "name=devops state=absent" worker --become -K" and i saw that this command deleted the user from the worker as in previously i created devops for all groups that are in the ansible system. 

i even confirmed if the devops has truly removed from the group of worker using this command: "ansible -m command -a "id devops" worker" and it showed me error like nonuser exist and yeah it worked successfully.

now i am trying to copy the files from masternode and send it to workernodes ie: groupname with servers and worker
to do that i did this command: "ansible -m copy -a "src=/home/nixhal/meronepal.lyric dest=/home/nixhal" servers --become -K" and this was successful too.

and now to remove a file that i recently created i just need to put state=absent and the file will be removed. i used this command: "ansible -m file -a "path=/home/nixhal/meronepal.lyric state=absent" servers --become -K"

i also created a touch file and directory too using this command: ansible -m file -a "path=/home/nixhal/ansbile.txt state=touch" servers --become -K and here to simply to create a directory i just put directory instead of touch in the state.

btw all the files that had been created using this previous command, i checked by going into the worker nodes and i found out that those files were root accessed or say user and group ownership was both root. so to change full of that file i used this command below: "ansible -m file -a "path=/home/nixhal/ansible_file state=directory owner=narendra group=devops mode=750" servers --become -K "
lemme breakdown things here: so almost all the things here are same but here module to create a file is file that's why i wrote there ansible -m file and after that path i gave a path to to file of ansible_file to /home/nixhal and the state of that file would be a directory, after that i gave it's ownership to narendra who's already created as user in the server:workernode1 and groupship to devops and mode=750 is permission of that file named ansible_file would be 750:rwx,rx,-. and to simiply delete or remove this file just putting the state into absent would do the work.:"ansible -m file -a "path=/home/nixhal/ansible_file state=absent" servers --become -K"

now to install some packages using ansible, i used this command "ansible -m apt -a "name=nginx state=present" servers --become -K" and boom the service has been installed. 

ok today's session one of the main imp thing. i tried creating narendra user which i had been already created but still tried it again. it showed me success and then i tried creating narendra2 and now this time, it showed me changed, so the difference is that the thing which is already present or already done, like creating narendra username which has been already done literally while practicing before, the ansible output was like success that means things already been there or done there output will come like success but when i just created a new username like narendra2 then this time the ansible output was like changed which means when new things are actually done and successfull then the ansible output will be like shown as changed. There is also a color difference ie: green = work already done or present there, yellow = new changes has just been made,done,installed.
This thing is vvi too like this workflow in the ansible is also called idempotent. This entire workflow is also called idempotent.

i guess that's it for today's lesson and i just started deep diving into ansible and i feel like i am already reaching into the middle of the ocean of it. but anyway that's it for today's lesson tommorow i will more deep dive into playbooks and all.
