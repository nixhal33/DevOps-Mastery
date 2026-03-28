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

That's it for today's session.
