.PHONY: rel stagedevrel deps test

all: deps compile

compile: deps
	./rebar compile

deps:
	test -d deps || ./rebar get-deps

clean:
	./rebar clean

distclean: clean
	./rebar delete-deps

test:
	./rebar compile eunit

##
## Doc targets
##
docs:
	./rebar doc

APPS = kernel stdlib sasl erts ssl tools os_mon runtime_tools crypto inets \
	xmerl webtool snmp public_key mnesia eunit
PLT ?= $(HOME)/.riak_combo_dialyzer_plt

check_plt: compile
	dialyzer --check_plt --plt $(PLT) --apps $(APPS)

build_plt: compile
	dialyzer --build_plt --output_plt $(PLT) --apps $(APPS)

dialyzer: compile
	@echo
	@echo Use "'make check_plt'" to check PLT prior to using this target.
	@echo Use "'make build_plt'" to build PLT prior to using this target.
	@echo
	@sleep 1
	dialyzer -Wunmatched_returns --plt $(PLT) ebin | \
	    fgrep -v -f ./dialyzer.ignore-warnings

cleanplt:
	@echo 
	@echo "Are you sure?  It takes about 1/2 hour to re-build."
	@echo Deleting $(PLT) in 5 seconds.
	@echo 
	sleep 5
	rm $(PLT)

