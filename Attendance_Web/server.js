var express = require('express');
var app = express();
app.set('port', (process.env.PORT || 5000));
var http = require('http').createServer(app).listen(app.get('port'), function()
{
    console.log('Server running.');
});

// Express routing directive.
// Put all your HTML, CSS, JavaScript, etc. files in '/public_html'.
// This works just like a normal webserver, a la Apache.
app.use(express.static(__dirname + '/public'));
