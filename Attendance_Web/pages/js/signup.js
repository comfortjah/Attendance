var signupApp = angular.module("signupApp", ["firebase"]);

signupApp.controller("MyController", ["$scope", "$firebaseAuth",
function($scope, $firebaseAuth)
{
  var ref = new Firebase("https://attendance-cuwcs.firebaseio.com/");
  var auth = $firebaseAuth(ref);



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

        var instructorRef = ref.child("Instructors").child(userData.uid);


        instructorRef.set(
        {
          firstName: $scope.firstName,
          lastName: $scope.lastName,
        });
      }
    });
  }
}]);
