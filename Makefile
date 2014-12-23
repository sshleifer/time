# usage:
# `make build` or `make` compiles lib/*.coffee to build/lib-js/*.js (for all changed lib/*.coffee)
# `make test` runs all the tests
# `make testfile` runs just that test
# `make clean` deletes all the compiled js files in lib-js
TESTS=$(shell cd test && ls *.coffee | sed s/\.coffee$$//)
CLIBS=$(shell find . -regex "^./lib\/.*\.coffee\$$")
ROUTES=$(shell find ./pages -type f -name "routes.coffee")
BROWSER=$(shell find ./pages -type f -name "*.coffee" | grep scripts)
LIBS=$(shell find . -regex "^./lib\/.*\.coffee\$$" | sed s/\.coffee$$/\.js/ | sed sXlibXbuild/lib-jsX)

build: lint hint $(LIBS)

build/lib-js/%.js : lib/%.coffee
	node_modules/coffee-script/bin/coffee --bare -c -o $(@D) $(patsubst build/lib-js/%,lib/%,$(patsubst %.js,%.coffee,$@))

test: $(TESTS)

$(TESTS): build
	NODE_ENV=test node_modules/mocha/bin/mocha -R spec --timeout 60000 --compilers coffee:coffee-script test/$@.coffee

hint:
	node_modules/coffee-jshint/cli.js $(CLIBS) $(ROUTES) -o node
	node_modules/coffee-jshint/cli.js $(BROWSER) -o browser --globals require,Backbone,_,$$

lint:
	./node_modules/coffeelint/bin/coffeelint -f coffeelint.json $(CLIBS) $(ROUTES) $(BROWSER)

clean:
	rm -rf build/lib-js
