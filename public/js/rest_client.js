
var restClient = function() {
    var self = this;

    self.method              = ko.observable('GET');
    self.address             = ko.observable();
    self.format              = ko.observable();
    self.content             = ko.observable();

    self.return_code         = ko.observable();
    self.return_content_type = ko.observable();
    self.answer              = ko.observable();
};

$(function(){
    ko.applyBindings(new restClient());
});
