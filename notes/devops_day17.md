
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

that's it for today's session.
