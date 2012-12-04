all: bootstrap bankersbox cards

site: all
	rm -rf _site
	mkdir -p _site/{css,js,img}
	cp html/index.html _site
	cp js/coffee/cards.js _site/js
	cp css/bootstrap/bootstrap/img/{glyphicons-halflings.png,glyphicons-halflings-white.png} _site/img
	cp css/bootstrap/bootstrap/js/bootstrap.min.js _site/js
	cp css/bootstrap/bootstrap/css/{bootstrap.css,bootstrap-responsive.css,bootstrap.min.css,bootstrap-responsive.min.css} _site/css
	cp js/Bankersbox/bankersbox.min.js _site/js

clean:
	rm -rf _site

###
### Cards dependencies
###

cards: js/coffee/cards.js

js/coffee/cards.js: js/coffee/cards.coffee
	coffee -c js/coffee/cards.coffee

###
### Bootstrap dependencies
###

bootstrap:
	pushd css/bootstrap && make bootstrap && popd

###
### Bankersbox dependencies
###

bankersbox: js/Bankersbox/bankersbox.min.js

js/Bankersbox/bankersbox.min.js: js/Bankersbox/bankersbox.js
	pushd js/Bankersbox && make && popd

###
### Deploy
###

deploy: site
	pushd _site && s3cmd sync . ${BRIDGE_S3_BUCKET} && popd


.PHONY: all clean deploy bootstrap bankersbox cards site