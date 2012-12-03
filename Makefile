all: bootstrap bankersbox cards

site: all
	rm -rf _site
	mkdir -p _site/{css,js,img}
	cp html/index.html _site
	cp js/coffee/cards.js _site/js
	cp css/bootstrap/docs/assets/img/{glyphicons-halflings.png,glyphicons-halflings-white.png} _site/img
	cp css/bootstrap/docs/assets/js/bootstrap.min.js _site/js
	cp css/bootstrap/docs/assets/css/{bootstrap.css,bootstrap-responsive.css} _site/css
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

bootstrap: css/bootstrap/docs/assets/js/bootstrap.min.js css/bootstrap/docs/assets/css/bootstrap.css css/bootstrap/docs/assets/css/bootstrap-responsive.css

css/bootstrap/docs/assets/js/bootstrap.min.js: css/bootstrap/js/*.js
	pushd css/bootstrap && make && popd

css/bootstrap/docs/assets/css/bootstrap.css: css/bootstrap/less/*.less
	pushd css/bootstrap && make && popd

css/bootstrap/docs/assets/css/bootstrap-responsive.css: css/bootstrap/less/*.less
	pushd css/bootstrap && make && popd

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