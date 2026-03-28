devops_day16-17.md

yesterday, this is how i used loops and this was the example for it:
  tasks:
  - name: Create groups using loop
    group:
      name: "{{ item.name }}"
      state: "{{ item.state }}"
    loop:
    - name: bam
      state: present
    - name: nagar
      state: present
and today i am gonna use next type of loop or say another way to use the loop which will gonna be much more efficient and easy to use. although this is not so hard to use but still 

so what i just learned today is that i copied multiple files using loops and items and also i got to know how to use astericks which copies related to the name or words of their own ie: lyrics_* and it copies all files related to lyrics_jalksdf,lyrics_lkadfl etc all. and got to know this that using this asterisk module which uses new module called: fileglob:
			   - "/path/to/file" this can't be used in loops as this confuses the loop to which pritorize the files and this causes the error in the file.

to copy files i used this playbook :
~/playbooks/var_loops$ cat copy.yml 
---
- hosts: all
  become: yes

  tasks:
  - name: Copy files using loops
    copy:
      src: "{{ item.src }}"
      dest: "{{ item.dest }}"
      owner: "{{ item.owner }}"
      group: "{{ item.group }}"
      mode: "{{ item.mode }}"
    loop:
    - src: /home/nixhal/cmpunk_cop.lyric
      dest: /devops
      owner: nixhal
      group: narendra
      mode: '700'
      
    - src: /home/nixhal/warpigs.lyric
      dest: /devops
      owner: nixhal
      group: root
      mode: 555


and to use that wildcard function i created a new playbook for that to run:
---
- hosts: all
  become: yes

  tasks:
  - name: Copy bulk lyrics using fileglob or say direct cp using *, copies all items related to lyrics_*
    copy:
      src: "{{ item }}"
      dest: /devops/
      owner: root
      group: root
      mode: '0750'
    with_fileglob:
    - "/home/nixhal/lyrics_*"
and only using this with_fileglob: one gives location and one can easily use the function.

and for more stability and to not make an eye sore there's another and better way to write the loops and this is how i write another playbook same but diff structure and func same:
---
- hosts: all
  become: yes

  tasks:
  - name: Copy files using loops
    copy:
      src: "{{ item.src }}"
      dest: "{{ item.dest }}"
      owner: "{{ item.owner }}"
      group: "{{ item.group }}"
      mode: "{{ item.mode }}"
    loop:
    - { src: "/home/nixhal/cmpunk_cop.lyric", dest: "/home/", owner: "root", group: "root", mode: "755" }
    - { src: "/home/nixhal/viper.lyric", dest: "/home/nixhal", owner: "root", group: "nixhal", mode: "775" }
    - { src: "/home/nixhal/warpigs.lyric", dest: "/home/", owner: "nixhal", group: "root", mode: "711" }
    - { src: "/home/nixhal/despasito.lyric", des: "/home/", owner: "root", group: "root", mode: "555" } 

and there's a new thing called ansible-vault and this is used to secure your playbook.
while doing vault there's two types we can create it ie: ansible-vault create copy.yml | ansible-vault encrypt copy.yml

their main diff is using create, will create a new file and we have to write a playbook from scratch and meanawhile,encrypt will encrypt or put into secure vault and we can't access the playbook contents even using cat command until we put the password that we put into it using encrypt and it put password to the existing playbook neither than creating a new playbook. and this helps to secure the playbooks and since i already created a vault of my playbook to access it: ansible-vault view playbookname.yml to cat vaulted playbook, to edit put edit instead of view, and once passwd of vault set and forgotton then, one must again rewrite the playbook again as it can't be recovered just like git tokens. using vault on the playbook, now you can't run the playbook like i used to like ie:
ansible-playbook playbook --become -C | ansible-playbook playbook --become | ansible-playbook fi.yml --syntax-check

these all commands won't work after putting the playbook into a vault. so to run the vaulted playbook one must use:
ansible-playbook playbook --syntax-check --ask-vault-pass must be used to run playbook, check syntax, and even dry run.

so to run i must use this --ask-vault-pass at last of the running playbooks commands. ie i used :
ansible-playbook copy.yml --become -C --ask-vault-pass now this playbook will run after giving the vault password.

and i already told before, if vault passwd forgotton and don't know we have to create a new or brand new playbook of that file. and even though to rechange the password, one must know the vault so it's better to keep the backup of that passwd of that vault in the system. if i know the passwd of the vault of my playbook then i can change it using this command: ansible-vault rekey playbookname.yml will ask me for previous passwd, and newpasswd can be set

to remove the password of vault or remove vault: ansible-vault decrypt ply.yml 	

and this time i create a new vaulted playbook ie: ansible-vault create vaultedplaybook.yml and then pasted inside that file and used this ansible-playbook vaultedplaybook.yml --become -C --ask-vault-pass to run asked for me a passwd and it ran without problem.

also new module today again: get_url using this module i downloaded maven for my workernodes: and the playbook look like this:

---
- hosts: all
  become: yes
  vars:
    maven: https://archive.apache.org/dist/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz
    location: /home/nixhal
  tasks:
  - name: Downloading maven for java packages
    get_url:
      url: "{{ maven }}"
      dest:  "{{ location }}"


==================================================================================================================

now in again today's  day 17  this session gonna be long one as i am today gonna deploy a webpage or website using nginx server using a single playbook. so i am gonna show here my entire playbook to start to end deployment of the website using nginx server.
nixhal@master-node:~/playbooks/project_deploy$ cat deploy.yml 
---
- hosts: all
  become: yes
  vars:
    package: nginx
    node1: workernode1
    node2: workernode2
    s1: site1
    s2: site2

  tasks:
  - name: Install nginx server on workernodes
    apt:
      name: "{{ package }}"
      state: present
    
  - name: Start & enable nginx service
    service:
      name: "{{ package }}"
      state: started
      enabled: true
  
  - name: Create project directory based on node
    file:
      path: "/var/www/{{ item.path }}"
      state: directory
    loop:
    - { node: "{{ node1 }}", path: "{{ s1 }}" }
    - { node: "{{ node2 }}", path: "{{ s2 }}" }
    when: ansible_nodename == item.node
 
  - name: Copying projects to their respective sites based on node
    synchronize:
      src: "{{ item.src }}"
      dest: "{{ item.dest }}"
      recursive: yes
    loop:
    - { src: "/home/nixhal/graphic_project/", dest: "/var/www/site1", node: "{{ node1 }}" }
    - { src: "/home/nixhal/health_project/", dest: "/var/www/site2", node: "{{ node2 }}" }
    when: ansible_nodename == item.node 

  - name: Moving the files site1 & site2 into /etc/nginx/sites-available directory inside the workernodes
    copy:
      src: "{{ item.src }}"
      dest: "{{ item.dest }}"
    loop:
    - { src: "/home/nixhal/graphic_project/{{ s1 }}", dest: "/etc/nginx/sites-available", node: "{{ node1 }}" }
    - { src: "/home/nixhal/health_project/{{ s2 }}", dest: "/etc/nginx/sites-available", node: "{{ node2 }}" }
    when: ansible_nodename == item.node
    notify:
    - Restart Nginx

  - name: Creating a symlink to those site1 & site2 into sites-enabled
    file:
      src: "{{ item.src }}"
      dest: "{{ item.dest }}"
      state: link
    loop:
    - { src: "/var/www/site1/{{ s1 }}", dest: "/etc/nginx/sites-enabled/site1", node: "{{ node1 }}" }
    - { src: "/var/www/site2/{{ s2 }}", dest: "/etc/nginx/sites-enabled/site2", node: "{{ node2 }}" }
    when: ansible_nodename == item.node
    notify:
    - Restart Nginx
  
  handlers:    
  - name: Restart Nginx
    service:
      name: "{{ package }}"
      state: restarted
  
  - name: Adding new contents into /etc/hosts file
    lineinfile:
      path: /etc/hosts
      line: "{{ item.line }}"
    loop:
    - { line: '192.168.1.11  www.site1.com', node: "{{ node1 }}" }
    - { line: '192.168.1.12  www.site2.com', node: "{{ node2 }}" }

here, i have almost 8 tasks where i used multiple vars and multiple loops too. i put var for site1 & site2 files and locations and here's the list of tasks in words that i performed here:

1. First install nginx in both workernodes
2. Start and enable nginx in both workernodes
3. Create a Project directory according to their own required names
4. Rsync/Copy the project containing files to those newly created project directory
5. Both projects contain file called site1 and site2 which configs of nginx and copy those files to /etc/nginx/sites-available directory according to their nodenames/vms
6. Create those recently copied nginx configs to /etc/nginx/sites-available at their nodenames/vms
7. Restart the nginx sevice for both machines
8. Add the lines ie: 192.168.1.11  www.site1.com which is there in the config at the end of the /etc/hosts file to make the sites appear in the browser using the domainname: www.site1.com

during these tasks, i performed almost more than 10 times my task as it wasn't running, like at some point i even lost the count of my trying and finally at last, i decided to run without dry run and let me remind you all the time i was using the dry run and using normal run the task all succeeded without any error. the main error was of mine using dry run: "ansible-playbook deploy.yml --become -C" which fake runs the playbook and without -C the playbook ran successfully without any problem. i was stupid that i have created a directory using playbook and trying to transfer the files to that recently created directory but dry run is fake run which doesn't actually create the dir and when the task to transfer came it didn't find the directory or the required files as in reality there's isn't any directory made and if not made then not found so obviously this error got solved without using the dry run.

also used multiple loops as i was using two different nodes and deploying two different projects to two diff nodes at the same time and yeah i became successfull init. and after that i also learned two modules called handlers & notify. whose main job is handlers are the triggers and notify is to notify trigger that the changes been made and now you just trigger the task. what i used is handlers used at above the task of restart nginx and notify at the transfer of data to nodes and when any changes made to those data transferring data there below i have put notify and when data are changed any types, the notify tells the handlers the changes has been made and handlers listening to those calls restarts the nginx server. and while using handlers, the name of the task must be exact same to the notify otherwise it won't work and similarly, i also learned for the module called "ignore_erros: yes" which basically job is to run the playbook continously even though any task that is error or failed, the playbook doesn't stop until all the task those are failed, or success, until all the tasks are run using this module as it is also important to perform the playbook continously even it fails at one task, the playbook doesn't stop and run all the tasks until it's all completed.

also learned about the new command: "ansible -m setup all" which gives the entire description of the nodes and all the information that ansible can gather about the nodes, this command will provide and also using these typical commands like "    when: ansible_distribution == "Ubuntu" #   "when: ansible_os_family == "Debian"
i can transfer the files from master to worker according to their linux os flavours like using ansible_os_family & ansible_distribution , this when condition will send the data or transfer of data according to their os family or distribution. to run the playbook i must stay inside the directory where i have created inventory or ansible.cfg to run the playbook. and reason to create multiple cfg, inventory is to resolve conflicts between the groups while working in the system as each user or devops has their own ansible configs to run the playbooks.

that's it for these 2 days session in single file. i learned too much and things.