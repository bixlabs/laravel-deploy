.MAIN: test

check-deps:
	@act --version >/dev/null 2>&1 || (echo "'act' is not installed, go to https://github.com/nektos/act#installation "; exit 1)
test: check-deps
	act -j act_deploy
