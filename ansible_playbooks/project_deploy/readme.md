I am trying to deploy a website using nginx server using a playbook. 

1. First install nginx in both workernodes
2. Start and enable nginx in both workernodes
3. Create a Project directory according to their own required names
4. Rsync/Copy the project containing files to those newly created project directory
5. Both projects contain file called site1 and site2 which configs of nginx and copy those files to /etc/nginx/sites-available directory according to their nodenames/vms
6. Create those recently copied nginx configs to /etc/nginx/sites-available at their nodenames/vms
7. Restart the nginx sevice for both machines
8. Add the lines ie: 192.168.1.11  www.site1.com which is there in the config at the end of the /etc/hosts file to make the sites appear in the browser using the domainname: www.site1.com

that's all the main tasks i have done in this deploy playbook.

Thank You!!!!!!!!--- 
