devops_day13.md

today's i am gonna more deep dive into ansible and today's session will be everything about ansible playbooks.

what i learned in previous were almost all the ad-hoc commands and those commands are mostly used for one timing only like just to check the status in instant, at that moment ad-hoc commmands(one timer command) are mostly used like to check the ping if happening or not or to check the disk storage of the system of the workernodes.

So, today's session is about playbooks where we can do multiple tasks and run that playbook and the task can be happened at once without any problem and if it occurs then will have to troubleshoot things.

So, I first created a directory in my home directory ie: "mkdir playbooks && cd playbooks && vim firstplaybook.yaml" and after that i create a firstplaybook.yaml and inside that it's known that whenever writing a playbook for ansible it always starts with "---" three dash/minus. and now i wrote a fully functional playbook and this looks like this:
---
- hosts: servers
  become_user: root

  tasks:
  - name: Create a directory
    file:
      path: /home/nixhal/first_playbook_dir
      state: directory
      owner: narendra
      groups: nixhal
      mode: '770'

  - name: Create an empty file
    file:
      path: /home/nixhal/first_playbook_dir/workernode1.txt
      state: touch
      owner: narendra
      groups: narendra
      mode: '700'

  - name: Copy the files from master-node to servers
    copy:
      src: /home/nixhal/meronepal.lyric
      dest: /home/nixhal/first_playbook_dir

here, every playbook starts as i already said with "---" identation and after that - hosts: servers declares that to which machine or group i am targeting too do the job/run playbook. Similarly, becomes_user: root is for the priviledged task like almost all the tasks are priviledged. and after that enter,1 space down i wrote the tasks:

tasks:
- name: Create a directory
  file:
    path: /home/nixhal/first_playbook_dir
    state: directory
    owner: narendra
    groups: nixhal
    mode: '770'

here, tasks is declared to show what kind of tasks i am gonna do like this and - name: is used to name the task just a short description of task that it is going to perform and file: is a module which is used to create a directory and empty files, ie it will create both a directory and a filename but state declares what kind of file will it become ie: directory/touch owner declares ownership and groups declares groupship of the directoy and mode: '770' declares the set of permission that directory is gonna get. that's all and main thing while writing a playbook is that identation is most important and always identation must be checked and for that there's a best command which is used to check if the syntax of the playbook is correct or not and i checked it using this command:
"ansible-playbook playbookname --syntax-check" ie: "ansible-playbook firstplaybook.yaml --syntax-check"
and if it returns playbook: firstplaybook.yml then the syntax of playbook is correct and no error is present there.

now to run the playbook i used this command: "ansible-playbook firstplaybook.yaml --become -K" but first there's a thing after having a playbook not a thing but a term called dry run which tells you that how much better your playbook runs or not. basically what dry run do is first it performs the task from the playbook and all the syntax, commands etc from the playbook are correct then it performs it successfully but that task through dry run is not actually made changes like it just for telling you that your playbook is elligible to perform tasks or not and if yes then it won't make a changes in actual system it just for check. 

So, I ran dry run of my firstplaybook.yaml using this command:
"ansible-playbook firstplaybook.yml --become -K -C" see the output ran easily:
nixhal@master-node:~/playbooks$ ansible-playbook firstplaybook.yml --become -K -C
BECOME password: 

PLAY [servers] ******************************************************************************************

TASK [Gathering Facts] **********************************************************************************
ok: [workernode1]

TASK [Create directory] *********************************************************************************
changed: [workernode1]

TASK [Create an empty file] *****************************************************************************
[ERROR]: Task failed: Module failed: Unsupported parameters for (file) module: groups. Supported parameters include: _diff_peek, _original_basename, access_time, access_time_format, attributes, follow, force, group, mode, modification_time, modification_time_format, owner, path, recurse, selevel, serole, setype, seuser, src, state, unsafe_writes (attr, dest, name).
Origin: /home/nixhal/playbooks/firstplaybook.yml:14:5
12       mode: '770'
13
14   - name: Create an empty file
       ^ column 5
fatal: [workernode1]: FAILED! => {"changed": false, "msg": "Unsupported parameters for (file) module: groups. Supported parameters include: _diff_peek, _original_basename, access_time, access_time_format, attributes, follow, force, group, mode, modification_time, modification_time_format, owner, path, recurse, selevel, serole, setype, seuser, src, state, unsafe_writes (attr, dest, name)."}
PLAY RECAP **********************************************************************************************
workernode1                : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=0  

ok here, let do the breakdown so what happened here is that here Module failed: Unsupported parameters for (file) module: groups. that means that as a group in my playbook i wrote groups instead of group so i fixed this parameter error inside my playbook and then i again did the dry run:

and this is the output:

nixhal@master-node:~/playbooks$ ansible-playbook firstplaybook.yml --become -K -C
BECOME password: 

PLAY [servers] ******************************************************************************************

TASK [Gathering Facts] **********************************************************************************
ok: [workernode1]

TASK [Create directory] *********************************************************************************
changed: [workernode1]

TASK [Create an empty file] *****************************************************************************
changed: [workernode1]

TASK [Copy the files from master-node to servers] *******************************************************
changed: [workernode1]

PLAY RECAP **********************************************************************************************
workernode1                : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

and this dry run is successful now so i now easily understood the job of dry run which is basically rather than applying changes it's better to check if there's any error in the playbook which we can find using the dry run so i can prevent the error from becoming to happen the production stage. and to do the professional changes or actually run the command on real state not a dry run then just removing the dryrun which is -C flag will do the job and now i ran without the dry run using this command:
"ansible-playbook firstplaybook.yml --become -K" and yeah i see all the changes ie tasks has been done by the ansible that were present in the firstplaybook.yml

and note: playbook extension are : ".yaml,.yml" both can run.

and yeah i ran this playbook by renaming the hosts to worker and then ran first dry ran and hitup with obvious error that user narendra isn't present in the worker group so i first created that user using ad-hoc command and then again but first had a dry run on it and then dry run ran successfully and then ran as root or say for save changes, and i see it became successfull.

similarly i practiced for playbooks for creating the users and groups and while creating before, there i used groups to save changes in tho the groups. basically i want to say that setting groups: groupname will set the existing group to the recent or any user if it's present there. simply to remove these user and groups, just need to put absent into the playbook file in the state:absent and start playbook and this will delete/remove the user/group.

and similarly for rsyincing a file/dir to another or other machine there's another module name and that is : 'synchronize'

after this i used a package installation using yaml uisng ansible and yeah i installed the file. then i got error and my package_installation.yml file like this:

---
- hosts: worker
  become: yes

  tasks:
  - name: Package Installation using yml
    apt:
      update_cache: yes

  - name: Package Upgradable Upgrading
    apt:
      upgrade: dist

  - name: Install Nginx Server
    apt:
      name: nginx
      state: present

  - name: Start & enable nginx services
    service:
      name: nginx
      state: started
      enabled: true

and the error is caused by package upgradable upgrading task as when i used apt: upgrade: dist this caused the entire system to upgrade the core linux files, all complicated python libraries and eventually later on caused to restart the ssh server or the entire system to reboot it. so so this caused the previous failure and after the system is started my worker, i again tried this command and yes the playbook ran successfully. 

damn i got to learn to many things using playbooks and damn this thing is going really deep in and i am having fun and error and problem solve. and yeah that's it for today's session. 