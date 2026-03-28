
day19
now, after this i today learned about new thing called roles and to create a roles i used : "ansible-galaxy init webapp --offline". Btw the reason --offline flag is used as i am practicing my ansible commands offline and the reason to use it offline was ansible-galaxy is a community among ansible and it's a huge community and using --online i can pull playbooks from other ansible users and even push my ansible playbooks to their cloud and basically it's a cloud where we can store and access the ansible playbooks and offline is used because to use it offline as i am practicing into my own machine.
This is the playbook official name will be webapp and using this command will create the roles for the webapp ie: this will create a directory named webapp which contains multiple sub directories ie: roles_project/

├── roles_web.yml
└── webapp
    ├── README.md
    ├── defaults
    │   └── main.yml
    ├── files
    │   ├── graphic_project
    │   │   ├── about-tooplate.html
    │   │   ├── images
    │   │   │   ├── tooplate-creative-01.jpg
    │   │   │   ├── tooplate-creative-02.jpg
    │   │   │   ├── tooplate-creative-03.jpg
    │   │   │   ├── tooplate-creative-21.jpg
    │   │   │   ├── tooplate-creative-22.jpg
    │   │   │   ├── tooplate-creative-23.jpg
    │   │   │   ├── tooplate-creative-24.jpg
    │   │   │   ├── tooplate-creative-25.jpg
    │   │   │   └── tooplate-creative-26.jpg
    │   │   ├── index.html
    │   │   ├── site1
    │   │   ├── tooplate-graphite-creative.css
    │   │   └── tooplate-graphite-script.js
    │   └── site1
    ├── handlers
    │   └── main.yml
    ├── meta
    │   └── main.yml
    ├── tasks
    │   ├── copy.yml
    │   ├── directory.yml
    │   ├── install.yml
    │   ├── link.yml
    │   ├── main.yml
    │   └── service.yml
    ├── templates
    ├── tests
    │   ├── inventory
    │   └── test.yml
    └── vars
        └── main.yml

according to this tree structure, the webapp contains multiple directories ie: defaults, files, handlers, meta,tasks,templates,tests and vars. and now this roles help me to breakdown those complex playbook into multiple task breakdown as can be seen in the tree. and after all the tasks has been written down in the tasks directory now we have to stack them according to the tasks that comes first. first i have to install nginx, start & enable it, create directory named site1 into workers, cp all those files from master to workers, link that specific file to sites-enabled and restart nginx. this is how the task should be performed so now i edited the main.yml file inside the tasks and added these contents:
---
- import_tasks: install.yml
- import_tasks: service.yml
- import_tasks: directory.yml
- import_tasks: copy.yml
- import_tasks: link.yml

as include: task.yml has been deprecated and so new one has arrived which is import_tasks or include_tasks and reason to bring these new imports is that include used to do all things by itself which caused the problems for the ansible devs to configure and debugg it so new one is introduced.

and in tasks:
--- 
- name: Copy all files
  synchronize:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
    recursive: yes
  loop:
  - { src: "graphic_project/", dest: "/var/www/site1" }
  - { src: "site1", dest: "/etc/nginx/sites-available" }
  notify:
  - Restart nginx

this is how i entered the contents in required main files and if i require vars then i will add vars in vars directory and the trigger button ie: handlers this is how i added contents into that directory
---
- name: Restart nginx
  service:
    name: nginx
    state: restarted

which is obviously to restart the changes if made into the transfer of files and that will automatically notify the handler that changes has been made and then it will restart the nginx server. and here in tasks there's a loop where files are like this:
  - { src: "graphic_project/", dest: "/var/www/site1" } and the reason i have put the path of the files like this is that i have put my all project files and directories that i will require to transfer into the workernodes, i have put them into my files directory ie: /home/nixhal/playbooks/roles_webapp/webapp/files this will secure the files location and i don't have to give the full path of my files to transfer or do any thing into the file or even configuration too i don't have to give the full path to transfer it if it was inside the roles of webapp. this will secure my paths as i don't have to give full path and if not put into this files director, should have to give full path.

after this all things have been put now to run this ansible playbook or roles of this playbook, i have to come out of the location like this: home/nixhal/playbooks/roles_webapp and then i created a new playbook task file named: roles_web.yml, name can be given any and put these contents inside of it:
---
- hosts: servers
  become: true

  roles:
  - webapp

to run this playbook as usual: "ansible-playbook roles_web.yml --become -C" and it ran and also without dry run, i ran it and it ran perfectly.

