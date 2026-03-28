day 8 of learning linux road to devops

so yesterday, i learned how websites can be hosted through nginx using the directory conf.d where i was inside that dir and created a conf file related each website and put this as the configuration:

server {
	listen 80;
	server_name www.web1.com;

	root /var/www/web1_event_invitation_webpage;
	index index.html;

	location / {
		try_files $uri $uri/ =404;
	}
}

where for other websites, i only changed their servername, their root index file but today i found out that we can also deploy the website using the sites-available directory where i will create some file and will make or link the file inside the sites-enabled directory. so today this is how i am gonna deploy the websites but using the new method of using the sites-available and sites-enabled.

and btw i learned one helpful command: "find . -maxdepth 1 -type f ! -name 'web_configs.tar' -delete" what this cmd will do is delete all the files where i am inside the directory except the name "web_configs.tar" file. and this seems pretty useful to me now.

so let's move to new website deployment method. what i did is now i first created a backup for those previously created configs and removed the previous configs of those websites. and now i am inside the sites-available directory ie: "/etc/nginx/sites-available/" and created a filename but without extension so i keep filename as same as web1 for easiness. so now after this i pasted my previous configuration inside the web1: 

server {
	listen 80;
	server_name www.web1.com;

	root /var/www/web1; # this time i changed this website directory name to web1 for my easiness.
	index index.html;

	location / {
		try_files $uri $uri/ =404;
	}
}


and saved and quit and then the thing is not finished yet. so after this i created a soft link of this file web1 into the sites-enabled dir as i already mentioned above. so to do that i did: 
"ln -s /etc/nginx/sites-available/web1 /etc/nginx/sites-enabled/web1" and see giving a absolute path while making soft/hard link is very necessary because if not given then the link will fall into infinite loop which i already faced in day 2 or 4 session ago so i don't want to keep same mistakes again so this is how i did it and after linking is completed i checked if link has really been or not and i checked it and i see the link is there so now after this i restart my nginx service and then i went to my browser and then i checked if the website is working or not and i gave the servername set as in the hosts file "www.web1.com" and i see the website is running and btw i got confused a bit here thinking that did i did this with ubuntu or centos and yeah i did this with ubuntu which is my host system and i know as a root there are so much power on my hands and i have to use it carefully and i am doing so. and yeah the website is live and but then i immediately went for the second website to deploy and i did all deeds and checked if the website is live or not and then i saw it's repeatedly showing me my first website. i got confused why is that and btw i also did little experiment and i tried to see using my other websites domainname ie: "www.web3/web4.com" and i see these all are straight directing towards my first website and then i suddenly got hit with acknowledgement that i created the file but i haven't linked them yet so i immediately created a link and restarted my nginx service and yeah boom i see my websites both live and did with the same to each websites and all came live. so no problem with the nginx and one another important thing with nginx is that if not found inside the "/var/www/html" then it is also supposed to be another place ie: "/usr/share/nginx/html/" so this is a new thing i discovered today.

so i guess that's it for today's session.
