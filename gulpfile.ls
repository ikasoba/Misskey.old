require! {
	gulp
	'gulp-plumber': plumber
	'gulp-lint-ls': lint-ls
	'gulp-livescript': ls
}

paths =
	ls: './src/**/*.ls'
	package-json: './package.json.ls'

gulp.task \build-package-json ->
	gulp.src paths.package-json
		.pipe plumber!
		.pipe ls!
		.pipe gulp.dest './'

gulp.task \build <[ build-package-json ]>

gulp.task \watch <[ build ]> ->
	gulp.watch paths.package-json, <[ build-package-json ]>

gulp.task \test <[ lint build ]> ->
	gulp.src paths.ls
		.pipe ls!

gulp.task \lint ->
	gulp.src './**/*.ls'
		.pipe lint-ls {+allow-case, +allow-null, +allow-void, +allow-this, +allow-new, +allow-throw, +allow-delete}

gulp.task \default <[ build ]>
