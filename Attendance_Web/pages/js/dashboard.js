var dashboardApp = angular.module("dashboardApp", ["firebase"]);

dashboardApp.controller("MyController", ["$scope", "$firebaseArray",
function($scope, $firebaseArray)
{
  var ref = new Firebase("https://attendance-cuwcs.firebaseio.com/");
  var refClasses = ref.child("Classes");

  var someRef = new Firebase("https://attendance-cuwcs.firebaseio.com/Classes/");
  someRef.push({"Attendance":{"2-15-16":{"01957945":"17:53","09182341":"17:53"},"2-22-16":{"09182341":"18:02","01957945":"17:57"}},"CRN":"65420","building":"Loeber","className":"CSC 518","instructor":"Litman","meetsDays":"M","roomNumber":118,"timeEnd":"22:00","timeStart":"18:00"});

  var authData = ref.getAuth();

  if (authData)
  {
    $scope.firstName = "Mike";
    $scope.theClasses = $firebaseArray(refClasses);
    $scope.theRoster;

    var refAllStudents = ref.child("Students");

    $scope.allStudents = $firebaseArray(refAllStudents);

    var refRoster;
    $scope.selectClass = function(obj)
    {
      refRoster = refClasses.child(obj.$id).child('Roster');
      $scope.theRoster = $firebaseArray(refRoster);
    };

    $scope.addingStudent = false;


    $scope.addStudent = function(theStudent)
    {
      if(theStudent != null)
      {
        refRoster.child(theStudent.$id).set(
          {
            "firstName":theStudent.firstName,
            "lastName":theStudent.lastName
          }
        );
      }
      else
      {
          console.log(theStudent);
          console.log($scope.theRoster);
      }
    }

    $scope.removeStudent = function(theStudent)
    {
      theRoster.$remove(theStudent);
      console.log(theStudent);

      console.log("removing " + theStudent.firstName + " " + theStudent.lastName);
    };

    $scope.removeClass = function(theClass)
    {
      console.log("removing " + theClass.className);
    };
  }
  else
  {
    window.location.href = 'login.html'
  }

}]);
