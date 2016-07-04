tramp: main.c
	gcc -o $@ $^

/usr/local/bin/tramp: tramp
	ln -s $(shell pwd)/$^ $@

.PHONY: install
install: /usr/local/bin/tramp
