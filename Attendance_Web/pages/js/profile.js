var profileApp = angular.module("profileApp", ["firebase"]);

profileApp.controller("MyController", ["$scope", "$firebaseArray",
function($scope, $firebaseArray)
{
  var ref = new Firebase("https://attendance-cuwcs.firebaseio.com/");
  var authData = ref.getAuth();

  $scope.changingPassword = false;
  $scope.changingEmail = false;

  console.log(authData);

  if(authData)
  {
    $scope.changePassword = function()
    {
      if($scope.newPassword == $scope.verificationPassword)
      {
        ref.changePassword({
            "email":authData.password.email,
            "oldPassword":$scope.oldPassword,
            "newPassword":$scope.newPassword
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
              }
            });

            $scope.changeEmail = function()
            {
              ref.changeEmail({
                oldEmail: $scope.oldEmail,
                newEmail: $scope.newEmail,
                password: $scope.thePassword
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
                    console.log("Error creating user:", error);
                  }
                }
                else
                {
                  console.log("User email changed successfully!");
                }
              });
            };

            $scope.logout = function()
            {
              ref.unauth();
              window.location.href = "login.html";
            };
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
