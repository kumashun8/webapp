all: app

app: *.go go.mod go.sum
	go build -o isucondition

restart: logrotate restart-mysql restart-app restart-nginx

restart-app:
	rm -f /tmp/webapp.sock
	sudo systemctl restart isucondition.go.service
	sudo systemctl status isucondition.go.service | tail -n 5

restart-nginx:
	sudo rsync -av ../conf/nginx.conf /etc/nginx/nginx.conf
	sudo nginx -s reload
	sudo systemctl status nginx | tail -n 5

restart-mysql:
	sudo rsync -av ../conf/my.cnf /etc/mysql/conf.d/my.cnf
	sudo systemctl restart mysql.service
	sudo systemctl status mysql.service | tail -n 5

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

s:
	sudo pt-query-digest /var/log/mysql/mysql-slow.log | tee ../slowlog/digest_`date +%Y%m%d%H%M%S`.txt

n:
	sudo cat /var/log/nginx/access.log | alp json --sort=sum -r -m '/api/condition/[0-9a-z\-]+,/api/isu/[0-9a-z\-]+,/isu/[0-9a-z\-]+'| tee ../alp/alp_`date +%Y%m%d%H%M%S`.txt

logrotate:
	sudo mv /var/log/mysql/mysql-slow.log /var/log/mysql/mysql-slow.log.`date +%Y%m%d%H%M%S`
	sudo touch /var/log/mysql/mysql-slow.log
	sudo chmod 777 /var/log/mysql/mysql-slow.log
	sudo mv /var/log/nginx/access.log /var/log/nginx/access.log.`date +%Y%m%d%H%M%S`
	sudo touch /var/log/nginx/access.log