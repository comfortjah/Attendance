var indexApp = angular.module("indexApp", ["firebase"]);

indexApp.controller("MyController", ["$scope", "$firebaseAuth",
function($scope, $firebaseAuth)
{
  var ref = new Firebase("https://attendance-cuwcs.firebaseio.com/");
  //var auth = $firebaseAuth(ref);
  var authData = ref.getAuth();

  if(authData)
  {
    window.location.href = 'index.html';
  }

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
          window.location.href = 'dashboard.html'
        }
      });
  }

}]);
