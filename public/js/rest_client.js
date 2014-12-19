
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
            done(function() {
                console.log(arguments.length);
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
