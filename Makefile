all: bootstrap bankersbox cards appjs

site: all cardsmin appjsmin
	rm -rf _site
	mkdir -p _site/{css,js,img}
	cp html/index.html _site
	cp js/coffee/cards.js _site/js
	cp js/coffee/cards.min.js _site/js
	cp js/coffee/app.js _site/js
	cp js/coffee/app.min.js _site/js
	cp css/bootstrap/bootstrap/img/{glyphicons-halflings.png,glyphicons-halflings-white.png} _site/img
	cp css/bootstrap/bootstrap/js/bootstrap.min.js _site/js
	cp css/bootstrap/bootstrap/css/{bootstrap.css,bootstrap-responsive.css,bootstrap.min.css,bootstrap-responsive.min.css} _site/css
	cp js/Bankersbox/bankersbox.min.js _site/js
	cp js/tappable/source/tappable.js _site/js

clean:
	rm -rf _site
	rm -f js/coffee/cards.js
	rm -f js/coffee/app.js
	pushd css/bootstrap && make clean && popd
	pushd js/BankersBox && make clean && popd

###
### Cards dependencies
###

cards: js/coffee/cards.js

js/coffee/cards.js: js/coffee/cards.coffee
	coffee -c js/coffee/cards.coffee

cardsmin: js/coffee/cards.min.js

js/coffee/cards.min.js: js/coffee/cards.js
	@echo "Minifying cards.js..."
	curl -d output_format=text -d output_info=compiled_code -d compilation_level=SIMPLE_OPTIMIZATIONS --data-urlencode js_code@js/coffee/cards.js http://closure-compiler.appspot.com/compile > js/coffee/cards.min.js 2> /dev/null
	@echo "Done."

appjs: js/coffee/app.js

js/coffee/app.js: js/coffee/app.coffee
	coffee -c js/coffee/app.coffee

appjsmin: js/coffee/app.min.js

js/coffee/app.min.js: js/coffee/app.js
	@echo "Minifying app.js"
	curl -d output_format=text -d output_info=compiled_code -d compilation_level=SIMPLE_OPTIMIZATIONS --data-urlencode js_code@js/coffee/app.js http://closure-compiler.appspot.com/compile > js/coffee/app.min.js 2> /dev/null
	@echo "Done."

###
### Bootstrap dependencies
###

bootstrap:
	pushd css/bootstrap && make bootstrap && popd

###
### Bankersbox dependencies
###

bankersbox:
	pushd js/BankersBox && make min && popd

###
### Deploy
###

deploy: site
	pushd _site && s3cmd sync . ${BRIDGE_S3_BUCKET} && popd


.PHONY: all clean deploy bootstrap bankersbox cards cardsmin site