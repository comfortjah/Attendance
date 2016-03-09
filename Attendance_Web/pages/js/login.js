var indexApp = angular.module("indexApp", ["firebase"]);

indexApp.controller("MyController", ["$scope", "$firebase",
function($scope $firebase)
{
  var ref = new Firebase("https://attendance-cuwcs.firebaseio.com/");
  var auth = $firebaseAuth(ref);

  $scope.login = function()
  {
    ref.authWithPassword(
      {
        email    : $scope.username,
        password : $scope.password
      },
      function(error, authData)
      {
        if (error)
        {
          console.log("Login Failed!", error);
        }
        else
        {
          console.log("Authenticated successfully with payload:", authData);
          //window.location.href = 'home.html'
        }
      });
  }

}]);
