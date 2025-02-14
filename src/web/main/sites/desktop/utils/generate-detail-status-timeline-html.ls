require! {
	jade
	'./detail-timeline-serialyzer'
	'./parse-text'
	'../../../../../config'
}

module.exports = (statuses, viewer, callback) ->
	status-compiler = jade.compile-file "#__dirname/../views/dynamic-parts/status/detail/status.jade"
	timeline-compiler = jade.compile-file "#__dirname/../views/dynamic-parts/status/detail/timeline.jade"
	if statuses?
		detail-timeline-serialyzer statuses, viewer .then (timeline) ->
			statuses-htmls = map do
				(status) ->
					status-compiler do
						status: status
						login: viewer?
						me: viewer
						text-parser: parse-text
						config: config.public-config
				timeline
			html = timeline-compiler do
				statuses: statuses-htmls
				login: viewer?
			callback html
	else
		html = timeline-compiler do
			statuses: null
			login: viewer?
		callback html
