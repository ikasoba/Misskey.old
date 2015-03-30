$(function() {
	try {
		Notification.requestPermission();
	} catch (e) {

	}

	// オートセーブがあるなら復元
	if ($.cookie('post-autosave')) {
		$('#post-form textarea').val($.cookie('post-autosave'));
	}

	socket = io.connect('https://api.misskey.xyz:1207/streaming/web/home', { port: 1207 });

	socket.on('connect', function() {
		console.log('Connected');
	});

	socket.on('disconnect', function(client) {
	});

	socket.on('status', function(status) {
		console.log('status', status);
		var currentPath = location.pathname;
		currentPath = currentPath.indexOf('/') == 0 ? currentPath : '/' + currentPath;
		if (currentPath != "/i/mention") {
			new Audio('/resources/sounds/pop.mp3').play();
			var $status = $('<li class="status">').append($(status)).hide();
			TIMELINE.setEventPost($status);
			$status.prependTo($('#timeline .timeline > .statuses')).show(200);
		}
	});

	socket.on('repost', function(post) {
		console.log('repost', post);
		new Audio('/resources/sounds/pop.mp3').play();
		var $post = TIMELINE.generatePostElement(post, conf).hide();
		TIMELINE.setEventPost($post);
		$post.prependTo($('#timeline .timeline > .statuses')).show(200);
	});

	socket.on('reply', function(post) {
		console.log('reply', post);
		var currentPath = location.pathname;
		currentPath = currentPath.indexOf('/') == 0 ? currentPath : '/' + currentPath;
		if (currentPath == "/i/mention") {
			new Audio('/resources/sounds/pop.mp3').play();
			var $post = TIMELINE.generatePostElement(post, conf).hide();
			TIMELINE.setEventPost($post);
			$post.prependTo($('#timeline .timeline > .statuses')).show(200);
			var n = new Notification(post.user.name, {
				body: post.text,
				icon: conf.url + '/img/icon/' + post.user.screenName
			});
			n.onshow = function() {
				setTimeout(function() {
					n.close();
				}, 10000);
			};
			n.onclick = function() {
				window.open(conf.url + '/' + post.user.screenName + '/post/' + post.id);
			};
		}
	});

	socket.on('talk-message', function(message) {
		console.log('talk-message', message);
		var windowId = 'misskey-window-talk-' + message.user.id;
		if ($('#' + windowId)[0]) {
			return;
		}
		var n = new Notification(message.user.name, {
			body: message.text,
			icon: conf.url + '/img/icon/' + message.user.screenName
		});
		n.onshow = function() {
			setTimeout(function() {
				n.close();
			}, 10000);
		};
		n.onclick = function() {
			var url = 'https://misskey.xyz/' + message.user.screenName + '/talk?noheader=true';
			var $content = $("<iframe>").attr({ src: url, seamless: true });
			openWindow(windowId, $content, '<i class="fa fa-comments"></i>' + escapeHTML(message.user.name), 300, 450, true, url);
		};
	});

	$('#post-form').find('.image-attacher input[name=image]').change(function() {
		var $input = $(this);
		var file = $(this).prop('files')[0];
		if (!file.type.match('image.*')) return;
		var reader = new FileReader();
		reader.onload = function() {
			var $img = $('<img>').attr('src', reader.result);
			$input.parent('.image-attacher').find('p, img').remove();
			$input.parent('.image-attacher').append($img);
		};
		reader.readAsDataURL(file);
	});
	
	$(window).keypress(function(e) {
		if (e.charCode == 13 && e.ctrlKey) {
			post($('#postForm textarea'));
		}
	});
	
	$('#post-form').submit(function(event) {
		event.preventDefault();

		post($(this));
	});
	
	function post($form)
	{
		var $submitButton = $form.find('[type=submit]');

		$submitButton.attr('disabled', true);
		$submitButton.text('Updating...');

		$.ajax('https://api.misskey.xyz/status/update', {
			type: 'post',
			processData: false,
			contentType: false,
			data: new FormData($form[0]),
			dataType: 'json',
			xhrFields: {
				withCredentials: true
			}
		}).done(function(data) {
			$form[0].reset();
			$form.find('textarea').focus();
			$form.find('.image-attacher').find('p, img').remove();
			$form.find('.image-attacher').append($('<p><i class="fa fa-picture-o"></i></p>'));
			$submitButton.attr('disabled', false);
			$submitButton.text('Update');
			$.removeCookie('post-autosave');
		}).fail(function(data) {
			$form[0].reset();
			$form.find('textarea').focus();
			/*alert('error');*/
			$submitButton.attr('disabled', false);
			$submitButton.text('Update');
		});
	}

	$('#post-form textarea').bind('input', function() {
		var text = $('#post-form textarea').val();

		// オートセーブ
		$.cookie('post-autosave', text, { path: '/', expires: 365 });
	});

	$('#timeline .load-more').click(function() {
		$button = $(this);
		$button.attr('disabled', true);
		$button.text('Loading...');
		$.ajax('https://api.misskey.xyz/post/timeline', {
			type: 'get',
			data: { max_id: $('#timeline .timeline .statuses > .status:last-child').attr('data-id') },
			dataType: 'json',
			xhrFields: { withCredentials: true }
		}).done(function(data) {
			$button.attr('disabled', false);
			$button.text('Read more!');
			data.forEach(function(post) {
				var $post = TIMELINE.generatePostElement(post, conf).hide();
				TIMELINE.setEventPost($post);
				$post.appendTo($('#timeline .timeline > .statuses')).show(200);
			});
		}).fail(function(data) {
			$button.attr('disabled', false);
			$button.text('Failed...');
		});
	});
});
