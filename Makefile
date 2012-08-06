
PREFIX:=../
DEST:=$(PREFIX)$(PROJECT)

REBAR=./rebar

rebuild:	del_deps \
	get_deps \
	clean \
	compile

edoc:
	@$(REBAR) doc

test:clean \
	compile
	@$(REBAR) ct

clean:
	@$(REBAR) clean
	@rm -rf ./test/*.beam

compile:
	@$(REBAR) compile

dialyzer:
	@$(REBAR) dialyze

get_deps:	del_deps
	@$(REBAR) get-deps

del_deps:
	@rm -rf ./deps

update-deps:
	@$(REBAR) update-deps
test-compile:
	@erlc -I include  -W0 -DTEST=true -o ./ebin src/*.erl

test_suite:clean \
		compile
		@$(REBAR) ct suite=esp_compile
	
app:
	@$(REBAR) create-app appid=esp
	
	
	
	
