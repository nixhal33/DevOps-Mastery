
in today's session, i learened about inventory, ansible.cfg. here in this session, i learned not so many things, what i did first was to delete the hosts file or let's say empty the /etc/ansible/hosts file or remove that file and without that our ansible doesn't know which hosts to start the playbook for and where to send it. after this there's another method to fix these things out first i created a file called inventory inside the directory where i was practicing ansible and playbooks. vim /home/nixhal/playbooks/inventory
[servers]
workernode1

[worker]
workernode2

even after that i ran ansible playbook it didn't ran cuz there's no any ansible config file so i also created an ansible.cfg file inside my playbook directory and added these lines.
vim /home/nixhal/playbooks/ansible.cfg
[defaults]
inventory=/home/nixhal/playbooks/inventory
ask_pass=false

[privilege_escalation]
become_user=root
become=true
become_ask_pass=false

and here, first i added [defaults] and there i gave my recently created inventory directory and then ask_pass and this ask_pass=false means don't ask me for a ssh password as i already setup pub key on my workers. and in [privilege_escalation] i added become_user=root & become=true/yes whose both job is same but just put there for multiple choices and that become_ask_pass=false is not to ask me an password while running a playbook.

