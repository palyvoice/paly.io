jQuery.fn.outerHTML = function() {
  return jQuery('<div />').append(this.eq(0).clone()).html();
};

var makeAPIRequest = function makeAPIRequestF (action, params) {
    var response;
    $.ajax({
	async: false,
	data: params,
	url: '/api/'+action,
	type: 'GET',
	dataType: 'json'
    }).then(function (data) {
	response = data;
    });
    return response;
};

var isValid = function isValidF (custom) {
    return makeAPIRequest('validate', { custom: custom });
};

var whatIs = function whatIsF (key) {
    return makeAPIRequest('whatis', { key: key });
};

var shortenURL = function shortenURLF (url, custom) {
    return makeAPIRequest('shorten', { url: url, custom: custom });
};

var submitURL = function submitURLF (e) {
    e.preventDefault();
    e.returnValue = false;

    var form = $('#urlform');
    var url = $('#url').val();
    var custom = $('#customurl').val();
    var messageBox = $('#message-box');

    var response = shortenURL(url, custom);

    if (response.success) {
	var newurl = host + response.response;

	var a = $('<a>', {
	    href: newurl,
	    html: newurl
	});
	messageBox.css('background-color', '#A4E7A0');
	messageBox.html('Your shortened URL is: ' + a.outerHTML());

	// clear html form fields' content and focus
	form[0].reset();
	$('#url').focus().blur();
    }
    else {
	messageBox.css('background-color', '#F0A8A8');
	messageBox.html('Error: ' + response.comment);
    }

    return false;
};
