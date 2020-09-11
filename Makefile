USE_FREENIT = YES
REGGAE_PATH = /usr/local/share/reggae
SERVICES = backend https://github.com/pyserorg/backend \
	   frontend https://github.com/pyserorg/frontend


build: up
	@bin/build.sh

publish: build
	@ssh -p 666 pyser.org 'cd /usr/cbsd/jails-data/pyserback-data/usr/home/pyser/pyser && git fetch && git reset --hard origin/master'
	@rsync -P -av --delete-after build/ -e "ssh -p 666" pyser.org:/usr/cbsd/jails-data/nginx-data/usr/local/www/pyser.org/
	@ssh -t -p 666 pyser.org 'sudo cbsd jexec jname=pyserback service supervisord restart'
	@ssh -p 2201 pyser.org 'cd /usr/cbsd/jails-data/pyserback-data/usr/home/pyser/pyser && git fetch && git reset --hard origin/master'
	@rsync -P -av --delete-after build/ -e "ssh -p 2201" pyser.org:/usr/cbsd/jails-data/nginx-data/usr/local/www/pyser.org/
	@ssh -t -p 2201 pyser.org 'sudo cbsd jexec jname=pyserback service supervisord restart'

shell: up
	@${MAKE} ${MFLAGS} -C services/backend shell

.include <${REGGAE_PATH}/mk/project.mk>
