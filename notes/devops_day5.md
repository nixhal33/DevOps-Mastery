day 5 of learning linux and my entire raw facts and information i am gonna write here and the things i am gonna learn today.

the thing i learned before like i learned yesterday was partitioning the disk, increasing the disk, adding it to fstab permanently and for temorarily and during those times i faced so many issuses and errors but i fixed it myself and did well and yesterday learning total of them were known as shadow partition.

but today i am gonna learn about how to create a logical volume manager and today in details i will am learning about it and gonna write entire things in raw format about what i studied today in this section.

so in lvm, there's three main compo:Physical volume(pv), Volume Group(vg), Logical Volume(lv)
so to create pv, i first deleted that sdb1 partition using fdisk /dev/sdb and deleted that partition. and then i created the pv using: pvcreate /dev/sdb and yeah the partition is created and then to check the pv: pvs command is used to see the pv creation is happened or not.

so i created the pv, so now how it works is that pv is a big bucket where lv is a jug inside the bucket and as we know that lv is renouned for it's constant or casual use of increment of the volume storage of the system or hdd. how i know this is that first there's a big bucket is setup and then there's a jug is setup and we all know the jug can hold a litre of water but we know big bucket can store more than 10Litre of waters so since the jug has already it's volume holding defined, we know we gonna drink 1l of water and we drink it and we satisfy from it but when, we are not satisfied from that 1l of water, we gonna need another litre of water or say 2L of water and then again we scoop out that litre of water from the big bucket and we drink it, this is how lvm works, there's first already big bucket already defined, we use how much water we want but when we ran out of water from the jug, we again scoop out the water from bucket and drink it and we use it until we r satisfied and if not we again scoop out from the bucket so this is how the lvm works.

now i will create a new vg named vg1 like: vgcreate vg1 and we need to attach the phycial volume to this vg so we attach with the sdb as this is the one currently i am using so here's the complete command: vgcreate vg1 /dev/sdb

NAME              MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                 8:0    0  128G  0 disk 
├─sda1              8:1    0    1G  0 part /boot
└─sda2              8:2    0  127G  0 part 
  ├─centos9s-root 253:0    0  125G  0 lvm  /
  └─centos9s-swap 253:1    0    2G  0 lvm  [SWAP]
sdb                 8:16   0   20G  0 disk 


to create the lv: lvcreate -L 10G -n lv1 vg1--> here flag -L & -n means size:10G & new name for logical volume: lv1 and that from where you are creating the lv1,from where are you getting that storage is from vg1 which was created early. after the partition this is the result:


NAME              MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                 8:0    0  128G  0 disk 
├─sda1              8:1    0    1G  0 part /boot
└─sda2              8:2    0  127G  0 part 
  ├─centos9s-root 253:0    0  125G  0 lvm  /
  └─centos9s-swap 253:1    0    2G  0 lvm  [SWAP]
sdb                 8:16   0   20G  0 disk 
└─vg1-lv1         253:2    0   10G  0 lvm  



and similarly like i did yesterday, i just created a partition and after the partition, i formatted the storage and mounted it on the system whether it is on tempoarary or permamnent. so after that i used these commands for the formatting. :mkfs.xfs /dev/vg1/lv1 and similarly for mounting : mount /dev/vg1/lv1 /fiveghdd. and i can see the partition is perfectly mounted on /fiveghdd.

now what i am gonna do is extend that my 10gb of storage of logical volume into 15G as i wanted more of the volume for it.

so what i did now is use this command first checked the remaining pv and lv: both vg is 10 and lv is 10 and main pv is 20G so what i used now is : "lvextend -L +5G /dev/vg1/lv1" where +5G means i increamented the storage of lv1 with 5 more gib of storage and now i still need to verify using this command: df -TH and checked there but was not showing the recently extended storage. and here now this part is very important and also this thing is also vvi for interviews. after all the things i did here like increasing the lv and releasing the lv whatever i did, it indeed need to be shown in the file system but when i did df -TH it didn't show why?  so the thing is here whenever you resize the storage lvm, main thing you need to see is that it need to be shown into the file system likewise i can't see the resized changes in the filesystem so what went wrong or what's happened here so that fs hasn't shown the resized changes is that 

Filesystem                Type      Size  Used Avail Use% Mounted on
devtmpfs                  devtmpfs  379M     0  379M   0% /dev
tmpfs                     tmpfs     402M     0  402M   0% /dev/shm
tmpfs                     tmpfs     161M  4.5M  156M   3% /run
/dev/mapper/centos9s-root xfs       135G  4.2G  130G   4% /
/dev/sda1                 xfs       1.1G  434M  574M  44% /boot
tmpfs                     tmpfs      81M     0   81M   0% /run/user/1000
/dev/mapper/vg1-lv1       xfs        11G  109M   11G   2% /fiveghdd
[root@centos9s ~]# 

here, my filesystem xfs doesn't know that i have resized the storage which has xfs which i have recently created and my filesystem doesn't know when the changes have been made so we need to make xfs understand that there has been some changes in the storage so to make my fs understand or react to changes: after the resize i hit the command: "xfs_growfs /fiveghdd" now this kinda refresh or make fs understand to the changes and now after that i can see the changes 

[root@centos9s ~]# df -Th
Filesystem                Type      Size  Used Avail Use% Mounted on
devtmpfs                  devtmpfs  361M     0  361M   0% /dev
tmpfs                     tmpfs     383M     0  383M   0% /dev/shm
tmpfs                     tmpfs     153M  4.3M  149M   3% /run
/dev/mapper/centos9s-root xfs       125G  3.9G  122G   4% /
/dev/sda1                 xfs       960M  414M  547M  44% /boot
tmpfs                     tmpfs      77M     0   77M   0% /run/user/1000
/dev/mapper/vg1-lv1       xfs        15G  140M   15G   1% /fiveghdd
[root@centos9s ~]# 

now the changes finally been understood by the system. now what i did next was create new logical volume from the same volume group vg1 to create a new partition in ext4 format so what i did was: "lvcreate -L 2G -n lv2 vg1" and this created a new lv for me named lv2 and i formated it into ext4: "mkfs.ext4 /dev/vg1/lv2" and then mount it onto new dir : "mount /dev/vg1/lv2 /Twoghdd" and even though after did this i still need fs to understand that ext4 format this your storage has been resized but it doesn't understand so to make it understand: what i did was i used this cmd: "resize2fs -f /dev/vg1/lv2" it's bit different that xfs as xfs contains xfs_growfs /mountpoint but this ext4 contains new command format: resize2fs -f /absolute/path/to/fs likewise i used.

Ok now for the main thing here in format difference is that xfs format can only be extended but can't be reduced whereas the ext4 can be increased,decreased or can be resized in both + & - but xfs can't be done.
so for reducing the storage of the partition first i need to unmount that partition which format is ext4 as xfs can't be reduced so i unmount that partition: "umount /dev/vg1/lv2 /Twoghdd"

and then you now have to define or declare how much of the storage you wanna reduce from that ext4 partition ie:
"resize2fs -f /dev/vg1/lv2 1G" and after that now "lvreduce -L 1G /dev/vg1/lv2" and now did lsblk and this output came up

NAME              MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                 8:0    0  128G  0 disk 
├─sda1              8:1    0    1G  0 part /boot
└─sda2              8:2    0  127G  0 part 
  ├─centos9s-root 253:0    0  125G  0 lvm  /
  └─centos9s-swap 253:1    0    2G  0 lvm  [SWAP]
sdb                 8:16   0   20G  0 disk 
├─vg1-lv1         253:2    0   15G  0 lvm  /fiveghdd
└─vg1-lv2         253:3    0    1G  0 lvm  

and from here, i previously set the storage of lv2 as 2G and after the resize i got 1G as a storage and now in my findings 1 thing added is that to reduce the amt of storage just mention how much you want like from 3G of storage now i need to write the exact amount of storage i need to delete like first the storage was 2g and i later added 1g of volume and total of 3g it has become. but while reducing, from 3g of storage how much exactly you want like from 3g of storage if i needed only 2g then i had to define there as "resize2fs -f /dev/vg1/lv2 2G" and after that now "lvreduce -L 2G /dev/vg1/lv2" and if the storage will be 2g there so from this finding, while reducing i need to put the exact amount of storage that i want it to become i don't have to do plus or minus just give the exact but not less or more than the storage holds it's actual one. 

and if i want to give all the free storage from the partition, like I have 20gb of storage and total used is 16gb and now i need to give all the free storage of 4gb to certain partition like to any partition lv1 or lv2 then
then i hit this cmd: "lvextent -l +100%FREE /dev/vg1/lv2" and this cmd will give all the free storage to the lv2 which was 4gb and now i can see 

NAME              MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                 8:0    0  128G  0 disk 
├─sda1              8:1    0    1G  0 part /boot
└─sda2              8:2    0  127G  0 part 
  ├─centos9s-root 253:0    0  125G  0 lvm  /
  └─centos9s-swap 253:1    0    2G  0 lvm  [SWAP]
sdb                 8:16   0   20G  0 disk 
├─vg1-lv1         253:2    0   15G  0 lvm  /fiveghdd
└─vg1-lv2         253:3    0    5G  0 lvm  /Twoghdd

ok now i have come up with another scenario that my vg1 volume also got fed up and now i have no volume left up in sdb my main partition: 20g i turned off my vm and then i added a new vdi of 20gb another one from my virtualbox and then started my vm and checked if it's checked or not and i saw sdc as another vdi which i just recently created. now i first made that volume into physical volume: "pvcreate /dev/sdc" and then checked it then i did "vgextend vg1 /dev/sdc" and checked the vgs : "vgs" and i saw that this has extended the vg1 which was 20g now has turned into 40g in total from the attachment of sdc.

now to remove these all: the things i did here to remove all the pv,vg,lv are follows:

to remove lvs: "lvremove vg1 lv1" this will ask to remove both lv's each asking like you want to remove lv1 if yes then lv2 if yes then both are removed and if you don't want to remove then you can do that too.

to remove vgs: "vgremove vg1"

to remove pvs: "pvremove /dev/sdb" and i also removed another one "pvremove /dev/sdc"

about entire lvm this i think today session covers up for me. 

