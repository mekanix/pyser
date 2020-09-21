USE_FREENIT = YES
REGGAE_PATH = /usr/local/share/reggae
SERVICES = backend https://github.com/pyserorg/backend \
	   frontend https://github.com/pyserorg/frontend

collect: up
	@bin/collect.sh

publish: collect
	@reggae read-pass >passwd
	@echo
	@rsync -avc --progress --delete-after build/ deploy@protivkovida.tk:/usr/cbsd/jails-data/nginx-data/usr/local/www/protivkovida.tk/
	@reggae expect-run passwd Password: ssh -t provision@protivkovida.tk sudo cbsd jexec jname=webbell sudo -u uwsgi git -C /usr/local/repos/webbell fetch
	@reggae expect-run passwd Password: ssh -t provision@protivkovida.tk sudo cbsd jexec jname=webbell sudo -u uwsgi git -C /usr/local/repos/webbell reset --hard origin/master
	@reggae expect-run passwd Password: ssh -t provision@protivkovida.tk sudo cbsd jexec jname=webbell sudo -u uwsgi env SYSPKG=yes /usr/local/repos/webbell/bin/init.sh
	@reggae expect-run passwd Password: ssh -t provision@protivkovida.tk sudo cbsd jexec jname=webbell service uwsgi restart
	@rm -rf passwd

.include <${REGGAE_PATH}/mk/project.mk>
