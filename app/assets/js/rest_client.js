
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
    self.storedNames         = ko.observableArray();
    self.request_name        = ko.observable();

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
            _.findIndex(self.field_list(), {key: field_key, value: field_value}) === -1;
    };

    self.is_remove_available = function(item) {
        return item !== undefined && _.findIndex(self.field_list(), item) > -1;
    };

    self.can_save_request = function() {
        return self.request_name() !== undefined && self.request_name() !== null &&
            _.isEmpty(self.request_name().trim()) === false;
    };

    self.have_storage = function() {
        return typeof(Storage) !== 'undefined';
    };

    self.list_requests = function() {
        if (! self.have_storage()) {
            return ;
        }

        //self.storedItems(localStorage.storeditems || []);
        var names = localStorage.getItem('request_names');
        if (names === undefined || names === null || _.isEmpty(names)) {
            names = [];
        } else {
            names = names.split(',');
        }
        self.storedNames(names);
    };

    self.set_request_action = function() {
        if (_.indexOf(self.storedNames(),self.request_name()) > -1) {
            return 'Update';
        } else {
            return 'Save';
        }
    };

    self.load_request = function() {
        var request = this;

        self.method(localStorage.getItem('request_name.' + request +'.method'));
        self.address(localStorage.getItem('request_name.' + request + '.address'));
        self.format(localStorage.getItem('request_name.' + request + '.format'));
        self.content(localStorage.getItem('request_name.' + request + '.content'));
        var len = localStorage.getItem('request_name.' + request + '.fields_length');
        self.field_list([]);
        for (var i = 0; i < len ; i++) {
          var key   = localStorage.getItem('request_name.' + request + '.field[' + i + '].key');
          var value = localStorage.getItem('request_name.' + request + '.field[' + i + '].value');
          var obj = {key: key, value: value};
          self.field_list.push(obj);
        }
    };

    self.save_request = function() {
        if (! self.have_storage()) {
            report_error('Your browser does not support local storage');
            return;
        }

        var len = self.field_list().length;

        if (_.indexOf(self.storedNames(), self.request_name()) === -1) {
          self.storedNames.push(self.request_name());
        }

        localStorage.setItem('request_names', self.storedNames().toString());
        localStorage.setItem('request_name.' + self.request_name() + '.method', self.method() || '');
        localStorage.setItem('request_name.' + self.request_name() + '.address', self.address() || '');
        localStorage.setItem('request_name.' + self.request_name() + '.format', self.format() || '');
        localStorage.setItem('request_name.' + self.request_name() + '.content', self.content() || '');
        localStorage.setItem('request_name.' + self.request_name() + '.fields_length', len);
        for (var i=0; i < len ; i++) {
          localStorage.setItem('request_name.' + self.request_name() + '.field[' + i +'].key', self.field_list()[i].key);
          localStorage.setItem('request_name.' + self.request_name() + '.field[' + i +'].value', self.field_list()[i].value || '');
        }
    };

    self.remove_request = function() {
        var request = this.toString();

        self.storedNames.remove(request);
        localStorage.setItem('request_names', self.storedNames().toString());

        var len = localStorage.getItem('request_name.' + request + '.fields_length');
        localStorage.removeItem('request_name.' + request +'.method');
        localStorage.removeItem('request_name.' + request + '.address');
        localStorage.removeItem('request_name.' + request + '.format');
        localStorage.removeItem('request_name.' + request + '.content');
        localStorage.removeItem('request_name.' + request + '.fields_length');
        for (var i = 0; i < len ; i++) {
          localStorage.removeItem('request_name.' + request + '.field[' + i + '].key');
          localStorage.removeItem('request_name.' + request + '.field[' + i + '].value');
        }
    };

    self.remove_field = function() {
        var selected = this;
        if (selected === undefined) {
            return report_error('No field was selected to be removed');
        }

        if (! _.isEmpty(selected)) {
            if (_.findIndex(self.field_list(), selected) > -1) {
              self.field_list.remove(selected);
            } else {
                report_error('Unable to find selected field to remove');
            }
        } else {
            report_error('The selected field to be removed is empty');
        }

    };

    self.add_field = function() {
        hide_message();
        var field_key   = self.field_key();
        var field_value = self.field_value() || '';
        if (field_key === undefined) {
            return report_error('Field key is empty');
        }

        if (! _.isEmpty(field_key.trim())) {
            var obj = {key: field_key, value: field_value};
            if (_.findIndex(self.field_list(), obj) === -1) {
                self.field_list.push(obj);
                $(document).foundation('tooltip', 'reflow');
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
                hide_message();
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

    self.list_requests();
}

var rest_client;
$(function(){
    rest_client = new RestRoutingViewModel();
    ko.applyBindings(rest_client);
});
