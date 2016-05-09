var signupApp = angular.module("signupApp", ["firebase"]);

signupApp.controller("MyController", ["$scope", "$firebaseAuth",
function($scope, $firebaseAuth)
{
  var ref = new Firebase("https://attendance-cuwcs.firebaseio.com/");
  var auth = $firebaseAuth(ref);

  $scope.login = function()
  {
    ref.authWithPassword(
      {
        email    : $scope.email,
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

          $scope.setInstructor(authData.uid);
        }
      });
  };

  $scope.setInstructor = function(uid)
  {
    var instructorRef = ref.child("Instructors").child(uid);

    instructorRef.set(
    {
      firstName: $scope.firstName,
      lastName: $scope.lastName
    },
    function(error)
    {
      if (error)
      {
        console.log("Unable to create instructor object. Please have the admin remove your account before trying again.");
      }
      else
      {
        console.log("Successfully created instructor object.");

        window.location.href = 'dashboard.html';
      }
    });
  }

  $scope.signup = function()
  {
    ref.createUser(
    {
      email    : $scope.email,
      password : $scope.password
    },
    function(error, userData)
    {
      if (error)
      {
        console.log("Error creating user:", error);
      }
      else
      {
        console.log("Successfully created user account with uid:", userData.uid);

        $scope.login();
      }
    });
  }
}]);
