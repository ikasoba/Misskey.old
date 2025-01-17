require! {
	'./create-bbs-post'
	'./create-bbs-thread-watch'
	'../../models/user': User
	'../../models/bbs-thread': BBSThread
}

module.exports = (app, user, title, text = null) ->
	resolve, reject <- new Promise!
	
	function throw-error(code, message)
		reject {code, message}
		
	title .= trim!
	if text? then text .= trim!
	
	switch
	| null-or-empty title => throw-error \empty-title 'Empty title.'
	| _ =>
		thread = new BBSThread!
			..title = title
			..user-id = user.id

		(, created-thread) <- thread.save
		
		watch <- create-bbs-thread-watch app, user, created-thread.id .then 
		
		if text?
			create-bbs-post do
				app, user, created-thread.id, text
			.then do
				(post) ->
					resolve created-thread
				(err) ->
					throw-error "create-post-#{err.code}" err.message
		else
			resolve created-thread
