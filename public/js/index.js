$('#customurl').typing({
    stop: function (event, $elem) {
	var custom = $elem.val();
	var validBox = $('.message-box.valid');

	var response = isValid(custom);

	if (response.success) {
	    validBox.addClass('ok');
	}
	else {
	    validBox.addClass('error');
	}
	validBox.html(response.comment);
    },
    delay: 400
});

$(document).ready(function () {
    $('#urlform').submit(submitURL);
    $('#submit').click(submitURL);
});
