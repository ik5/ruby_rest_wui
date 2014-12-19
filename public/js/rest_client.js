
var restClient = function() {
    var self = this;

    self.method  = ko.observable('');
    self.address = ko.observable('');
    self.format  = ko.observable('');
    self.content = ko.observable('');
};

$(function(){
    ko.applyBindings(new restClient());
});
