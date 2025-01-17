require! {
	fs
	jade
	'../../../internal/create-status'
	'../../../auth': authorize
	'../../../../utils/get-express-params'
	'../../../../web/main/sites/desktop/utils/parse-text'
	'../../../../config'
}

module.exports = (req, res) -> authorize req, res, (user, app) ->
	[text, in-reply-to-status-id] = get-express-params do
		req, <[ text in-reply-to-status-id ]>

	if empty in-reply-to-status-id then in-reply-to-status-id = null

	image = null
	if (Object.keys req.files).length == 1 =>
		path = req.files.image.path
		image = fs.read-file-sync path

	create-status do
		app, user, text, in-reply-to-status-id, image
	.then do
		(status) ->
			status-compiler = jade.compile-file "#__dirname/../../../../web/main/sites/desktop/views/dynamic-parts/status/detail-one/reply.jade"
			status .= to-object!
			status.user = user
			res.api-render status-compiler do
				status: status
				login: yes
				me: user
				text-parser: parse-text
				config: config.public-config
		(err) ->
			res.api-error 400 err
