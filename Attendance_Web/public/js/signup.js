/*
//  signup.js
//  Attendance_Web
//
//  Created by Jake Wert on 5/13/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//
//  This is the javascript for signup.html. It is responsible for
//  signing a professor up, authenticating them, and creating an
//  instructor record for them in Firebase.
*/

var signupApp = angular.module("signupApp", ["firebase"]);

signupApp.controller("SignUpController", ["$scope", "$firebaseAuth", "$http",
function($scope, $firebaseAuth, $http)
{
  var ref = new Firebase("https://attendance-cuwcs.firebaseio.com/");
  var auth = $firebaseAuth(ref);

  $scope.signup = function()
  {
    $http(
    {
        method: "post",
        url: "/signup",
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        data: $.param({"email":$scope.email, "password":sha256_digest($scope.password)})
    })
    .success(function(response)
    {
      $scope.login();
    })
    .error(function(response)
    {
      alert(response.error)
    });
  };

  $scope.login = function()
  {
    ref.authWithPassword(
      {
        email    : $scope.email,
        password : sha256_digest($scope.password)
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
        alert("Unable to complete account creation. Please have the admin remove your account before trying again.");
      }
      else
      {
        window.location.href = 'dashboard.html';
      }
    });
  };
}]);
