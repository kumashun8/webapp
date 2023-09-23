all: app

app: *.go go.mod go.sum
	go build -o isucondition

restart: app restart-app restart-nginx

restart-app: app
	rm -f /tmp/webapp.sock
	sudo systemctl restart isucondition.go.service
	sudo systemctl status isucondition.go.service | tail -n 5

restart-nginx: logrotate
	sudo rsync -av ../nginx/nginx.conf /etc/nginx/nginx.conf
	sudo nginx -s reload
	sudo systemctl status nginx | tail -n 5

init-asdf:
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf
	echo '. "~/.asdf/asdf.sh"' > ~/.bashrc
	. ~/.bashrc

tools:
	asdf plugin add alp
	asdf install alp `asdf list-all alp | tail -1`
	asdf global alp `asdf list-all alp | tail -1`
	sudo apt update
	sudo apt-get install -y percona-toolkit

slowlog:
	sudo pt-query-digest /var/log/mysql/mysql-slow.log | tee digest_`date +%Y%m%d%H%M%S`.txt

n:
	sudo cat /var/log/nginx/access.log | alp json --sort=sum -r -m '/api/condition/[0-9a-z\-]+,/api/isu/[0-9a-z\-]+,/isu/[0-9a-z\-]+'| tee ../alp/alp_`date +%Y%m%d%H%M%S`.txt

logrotate:
	sudo mv /var/log/mysql/mysql-slow.log /var/log/mysql/mysql-slow.log.`date +%Y%m%d%H%M%S`
	sudo touch /var/log/mysql/mysql-slow.log
	sudo mv /var/log/nginx/access.log /var/log/nginx/access.log.`date +%Y%m%d%H%M%S`
	sudo touch /var/log/nginx/access.log