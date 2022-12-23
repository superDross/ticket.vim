# TODO: create a Dockerfile to test this

.PHONY: tests
tests:
	@rm -f ~/.tickets/ticket.vim/*
	@/usr/bin/vim -c 'Vader! test/*' 

.PHONY: test
test: tests

