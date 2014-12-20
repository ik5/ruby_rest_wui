function show_message(style, title, message) {
    var msg_div = $('#messages');

    if (msg_div.children().length === 0) {
       var alert_box = $('<div id="alert_box" data-alert class="alert-box"/>');
       var close     = $('<a class="close">&times;</a>');
       var msg_title = $('<strong id="message_title" />');
       var msg       = $('<span id="message_content" />');

       alert_box.append(msg_title);
       alert_box.append(msg);

       alert_box.append(close);
       msg_div.append(alert_box);
    }

    $('#message_title').text(title);
    $('#message_content').text(message);
    $('#alert_box').removeClass('info success warning alert');
    $('#alert_box').addClass(style);
    $('#messages').removeClass('hide');
}


function report_error(message) {
    show_message('alert', 'Error: ', message);
}

function report_success(message) {
    show_message('success', 'Success: ', message);
}

function report_warning(message) {
    show_message('warning', 'Warning: ', message);
}
