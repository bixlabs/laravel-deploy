default: test

# private.pem
deploy_dir      := ${DEPLOY_DIR}
source_dir      := ./sample
deploy_host     := ${DEPLOY_HOST}
deploy_key      := $(shell cat ${DEPLOY_KEY})
deploy_username := ${DEPLOY_USERNAME}
post_deploy     := 'php app/some.php'

test: clean
	@./entrypoint.sh \
		$(deploy_dir) \
		$(source_dir) \
		$(deploy_host) \
		$(deploy_username) \
		$(post_deploy) \
		$(deploy_key)
clean:
	@rm -rf $(deploy_dir) .key
