
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
    self.field_list          = ko.observableArray();
    self.field_edit          = ko.observable();
    self.field_selected      = ko.observable();
    self.content             = ko.observable();

    self.answer              = ko.observable();

    self.can_send = function() {
        if (self.address() === undefined) {
            return false;
        }
        return _.isEmpty(self.address().trim()) === false;
    };

    self.is_add_available = function() {
        var field = self.field_edit();
        return field !== undefined && _.indexOf(self.field_list(), field) === -1;
    };

    self.is_remove_available = function() {
        var selected = self.field_selected();
        return selected !== undefined && _.indexOf(self.field_list(), selected) > -1;
    };

    self.remove_field = function() {
        var selected = self.field_selected();
        if (selected === undefined) {
            return report_error('No field was selected to be removed');
        }

        if (! _.isEmpty(selected.trim())) {
            if (_.indexOf(self.field_list(), selected) > -1) {
              self.field_list.remove(selected);
            } else {
                report_error('Unable to find selected field to remove');
            }
        } else {
            report_error('The selected field to be removed is empty');
        }

    };

    self.add_field = function() {
        var field = self.field_edit();
        if (field === undefined) {
            return report_error('Field Edit is empty');
        }
        if (! _.isEmpty(field.trim())) {
            if (_.indexOf(self.field_list(), field) === -1) {
                self.field_list.push(field);
            } else {
                report_error('Field alreay exists in the list');
            }
        } else {
            report_error('The field to be added is empty');
        }
    };

    self.execRest = function() {
        var params = {method: self.method(),
                      address: self.address(),
                      field_list: self.field_list(),
                      format: self.format() || '',
                      content: self.content() || ''};
        $.post('/request', params).
            done(function(data, req_status, req_obj) {
                self.answer(data);

            }).
        error(function(){
            report_error('Unable to communicate with the server');
        });

    };
}

var rest_client;
$(function(){
    rest_client = new RestRoutingViewModel();
    ko.applyBindings(rest_client);
});
