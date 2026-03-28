devops_day14.md

Today's another day of deep diving into ansible so what i did today was first i created a playbook called filetar.yml and then i created yml file which first copies my directory named songlyric to all nodes and then archive those files into new tar file named lyrics.tar

---
- hosts: all
  become_user: root

  tasks:
  - name: Copy files to worker nodes
    copy:
      src: /home/nixhal/songlyric
      dest: /home/nixhal
      owner: nixhal
      group: narendra
      mode: '770'

  - name: Archive files
    archive:
      path: /home/nixhal/songlyric
      dest: /home/nixhal/lyrics.tar

  - name: Unarchive files
    unarchive:
      src: /home/nixhal/lyrics.tar
      dest: /home
      remote_src: yes
    tags:
    - unarchive

from this playbook, what i first did is order commands to all hosts that are there in the groups of ansible, ie workernodes1&2 and as a root and then according to first task, i ordered it to copy and btw i forgot to give the module named copy as i tried to check it's syntax and i checked again and module was missing as to copy and i corrected that error after that i gave src and dest to copy what files with their required ownership too and today new module has been added into my playbook ie: archive and for that first i gave path of that file that i want to archive and dest to my remote machines by lyrics.tar and now to extract that archive i used another module called unarchive which is to unarchive the where src and dest are given.

but in unarchive there's a catch and what's that is src and dest declares the source and destination of any file that i want to do but ansible here acts as src and dest master-node to workernodes 1 & 2 as i given hosts to all. but what i really want to do is the file that i previously created tar file called lyrics.tar into the remote machine i want to extract that file into those all remote machine not from master to worker. so basically what i am trying to do is extract those files from remote to remote machine to their respective directories as all things are same.

so what i used at last of those source and dest is remote_src: yes and now this line will tell ansible that both files that i am taring ie: src and dest are both in remote machine so do that.

and another thing main important thing is that whenever i run this command : "ansible-playbook filetar.yml --become -K -C" the ansible always run in sequential way like first it gets if all nodes are reachable or not, and performs first task, second and finally 3rd one but i already ran this command and this first 2 tasks has already been done by me and it's kinda hassle to run again same task which already been happened and now the thing is now if i want to run only specific task inside the playbook contents like other or specific one kind of task then what i can use is i create a new line called tag and place one task name like i want to unarchive only the file from remote to remote machine to their own directory so that's the thing i only want so to do that i do this :

tags:
- unarchive

and to run this only task from my playbook i use this command:
"ansible-playbook filetar.yml --become -K --tags unarchive" and this will only do the task 3 which is to unarchive from the playbook.

nixhal@master-node:~/playbooks$ ansible-playbook filetar.yml --become -K --tags unarchive
BECOME password: 

PLAY [all] ***************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************
ok: [workernode1]
ok: [workernode2]

TASK [Unarchive files] ***************************************************************************************************
changed: [workernode2]
changed: [workernode1]

PLAY RECAP ***************************************************************************************************************
workernode1                : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
workernode2                : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


and today i tried this too:
The Problem
Ansible was failing with a "Missing sudo password" error. Even though you edited visudo, the worker nodes were still demanding a password because your new rule was being overwritten by default system rules (like the %sudo group) located further down in the file.

The Fix
Remote Configuration: You applied the visudo change to the Worker Nodes, not just the Master.

Rule Priority: You moved the line nixhal ALL=(ALL:ALL) NOPASSWD:ALL to the absolute bottom of the file.

Command Cleanup: You removed the -K flag from your Ansible command, allowing it to use your "No Password" rule instead of manually prompting you.

The Result
The system now reads your rule last, which gives it the final authority. Now, sudo whoami returns root instantly, and Ansible can automate your tasks without ever stopping to ask for a password.

after that i also tried running my previous command ansible-playbook filetar.yml --become now no --ask-password/-K
entered and yeah boom i got it. it ran without any password and now finally i can say this is true automation now.

now another thing from same playbook i added new module called fetch which is also known as reverse copy ie: from worker machine to master machine where i am basically copying or transfering files from remote machine to my master machine. and there's a catch about this fetch module. it's still present that current or latest version of ansible doesn't allow the master to direct fetch the entire directory or its inside contents. if it's for a single file then it allows but a whole directory is not allowed here.
This is my task for fetching file from worker to master
- name: Copying or Fetching from workernodes to masternode
  fetch:
    src: /home/nixhal/lyrics.tar
    dest: /home/nixhal
    flat: yes
  tags:
  - fetch

so i ran this task and it ran successfully but the thing is after i ran this task, i got entire directory of that lyrics.tar like /home/nixhal/lyrics.tar which my workernode name is workernode1 & 2 so this reverse copied entire directory of my workernodes so this is a normal behaviour of ansible as it is trying to be protective of hte paths and places so that they don't conflict the directory paths from other servers like we are fetching from more than 10 servers, this behaviour of ansible will help to protect the directory, file and they won't overwrite each other in the master node and this protects from directory mismatch and file corruption.

and i added new line below dest called flat: yes which secures that i only want this lyrics.tar file from that source location to my destination. and btw even though i added this line i got error like lil bit huge error like  
TASK [Copying or Fetching from workernodes to masternode] ***********************************************
[ERROR]: Task failed: dest is an existing directory, use a trailing slash if you want to fetch src into that directory
Origin: /home/nixhal/playbooks/filetar.yml:27:5

25     - unarchive
26
27   - name: Copying or Fetching from workernodes to masternode
       ^ column 5

fatal: [workernode2]: FAILED! => {"changed": false, "msg": "dest is an existing directory, use a trailing slash if you want to fetch src into that directory"}
fatal: [workernode1]: FAILED! => {"changed": false, "msg": "dest is an existing directory, use a trailing slash if you want to fetch src into that directory"}

so basically,i don't actually have an error but it just telling me give the exact location to where reverse copy my file like in my dest: /home/nixhal here i didn't gave '/' sign which means copy to my nixhal/ location and i added this / to my playbook and then it again started running without any problem. so this is basically vvi as almost all the playbooks i have practiced till now i didn't gave this / sign. basically this is:
 The "Flat" Rule & The Trailing Slash:
When using flat: yes to fetch a specific file, Ansible requires precise destination paths. If the dest is a directory, I must use a trailing slash (/). Without it, Ansible fails because it can't distinguish if the destination is intended to be the new filename or an existing folder. This is different from standard tasks where Ansible handles the path creation automatically.

and to get rid of that directory direct copy not being allowed, taring is mostly used like tar the multiple files into single chunks and then reverse copy to my master node.

after that i practiced for the file timestamp like giving a professional timestamp while doing backups this thing help to show when the files were exactly backup being made or smth. so to put the timestamp for the the tar file that is being reverse copied i used this in my playbook.:

 dest: "/home/nixhal/lyrics_{{ ansible_date_time.date }}_{{ ansible_date_time.hour}}-{{ ansible_date_time.minute }}.tar
This line gave me the whole time stamp of the tar file when it's been copied entire date,hour & minutes.


and after this i learned to create a symlink for a file but the module was same as used in file where i simply gave the source and destination of the filder which is both in a remote machine but only giving src and dest will make ansible to think that i meant to copy the file from src to dest but i want to create a symlink so what i did is to put a new line called state: link ie:
 - name: Create a symlink
    file:
      src: /home/nixhal/mohabatte.lyric     
      dest: /hindi-song.lyric
      state: link

so yeah this line also added to my filetar.yml playbook now and successfully executed and btw i got one error for workernode2 and it was simple error basically as i set my playbook for all hosts the worker host doesn't have the file that i wanted to link and that's not an error but a just a warning that file didn't created because it doesn't exist so i got that error and just got to know this error hits up if things doesn't happen to be in the directory. 

i also learned new module called lineinfile ie:  
---
- hosts: all
  become_user: root

  tasks:
  - name: Add new content into a file
    lineinfile:
      path: /etc/hosts
      line: '192.168.1.120    www.narendra.com'

this playbook and the module added me a the line to the path: /etc/hosts and that will bee added at last of the line. and this will be added to the end of the line and also if i want to add the line named '192.168.1.121    www.nix.com' to any line but to insertafter to any other line ie: "127.0.1.1" then this line which i added will be added right after the 127.0.1.1 .

and i also learned to replace module to replace the text in the file and it was like this:
  - name: Replace content
    replace:
      path: /etc/hosts
      regexp: '192.168.1.121'
      replace: '192.168.1.20'
    tags:
    - replace
and this thing here, replace module helps to replace the contents and first have to give path and regularexpression(regexp) will search for content into the file and replace will replace the word into the file.

and i guess this is my wrapup for today's session. learned a lot about different modules and checked errors and fixed errors from today's session. that's it for today's session i guess thanks.
