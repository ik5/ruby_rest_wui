
function RestRoutingViewModel() {
    var self = this;

    self.available_method    = ko.observableArray(['GET',
                                                   'POST',
                                                   'PUT',
                                                   'DELETE',
                                                   'OPTIONS',
                                                   'HEAD',
                                                   'TRACE',
                                                   'CONNECT'
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

    };
}

var rest_client;
$(function(){
    rest_client = new RestRoutingViewModel();
    ko.applyBindings(rest_client);
});
