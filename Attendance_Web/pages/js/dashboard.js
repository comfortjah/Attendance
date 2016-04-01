var dashboardApp = angular.module("dashboardApp", ["firebase"]);

dashboardApp.controller("MyController", ["$scope", "$firebaseArray", "$filter",
function($scope, $firebaseArray, $filter)
{
  var ref = new Firebase("https://attendance-cuwcs.firebaseio.com/");
  var refClasses = ref.child("Classes");

  var authData = ref.getAuth();

  $scope.addingClass = false;

  if (authData)
  {
    console.log(authData);

    var refInstructors = ref.child('Instructors');
    refInstructors.once("value", function(data)
    {
      var theInstructors = data.val();

      angular.forEach(theInstructors, function(value, key)
      {
        if(authData.uid == key)
        {
          console.log(key + " : " + value);
          $scope.professor = value.lastName;
        }
      });
    });

    $scope.theClasses = $firebaseArray(refClasses);
    console.log($scope.theClasses);
    $scope.theRoster;

    var refAllStudents = ref.child("Students");

    $scope.allStudents = $firebaseArray(refAllStudents);

    var refRoster;
    $scope.selectClass = function(obj)
    {
      refRoster = refClasses.child(obj.$id).child('Roster');
      $scope.theRoster = $firebaseArray(refRoster);
      $scope.theClassName = obj.className;
    };

    $scope.addingStudent = false;

    $scope.addStudent = function(theStudent)
    {
      if(theStudent != null)
      {
        refRoster.child(theStudent.$id).set(
          {
            "firstName":theStudent.firstName,
            "lastName":theStudent.lastName
          }
        );
      }
      else
      {
      }

      $scope.addingStudent = false;
    };

    $scope.removeStudent = function(theStudent)
    {
      theRoster.$remove(theStudent);
      console.log(theStudent);

      console.log("removing " + theStudent.firstName + " " + theStudent.lastName);
    };

    $scope.addClass = function()
    {
      var days = "";
      angular.forEach($scope.days, function(value, index)
      {
        //this.push(key + ': ' + value);
        days = days + value;
      });

      var theNewClass =
      {
        "CRN":$scope.CRN,
        "room":$scope.building + " " + $scope.roomNumber,
        "className":"CSC " + $scope.courseNumber,
        "days":days,
        "startTime":$filter('date')($scope.startTime, "h:mm a"),
        "endTime":$filter('date')($scope.endTime, "h:mm a"),
        "instructor":$scope.professor
      };

      //$scope.theClasses.$add(theNewClass);

      $scope.addingClass = false;

      $scope.CRN = null;
      $scope.building = null;
      $scope.roomNumber = null;
      $scope.courseNumber = null;
      $scope.days = null;
      $scope.startTime = null;
      $scope.endTime = null;
    };

    $scope.removeClass = function(theClass)
    {
      $scope.theRoster = null;
      $scope.theClasses.$remove(theClass);
    };

    $scope.logout = function()
    {
      ref.unauth();
      window.location.href = 'login.html';
    };
  }
  else
  {
    window.location.href = 'login.html';
  }

}]);
