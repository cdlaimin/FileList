#!/bin/sh
cd `dirname $0`
git reset --hard
git pull

git submodule update --init
for i in gfwlist-by-loukky genpac
do
	(cd $i;git pull origin master)
done
rm -rf whitelist.txt
cp domainlist/whitelist.txt whitelist.txt
rm -rf env
virtualenv env
source env/bin/activate
(cd genpac;python setup.py install)

env/bin/genpac \
	--pac-proxy "SOCKS5 127.0.0.1:1080" \
	--gfwlist-url - \
	--gfwlist-local gfwlist-by-loukky/gfwlist.txt \
	-o gfwlist.pac
sed -e '5d' -e '3d' -i gfwlist.pac
deactivate
echo -e "最后一次更新时间 $(LANG=C date +"%Y-%m-%d %H:%M:%S")\nhttps://raw.githubusercontent.com/cdlaimin/gfwlist2pac/master/gfwlist.pac
" > /root/gfwlist2pac/README.md
git add .
git commit -m "[$(LANG=C date +"%Y-%m-%d %H:%M:%S")]auto update"
git push origin master
