REGGAE_PATH = /usr/local/share/reggae
SERVICES = backend https://github.com/pyserorg/backend \
	   frontend https://github.com/pyserorg/frontend

.include <${REGGAE_PATH}/mk/project.mk>


collect: up
	@bin/collect.sh

shell: up
	@sudo cbsd jexec user=devel jname=pyserback /usr/src/bin/shell.sh
