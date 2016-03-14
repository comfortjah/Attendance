var dashboardApp = angular.module("dashboardApp", ["firebase"]);

dashboardApp.controller("MyController", ["$scope", "$firebaseArray",
function($scope, $firebaseArray)
{
  var ref = new Firebase("https://attendance-cuwcs.firebaseio.com/");
  var refClasses = ref.child("Classes");

  var authData = ref.getAuth();

  if (authData)
  {
    $scope.firstName = "Mike";
    $scope.theClasses = $firebaseArray(refClasses);
    console.log($scope.theClasses);

    var refStudents = ref.child("Students");
    var theStudents;
    refStudents.on("value", function(data)
    {
      theStudents = data.val();
    });

    $scope.selectClass = function(obj)
    {
      var theStudentIDs = obj.Roster;
      $scope.theRoster = [];
      $scope.theClassName = obj.className;

      angular.forEach(theStudents, function(value, key)
      {
        if (theStudentIDs.indexOf(key) != -1)
        {
          //console.log('Accepted -> ' + key + ': ' + value.firstName + ' ' + value.lastName);
          $scope.theRoster.push({id: key, firstName: value.firstName, lastName: value.lastName});
        }
        else
        {
          //console.log('Denied -> ' + key + ': ' + value.firstName + ' ' + value.lastName);
        }
      });
    };
  }
  else
  {
    window.location.href = 'login.html'
  }

}]);
