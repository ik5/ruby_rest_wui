
function RestRoutingViewModel() {
    var self = this;

    self.available_method    = ko.observableArray(['GET',
                                                   'POST',
                                                   'PUT',
                                                   'DELETE',
                                                   'OPTIONS',
                                                   'HEAD',
                                                   'TRACE'
                                                  ]);
    self.method              = ko.observable();
    self.address             = ko.observable();
    self.format              = ko.observable();
    self.content             = ko.observable();

    self.return_code         = ko.observable();
    self.return_content_type = ko.observable();
    self.content_length      = ko.observable();
    self.all_headers         = ko.observableArray();
    self.answer              = ko.observable();

    self.can_send = function() {
        if (self.address() === undefined) {
            return false;
        }
        return _.isEmpty(self.address().trim()) === false;
    };

    self.execRest = function() {
        var params = {method: self.method(),
                      address: self.address(),
                      format: self.format() || '',
                      content: self.content() || ''};
        $.post('/request', params).
            done(function(data, req_status, req_obj) {
                if (_.has(data, 'return_code')) {
                    self.return_code(data.return_code);
                }

                if (_.has(data, 'content_type')) {
                    self.return_content_type(data.content_type);
                }

                if (_.has(data, 'body')) {
                    self.answer(data.body);
                }

                if (_.has(data, 'content_length')) {
                    self.content_length(data.content_length);
                }

                if (_.has(data, 'all_headers')) {
                    self.all_headers(data.all_headers);
                }

            }).
        error(function(){
            console.log(arguments.length);
        });

    };
}

var rest_client;
$(function(){
    rest_client = new RestRoutingViewModel();
    ko.applyBindings(rest_client);
});
