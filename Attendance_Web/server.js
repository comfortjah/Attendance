

var express = require('express');
var bodyParser = require('body-parser');
var Firebase = require('firebase');

var ref = new Firebase("https://attendance-cuwcs.firebaseio.com/");

var app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.set('port', (process.env.PORT || 5000));

var http = require('http').createServer(app).listen(app.get('port'), function()
{
    console.log('Server running.');
});

// Express routing directive.
// Put all your HTML, CSS, JavaScript, etc. files in '/public'.
// This works just like a normal webserver, a la Apache.
app.use(express.static(__dirname + '/public'));

// API ROUTES
// ==========================================================
var apiRouter = express.Router();

// Manages all API Requests
apiRouter.use(function(req, res, next)
{
    // do logging
    console.log('API Request');
    next(); // make sure we go to the next routes and don't stop here
});

apiRouter.route('/attendance')
    .get(function(req, res)
    {
      var theClassesRef = ref.child('Classes');
      var allClasses;
      var theAttendance = [];

      theClassesRef.once('value', function (dataSnapshot)
      {
        allClasses = dataSnapshot.val();

        Object.keys(allClasses).forEach(function(key)
        {
          theAttendance.push(allClasses[key].Attendance);
        });

        res.json(theAttendance);
      }, function (err)
      {
        res.send(err);
      });
    });

apiRouter.route('/attendance/className/:class_name')
    .get(function(req, res)
    {
      var theClassesRef = ref.child('Classes');
      var allClasses;
      var theAttendance = [];

      theClassesRef.once('value', function (dataSnapshot)
      {
        allClasses = dataSnapshot.val();

        Object.keys(allClasses).forEach(function(key)
        {
          if(allClasses[key].className == req.params.class_name)
          {
            theAttendance.push(allClasses[key].Attendance);
          }
        });

        res.json(theAttendance);
      }, function (err)
      {
        res.send(err);
      });
    });

apiRouter.route('/attendance/instructor/:instructor')
    .get(function(req, res)
    {
      var theClassesRef = ref.child('Classes');
      var allClasses;
      var theAttendance = [];

      theClassesRef.once('value', function (dataSnapshot)
      {
        allClasses = dataSnapshot.val();

        Object.keys(allClasses).forEach(function(key)
        {
          if(allClasses[key].instructor == req.params.instructor)
          {
            theAttendance.push(allClasses[key].Attendance);
          }
        });

        res.json(theAttendance);
      }, function (err)
      {
        res.send(err);
      });
    });

apiRouter.route('/attendance/className/:class_name/date/:date')
    .get(function(req, res)
    {
      //TODO once we have dummy attendance data we will write this
      res.send(req.params.class_name + ' ' + req.params.date);
    });

apiRouter.route('/attendance/className/:class_name/:firstName/:lastName')
    .get(function(req, res)
    {
      //TODO once we have dummy attendance data we will write this
      res.send(req.params.firstName + ' ' + req.params.lastName);
    });

apiRouter.route('/students')
    .get(function(req, res)
    {
      var theStudentsRef = ref.child('Students');

      theStudentsRef.once('value', function (dataSnapshot)
      {
        res.json(dataSnapshot.val());
      },
      function (err)
      {
        res.send(err);
      });
    });

apiRouter.route('/roster')
    .get(function(req, res)
    {
      var theClassesRef = ref.child('Classes');
      var allClasses;
      var theRosters = [];

      theClassesRef.once('value', function (dataSnapshot)
      {
        allClasses = dataSnapshot.val();

        Object.keys(allClasses).forEach(function(key)
        {
          theRosters.push(allClasses[key].Roster);
        });

        res.json(theRosters);
      }, function (err)
      {
        res.send(err);
      });
    });

apiRouter.route('/roster/className/:class_name')
    .get(function(req, res)
    {
      var theClassesRef = ref.child('Classes');
      var allClasses;
      var theRosters = [];

      theClassesRef.once('value', function (dataSnapshot)
      {
        allClasses = dataSnapshot.val();

        Object.keys(allClasses).forEach(function(key)
        {
          if(allClasses[key].className == req.params.class_name)
          {
            theRosters.push(allClasses[key].Roster);
          }
        });

        res.json(theRosters);
      },
      function (err)
      {
        res.send(err);
      });
    });

// Register the routes
app.use('/api' , apiRouter);

app.use(function(req, res)
{
    //res.send(404, 'This is not the page you are looking for.');
    res.sendFile(__dirname + '/public/404.html');
});
