var indexApp = angular.module("indexApp", ["firebase"]);

indexApp.controller("MyController", ["$scope", "$firebaseArray",
function($scope, $firebaseArray)
{
  var ref = new Firebase("https://attendance-cuwcs.firebaseio.com/");
  var authData = ref.getAuth();
  if(authData)
  {
    $scope.authenticated = true;
  }
  else
  {
    $scope.authenticated = false;
  }

  var refClasses = new Firebase("https://attendance-cuwcs.firebaseio.com/Classes");
  var refClassDates;
  var refDate;

  $scope.classes = $firebaseArray(refClasses);

  $scope.selectClass = function(obj)
  {
    $scope.theClassName = obj.className;
    $scope.selectedDate = null;
    $scope.classDates = null;
    $scope.theAttendance = null;

    refClassDates = refClasses.child(obj.$id).child("Attendance");
    $scope.classDates = $firebaseArray(refClassDates);
  }

  $scope.displayAttendance = function(dateSelection)
  {
    refDate = refClassDates.child(dateSelection.$id);
    $scope.theAttendance = $firebaseArray(refDate);
  }

  $scope.logout = function()
  {
    ref.unauth();
    window.location.reload();
  };
}]);
