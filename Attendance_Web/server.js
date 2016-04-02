var express = require('express');
var app = express();
var http = require('http').createServer(app).listen('8080', function()
{
    console.log('Server running.');
});

// Express routing directive.
// Put all your HTML, CSS, JavaScript, etc. files in '/public_html'.
// This works just like a normal webserver, a la Apache.
app.use(express.static(__dirname + '/public'));
