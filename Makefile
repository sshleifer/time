# usage:
# `make build` or `make` compiles lib/*.coffee to build/lib-js/*.js (for all changed lib/*.coffee)
# `make test` runs all the tests
# `make testfile` runs just that test
# `make clean` deletes all the compiled js files in lib-js
TESTS=$(shell cd test && ls *.coffee | sed s/\.coffee$$//)
CLIBS=$(shell find . -regex "^./lib\/.*\.coffee\$$")
LIBS=$(shell find . -regex "^./lib\/.*\.coffee\$$" | sed s/\.coffee$$/\.js/ | sed sXlibXbuild/lib-jsX)

build: jshint $(LIBS)

build/lib-js/%.js : lib/%.coffee
	node_modules/coffee-script/bin/coffee --bare -c -o $(@D) $(patsubst build/lib-js/%,lib/%,$(patsubst %.js,%.coffee,$@))

test: $(TESTS)

$(TESTS): build
	NODE_ENV=test node_modules/mocha/bin/mocha -R spec --timeout 60000 --compilers coffee:coffee-script test/$@.coffee

jshint:
	node_modules/coffee-jshint/cli.js $(CLIBS) -o node

clean:
	rm -rf build/lib-js
