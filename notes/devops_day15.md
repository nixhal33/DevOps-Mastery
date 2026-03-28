devops_day15.md

today i am gonna learn about variables and loops in ansible.

Gemini said
I’ve got the whiteboard ready. Let's break down those 20k words of raw practice into bite-sized, documented examples. This is exactly how you turn a "brainstorm" into a professional technical reference.

1. The Power of Loops (loop)
Instead of writing a new task for every item, you use a "template" and feed it a list.

A. Simple List
Used when you only need to change one value (like a package name).

YAML
- name: Install multiple tools
  apt:
    name: "{{ item }}"
    state: present
  loop:
    - git
    - curl
    - tree
The Logic: Ansible runs this task 3 times, replacing {{ item }} with a different name each time.

B. Complex List (Dictionaries)
Used when you need to change multiple values per item (like a username AND their specific group).

YAML
- name: Create users with specific groups
  user:
    name: "{{ item.user_name }}"
    groups: "{{ item.user_group }}"
  loop:
    - { user_name: 'bhuvan', user_group: 'bam' }
    - { user_name: 'ajay', user_group: 'nagar' }
The Logic: item becomes a "bag" holding two pieces of data. You grab them using .user_name and .user_group.

2. Dynamic Configuration (vars)
Variables allow you to set "global settings" at the top so you don't have to edit the tasks later.

YAML
vars:
  shared_dir: /devops/data
  file_mode: "0775"

tasks:
  - name: Create a directory using the variable
    file:
      path: "{{ shared_dir }}"
      state: directory
      mode: "{{ file_mode }}"
The Logic: If your instructor tells you to change the directory to /opt/backup, you only change the shared_dir line at the top, and every task using it updates automatically.

3. Advanced File & Archive Management
This is about handling data efficiently across the network.

A. The archive Module
Bundles many files into one to save space or move them easily.

YAML
- name: Zip up the logs
  archive:
    path: /var/log/nginx
    dest: /tmp/nginx_logs.tgz
    format: gz
B. The unarchive Module (with remote_src)
YAML
- name: Extract the zip already on the worker
  unarchive:
    src: /tmp/nginx_logs.tgz
    dest: /home/nixhal/extracted/
    remote_src: yes
The Logic: remote_src: yes is the "magic switch." It tells Ansible: "Don't look for this zip on my Mint Laptop; look for it on the Ubuntu Worker node's hard drive."

4. User and Group Architecture
This creates the "Who's Who" on your servers.

YAML
- name: Setup Team Alpha
  group:
    name: alpha
    state: present

- name: Add member to Alpha
  user:
    name: samantha
    groups: alpha
    append: yes
The Logic: append: yes is your safety net. Without it, adding Samantha to "alpha" might kick her out of "sudo" or "adm" groups she was already in.

5. Selective Execution (tags & when)
This allows you to be specific about what runs and where it runs.

A. Tags (The Filter)
YAML
- name: Update Web Server
  apt:
    name: nginx
    state: latest
  tags:
    - web_update
The Usage: You run this with ansible-playbook site.yml --tags web_update. Ansible skips everything else and only runs this task.

B. Conditionals (when)
YAML
- name: Only install this on Node 1
  apt:
    name: vim-gtk3
  when: ansible_hostname == "workernode1"
The Logic: Ansible "checks the facts" first. If the node name isn't exactly workernode1, it simply skips the task.

Summary of the "Best Practice" Update
In your notes, always remember the difference between Become methods:

become: yes: (The Standard) "I need root powers for this task/play."

become_user: root: (The Specific) "I want to specifically act as the root user." (Use become: yes 99% of the time).