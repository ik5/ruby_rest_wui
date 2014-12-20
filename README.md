REST Web User Interface
=======================

The following project was created in order to help debug and check REST based
API.

The system itself provide a self test mechanisem for some of the supported
requests.


How it works ?
--------------

The main get request (that is /) provides a user interface that allow to choose
the method, full address, parameters, mime type and body to send.

After sending the information, the data that is returned is printed in the user
interface fields, and allow you to get all the proper information back.


Self Test
---------

The system provide simple self test mechanisem that allow to do GET, POST, PUT
and DELETE requests, supporting "regular" mime types, json and XML.

The PUT and DELETE must have an id of some sort in order to work:

Existed checks:
* /test_get, /test_post, /test_put/:id, /test_delete/:id
* /test_json
* /test_xml

If you pass parameters for them, then the parameters will be returned


License:
--------
The project is released under the MIT license

