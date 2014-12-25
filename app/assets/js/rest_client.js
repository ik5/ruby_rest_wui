
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
    self.field_key           = ko.observable();
    self.field_value         = ko.observable();
    self.field_selected      = ko.observable();
    self.content             = ko.observable();
    self.storedItems         = ko.observableArray();

    self.answer              = ko.observableArray();

    self.can_send = function() {
        if (self.address() === undefined) {
            return false;
        }
        return _.isEmpty(self.address().trim()) === false;
    };

    self.is_add_available = function() {
        var field_key   = self.field_key();
        var field_value = self.field_value();
        return field_key !== undefined && field_key !== null &&
            ! _.isEmpty(field_key) &&
            _.indexOf(self.field_list(), field_key + '=' + field_value) === -1;
    };

    self.is_remove_available = function() {
        var selected = self.field_selected();
        return selected !== undefined && _.indexOf(self.field_list(), selected) > -1;
    };

    self.have_storage = function() {
        return typeof(Storage) !== 'undefined';
    };

    self.list_requests = function() {
        if (! self.have_storage()) {
            return ;
        }

        self.storedItems(localStorage.stored_requests || []);
    };

    self.save_request = function() {
        if (! self.have_storage()) {
            report_error('Your browser does not support local storage');
            return;
        }
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
                $('#messages').addClass('hide');

            }).
        error(function(data){
            self.answer([{key: 'Error', value: 'There was an error with the request'},
                         {key: 'code', value: data.status},
                         {key: 'statusText', value: data.statusTest},
                         {key: 'responseText', value: data.responseText},
                         {key: 'readyState', value: data.readyState},
            ]);
            report_error('Unable to communicate with the server, or bad error code');
        });

    };
}

var rest_client;
$(function(){
    rest_client = new RestRoutingViewModel();
    ko.applyBindings(rest_client);
});
