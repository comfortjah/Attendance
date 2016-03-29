var indexApp = angular.module("indexApp", ["firebase"]);

indexApp.controller("MyController", ["$scope", "$firebaseArray",
function($scope, $firebaseArray)
{
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
}]);
