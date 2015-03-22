name: 'misskey'
description: 'Misskey'
version: '0.0.6'
private: true
license: 'MIT'

homepage: 'https://github.com/syuilo/Misskey.git'
bugs: 'http://github.com/syuilo/Misskey/issues'
repository:
	type: 'git'
	url: 'https://github.com/syuilo/Misskey.git'

main: './src/'
scripts:
	build: 'gulp build'
	watch: 'gulp watch'

dependencies:
	async: '^0.9.0'
	bcrypt: '^0.8.0'
	'body-parser': '^1.10.1'
	compression: '^1.4.0'
	'connect-redis': '^2.1.0'
	cookie: '^0.1.2'
	'cookie-parser': '^1.3.3'
	'escape-html': '^1.0.1'
	express: '^4.10.6'
	'express-minify': '^0.1.3'
	'express-session': '^1.10.1'
	gm: '^1.9.0'
	gulp: '^3.8.10'
	'gulp-livescript': '^2.3.0'
	'gulp-plumber': '^1.0.0'
	jade: '^1.9.1'
	'js-yaml': '^3.2.6'
	less: '^2.4.0'
	LiveScript: '^1.3.1'
	marked: '^0.3.3'
	moment: '^2.9.0'
	mongoose: '^3.9.7'
	multer: '^0.1.7'
	'prelude-ls': '^1.1.1'
	redis: '^0.12.1'
	'socket.io': '^1.3.4'

author:
	name: 'syuilo'
	email: 'syuilotan@yahoo.co.jp'
	url: 'https://github.com/syuilo'

contributors:
	{ name: 'syuilo', email: 'syuilotan@yahoo.co.jp', url: 'https://github.com/syuilo' }
	{ name: 'Afuafu', url: 'https://github.com/afuafu55' }
	{ name: 'まりはち', email: 'marihachi0620@gmail.com', url: 'https://github.com/marihachi' }
	{ name: 'Aya Morisawa', url: 'https://github.com/AyaMorisawa' }
	{ name: 'はらだい', email: 'mail@haradai.net', url: 'https://github.com/ha-dai' }
	{ name: 'シトリン', url: 'https://github.com/Citringo' }
