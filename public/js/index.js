$('#customurl').typing({
    stop: function (event, $elem) {
	var custom = $elem.val();
	var validBox = $('#valid-box');

	var response = isValid(custom);

	if (response.success) {
	    validBox.css('background-color', '#A4E7A0');
	}
	else {
	    validBox.css('background-color', '#F0A8A8');
	}
	validBox.html(response.comment);
    },
    delay: 400
});

$(document).ready(function () {
    $('#urlform').submit(submitURL);
    $('#submit').click(submitURL);
});
