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

  $scope.classes = $firebaseArray(refClasses);

  $scope.selectClass = function(obj)
  {
    $scope.theClassName = obj.className;
    $scope.theClassAttendance = obj.Attendance;
    $scope.selectedDate = null;
  }

  $scope.displayAttendance = function(dateSelection)
  {
    $scope.selectedDate = dateSelection;
  }

  $scope.logout = function()
  {
    ref.unauth();
    window.location.reload();
  };
}]);
