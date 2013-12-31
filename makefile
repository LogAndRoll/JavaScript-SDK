node-test:
	brunch b -e node && jasmine-node --matchall build/test.js --verbose

node-module:
	brunch b -e node && sh make-node-module.sh