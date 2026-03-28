day 8 of learning linux

so what i am learning today is to copy from one machine to another machine. (vm-->hostmachine/othervm) and vice versa and to do that there's two types of packages that will help me do that. one is rsync(remote syncing) and another is scp which is also known as second copy or ssh copy.

so for rsync i used to send a textfile1.txt to my host machine using this command: "rsync -avz textfile1.txt nix@192.168.x.xx:/home/nix" and this will copy the file named txt1 to the home directory of nix or see: /home/nix.
so basically i already practiced these things maybe a year or 2 ago but that time i didn't exactly give enough thought about these flags ie: -avzh which basically is archive that archives that file which i want to send, vervose which shows me what's happening between the transfers of the files,z for compression of the files and h for human readble format and they basically copy files from one pc to another pc using these commands and i also researched for this that i understand that -vh meaning but couldn't these -az, after research i found out that the compression and archive of file after the transferring remains in the the system from which files we are sending and the file that are sent to another pc will receive the file at their atmost form like no changes. why i researched that because the mention of  a and z reminded me of archiving and compression so i wondered why the compression and archive of the file is not sent to other machine as receiving machine gets the original form of the file, it seems that after the sent is completed, that archive and compress remains left into the system and it just wooozh in the system and it's not so much of a thinking but yeah curiousity caught me up anyway. rsync in own machine from one dir to another: "rsync -avzh /root/devops/ /tmp" and yeah it copied entire file to the /tmp directory.

basically to rsync from a another machine basically copying from another machine by staying into own machine: 
"rsync -avzh nix@192.168.1.11:/home/nix/Downloads/firefox_downloads/textfile3.txt /root"

and similarly for scp:"scp -rv system_scripts.tar nix@192.168.xx.xx:." which will copy to my host vm default directory which will be /home/nix. and i can even mention which directory that i want to paste ie: /home/nix/Documents/scripts and if this was mentioned there then obviously will get copied into that scripts directory but foremost that path must be correct and the directory must be present there.

and the foremost reason to use these scp and rsync is for backups like there's everyday backup in the production environment and one must always need those backups too of everyday. so and also one vvi thing that while doing or making backup, i,we must focus on date of those backups like when exactly are they made. so while doing these backups must see the date of backups like when they are made and as we mostly do backups of everyday. while doing so i must use this "-p" flag while doing backup as this flag is used to preserve the date of those backups. 
so what i did to do that is use this command: "scp -prv devops/ nix@192.168.1.11:/home/nix/Documents"
and also i find that this -p preserved the date of that devops file

since both scp and rsync do the both same copying things but what's the actual diff betn them? so the main diff betn them is file copying style or system. suppose there's a 10gb work file ie: rdr2.mp4 while working and now you need to copy that into the another machine, i use scp to copy that file into my another machine and now later on after week that 10gb of work file:rdr2.mp4 after working increases and becomes a 20gb of file and again i need to copy that file, when i use scp it will again copy the 20gb of the same file again, which of 10gb of file i has already copied into another machine. which means that now i have 10gb of rdr2.mp4 and another 20gb or rdr2.mp4 into another machine but instead if i had used rsync then when i first copied the file rdr2.mp4 of 10gb into another machine and again the work space of that file rdr2.mp4 increases into 20gb and now here if i use rsync then it won't copy the file as a new one but instead it will continue from other 10gb space of that file as previous 10gb of file i had already had into the machine. so basically, rsync is used for this purpose and for single time copying files, scp is preferred but mostly i see rsync is much more comfortable and widely used in the system.

after this now i am gonna study about nginx which is also known as high performace web server. nginx/httpd/apache2 these all are almost same but nowadays nginx is on top as i already mentioned nginx is high performing web server. whereas these httpd and apache2 are also used but mostly nginx is on top as it almost takes 33 percent of the share market in the IT world. so i am gonna deploy some web page on it i also know that in redhat/centos httpd is used but in ubuntu or latest linux model like ubuntu, nginx is popular. 

so i first installed nginx using: "sudo apt install nginx -y" and started the service and also enabled the service so it loads up at the booting time so that i don't have to start it everytime i start the system: "systemctl start/enable nginx.service" and after that the default port no. this nginx was gonna listen to is 80 so i checked the port no. using 3 commands just in case. they are given below: 
1. "ss -tulnp | grep nginx"
2. "lsof -i :80"
3. "netstat -tulnp | grep nginx"

and these all commands led me to port 80 being listend by nginx so now.

so what i am gonna do is deploy a small web page which i already had practiced long ago but still am here todo smth. so i will make this worth. so to do that i did all rituals to install and start nginx and then to deploy the web page first i need to make sure that there's a file inside the /var/www/html/index.html so first there wasn't any file so i created a file by direct vim /var/www/html/index.html and i created a sample html file and copied that file into this html file and saved the file and quit and i restart the service and then i checked my ip of my system which is ubuntu i used for this nginx service and checked the service it has restarted and run and i grab ip of my host ie: "ip a | grep inet " and this give me this output "inet 192.168.xxx.xxx/xxx brd 192.168.1.255 scope global dynamic noprefixroute wlp3s0" and I copied the ip and paste into my web browser and boom i can see the website getting deployed.

and i changed a little bit here as i downloaded some free html template fro tooplate website and that website got like do have beautiful free html templates so i got it and i extracted it and removed previous file from /var/www/html/* and them pasted all the files for the new template into that html directory and restarted the nginx service and then boom i can see my website run again.

and since i am currently seeing the website inside my browser using ip address of my host system but i can also do that same thing without ip but instead of using a hostname. so what i did after this is: vm /etc/hosts(root) and then added a line at last: "192.168.my.machineip	domain" ie: "192.168.100.100 	www.mywedding.com"

and boom i again restarted and checked the webpage using the given domainname and boom the website is again on work. yeah i learned a lot of things regardless of my 3 days slacking. but i am not done yet so after this i found or i know, i can't deploy multiple websites using this /var/www/html/ directory and even if i tried to using that /var/www/html if i copied all the other websites into that directory and then this will eventually replace all the data and files from the previous website so it's not possible using that directory. but it seems that using single ip of the system, i can host a multiple websites and that thing has a special name and it's called "VIRTUAL HOST/ING"


now i downloaded multiple templates of 4 and then i copied those files with their name changing to web1 to 4 and copied into the /var/www/ folder inside.

and then i cd into /etc/nginx/conf.d and then i create a new file which i named as web1 to 4 as i already pasted inside the /var/www and mentioning same as their website file will be easier to determine the configs for each website. so i created a file called web1 and extension will always should be .conf so ie: "web1.conf" and then inside the file i entried this 
server {
        listen 80;
        server_name web1.com;

        root /var/www/web1_event_invitation_webpage;
        index index.html;
        
        location / {
                try_files $uri $uri/ =404;
        }       
}       

which shows first line as listen to port 80, and the server name is domain name that i given to the website, and root /var/www/web1_event_invitation_webpage; means root folder is this /var/ww/web1_event........... and index index.html; means point inside the root directory insdie that directory there's a index.html and point that file. and location means try the first contents of this web1 first see url of that directory and try the contents of that file and if not found any then throw the 404 error.

since created for 4 websites then i created 4 conf files as web1 to 4 and similary as a root directory were given according to their name set inside the /var/www directory.

so i restart the nginx service. and i already once learned and practiced about the port conflict between the nginx and the apache2 as they both listen to port 80 and to use them or use one at a time nginx is mostly used to people go for stoppage of apache2 and start the nginx but i practiced to give another port to the apache2 which is port 80 and gave nginx 8080 so never in future these two won't clash for the port no. 80.	after this all done i restarted the nginx and tried to access website using their hostname as already set in the conf.d directory and according to that configuration, i set up in the /etc/hosts as ip address of my host but domain for each different user and checked the browser using www.web1.com for 4 and yeah all ran except 4 as i mistakenly there forgot to edit the server_name as it was web1.com so i changed that to www.web4.com and saved it and restarted the system and yeah boom all the 4 websites came to life although 3 were already living but 4th one also came to life and i am happy with that one for today session.

finally my today's session comes to an end for day 7