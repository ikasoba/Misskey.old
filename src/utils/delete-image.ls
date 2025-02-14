require! {
	request
	'../config'
}

module.exports = (user, type, image-name) ->
	resolve, reject <- new Promise!
	
	request-data =
		passkey: config.image-server-passkey
		'image-name': image-name
		'user-id': user.id
	
	url = "http://#{config.image-server-ip}:#{config.image-server-port}/delete-#{type}"

	request.post {url: url, form-data: request-data} (err, res, body) ->
		if err
			console.log err
			reject err
		else
			resolve!
