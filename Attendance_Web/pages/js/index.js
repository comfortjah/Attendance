var indexApp = angular.module("indexApp", ["firebase"]);

indexApp.controller("MyController", ["$scope", "$firebaseArray",
function($scope, $firebaseArray)
{
  var refClasses = new Firebase("https://attendance-cuwcs.firebaseio.com/Classes");
  //refClasses.push({"Attendance":{"2-22-16":{"01957945":"15:05","09182341":"16:01"},"2-24-16":{"09182341":"15:02","01957945":"15:02"}},"CRN":"65421","Roster":{"0":"01957945","1":"09182341"},"building":"Stuenkel","className":"CSC 450","instructor":"Dr. Litman","meetsDays":"MWF","roomNumber":120,"timeEnd":"15:10","timeStart":"16:00"})
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
