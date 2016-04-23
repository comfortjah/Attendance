

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
          theAttendance.push({ className:allClasses[key].className, attendance:allClasses[key].Attendance });
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
            theAttendance.push({ className:allClasses[key].className, attendance:allClasses[key].Attendance });
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
        var theClassesRef = ref.child('Classes');
        var allClasses;
        var allClassesKeys = [];
        var theClass;
        var attendanceDates;
        var theAttendance = {};

        theClassesRef.once('value', function (dataSnapshot)
        {
          allClasses = dataSnapshot.val();
          allClassesKeys = Object.keys(allClasses);

          for (var i = 0; i < allClassesKeys.length; i++)
          {
            var key = allClassesKeys[i];
            if(allClasses[key].className == req.params.class_name)
            {
              theClass = allClasses[key];
              break;
            }
          }

          try
          {
            attendanceDates = Object.keys(theClass.Attendance);

            for (var i = 0; i < attendanceDates.length; i++)
            {
              var date = attendanceDates[i];
              if(date == req.params.date)
              {
                theAttendance = theClass.Attendance[date];
              }
            }
          }
          catch (e)
          {
            //There is no attendance, return default value of {}
          }



          res.json(theAttendance);

        }, function (err)
        {
          res.send(err);
        });
      });

apiRouter.route('/attendance/instructor/:first_name/:last_name')
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
          if( (allClasses[key].instructor.firstName == req.params.first_name) && (allClasses[key].instructor.lastName == req.params.last_name) )
          {
            theAttendance.push({ className:allClasses[key].className, attendance:allClasses[key].Attendance });
          }
        });

        res.json(theAttendance);
      }, function (err)
      {
        res.send(err);
      });
    });

apiRouter.route('/attendance/student/:first_name/:last_name')
    .get(function(req, res)
    {
      var theClassesRef = ref.child('Classes');
      var allClasses;
      var studentClasses = [];

      theClassesRef.once('value', function (dataSnapshot)
      {
        allClasses = dataSnapshot.val();

        Object.keys(allClasses).forEach(function(key)
        {
          var theClass = allClasses[key];
          var theRoster = theClass.Roster;

          try
          {
            var rosterKeys = Object.keys(theRoster);
            for (var i = 0; i < rosterKeys.length; i++)
            {
              var key = rosterKeys[i];
              var theStudent = theRoster[key];
              if( (theStudent.firstName == req.params.first_name) && (theStudent.lastName == req.params.last_name) )
              {
                studentClasses.push({ className:theClass.className, attendance:theClass.Attendance });
                break;
              }
            }
          }
          catch(err)
          {
            //The Class has no roster so we shouldn't even look for a student here
          }

        });

        res.json(studentClasses);

      }, function (err)
      {
        res.send(err);
      });
    });

apiRouter.route('/student')
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
          theRosters.push({ className:allClasses[key].className, roster:allClasses[key].Roster });
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
  res.sendFile(__dirname + '/public/404.html');
});
