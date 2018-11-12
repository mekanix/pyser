REGGAE_PATH = /usr/local/share/reggae
SERVICES = postgresql https://github.com/pyserorg/postgresql \
	   backend https://github.com/pyserorg/backend \
	   frontend https://github.com/pyserorg/frontend

.include <${REGGAE_PATH}/mk/project.mk>


collect: up
	@bin/collect.sh
