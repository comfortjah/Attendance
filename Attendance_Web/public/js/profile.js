var profileApp = angular.module("profileApp", ["firebase"]);

profileApp.controller("MyController", ["$scope", "$firebaseArray",
function($scope, $firebaseArray)
{
  var ref = new Firebase("https://attendance-cuwcs.firebaseio.com/");
  var authData = ref.getAuth();

  console.log(authData);

  if(authData)
  {
    $scope.logout = function()
    {
      ref.unauth();
      window.location.href = "login.html";
    };

    $scope.changePassword = function()
    {
      if($scope.newPassword == $scope.verificationPassword)
      {
        ref.changePassword(
          {
            "email":authData.password.email,
            "oldPassword":sha256_digest($scope.oldPassword),
            "newPassword":sha256_digest($scope.newPassword)
          }, function(error)
            {
              if (error)
              {
                switch (error.code)
                {
                  case "INVALID_PASSWORD":
                  console.log("The specified user account password is incorrect.");
                  break;
                  case "INVALID_USER":
                  console.log("The specified user account does not exist.");
                  break;
                  default:
                  console.log("Error changing password:", error);
                }
              }
              else
              {
                console.log("User password changed successfully!");

                $scope.oldPassword = "";
                $scope.newPassword = "";
                $scope.verificationPassword = "";

                $scope.$apply();
              }
            });
      }
      else
      {
        console.log("New Passwords do not match");
      }
    };
  }
  else
  {
    window.location.href = "login.html";
  }
}]);
