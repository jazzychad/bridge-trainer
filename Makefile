all:
	rm -rf _site
	mkdir -p _site/{css,js,img}
	coffee -c js/coffee/cards.coffee
	cp html/index.html _site
	cp js/coffee/cards.js _site/js
	pushd css/bootstrap && make && popd
	cp css/bootstrap/docs/assets/img/{glyphicons-halflings.png,glyphicons-halflings-white.png} _site/img
	cp css/bootstrap/docs/assets/js/bootstrap.min.js _site/js
	cp css/bootstrap/docs/assets/css/{bootstrap.css,bootstrap-responsive.css} _site/css
	pushd js/Bankersbox && make && popd
	cp js/Bankersbox/bankersbox.min.js _site/js

clean:
	rm -rf _site

deploy: all
	pushd _site && s3cmd sync . ${BRIDGE_S3_BUCKET} && popd


.PHONY: all clean deploy