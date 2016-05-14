# Attendance Documentation

## Table of Contents

  - [Attendance_iOS](#attendance_ios)
    - [AddClassVC.swift](#addclassvcswift)
    - [AddStudentVC.swift](#addstudentvcswift)
    - [AttendanceVC.swift](#attendancevcswift)
    - [AuthVC.swift](#authvcswift)
    - [ClassesVC.swift](#classesvcswift)
    - [ClassVC.swift](#classvcswift)
    - [SignUpVC.swift](#signupvcswift)
  - [Attendance_Java](#attendance_java)
    - [`public class AttendanceLauncher`](#public-class-attendancelauncher)
    - [`public class AuthenticationHandler implements AuthResultHandler`](#public-class-authenticationhandler-implements-authresulthandler)
    - [`public class CardReaderThread extends Thread`](#public-class-cardreaderthread-extends-thread)
    - [`public class ClassListener extends TimerTask`](#public-class-classlistener-extends-timertask)
    - [`public class ClassListener extends TimerTask`](#public-class-classlistener-extends-timertask-1)
    - [`public class Dates`](#public-class-dates)
    - [`public class FirebaseDAO implements ValueEventListener`](#public-class-firebasedao-implements-valueeventlistener)
  - [Attendance_Web](#attendance_web)
    - [HTML and AngularJS](#html-and-angularjs)
      - [dashboard](#dashboard)
      - [index](#index)
      - [login](#login)
      - [profile](#profile)
      - [registerStudent](#registerstudent)
      - [signup](#signup)
    - [CSS](#css)
      - [attendance.css](#attendancecss)
      - [auth.css](#authcss)
    - [Node.js Server](#nodejs-server)
      - [server.js](#serverjs)

## Attendance_iOS

### AddClassVC.swift

This ViewController allows professors to add classes to the attendance system.

### AddStudentVC.swift

This ViewController contains a form which adds a student to a professor's class.

### AttendanceVC.swift

This ViewController displays the selected date's attendance records.

### AuthVC.swift

This class manages the account authentication process that takes place in its perspective View Controller.

### ClassesVC.swift

This ViewController manages the professor's classes.

### ClassVC.swift

This ViewController manages the selected class.

### SignUpVC.swift

This class manages the account creation process that takes place in its perspective View Controller.

## Attendance_Java

A more detailed documentation is provided for the Java classes as they are more technical, less cookie-cutter, and created 100% by me.

### `public class AttendanceLauncher`

`AttendanceLauncher` facilitates the attendance taking process.

---

### `public class AuthenticationHandler implements AuthResultHandler`

`AuthenticationHandler` authenticates the Java client with Firebase.

#### `private Firebase ref`

A reference to the Firebase database

#### `private boolean isDone`

A signal to block further action in the application until Firebase queries are complete

#### `public void authenticate(String email, String password) throws InterruptedException`

`authenticate` makes an asynchronous call to authenticate with Firebase.

#### `public void onAuthenticated(AuthData authData)`

`onAuthenticated` overrides the `AuthResultHandler` and is called when successfully authenticated with Firebase.

#### `public void onAuthenticationError(FirebaseError error)`

`onAuthenticationError` overrides the `AuthResultHandler` and is called when there is an authentication error.

---

### `public class CardReaderThread extends Thread`

`CardReaderThread` manages the the input from the card reader and communicates with its instance of `FirebaseDAO` to create attendance records.

#### `private String classKey`

The key to the class as found in Firebase

#### `private Scanner input`

The input stream used to listen for card reader input

#### `private FirebaseDAO dao`

An instance of the Firebase data access object, used for all Firebase access

---

### `public class ClassListener extends TimerTask`

#### `private CardReaderThread crt`

The thread which will be listening for input from the card reader.

`ClassKiller` is a `TimerTask`, which is to be scheduled by a `Timer`. It will be executed 20 minutes prior to the end time of class and set the `CardReaderThread`'s `classKey` to the empty string, effectively ending the attendance taking for a class.

---

### `public class ClassListener extends TimerTask`

`ClassListener` is a `TimerTask`, which is to be scheduled by a `Timer`. It will be executed 15 minutes prior to the start time of class and set the `CardReaderThread`'s `classKey` to that provided to `ClassListener`.

#### `private final String classKey`

The key to the class as found in Firebase

#### `private CardReaderThread crt`

The thread which will be listening for input from the card reader.

---

### `public class ClassManager extends Timer`

`ClassManager` creates a `ClassListener` and `ClassKiller` for each class at a set time before the class's start time. Each `ClassListener` and `ClassKiller` is scheduled and executed by the `ClassManager`.

#### `private final HashMap<String, HashMap> theClasses`

A collection of the day's classes

#### `private CardReaderThread crt`

The thread which will be listening for input from the card reader.

#### `public void scheduleClasses()`

`scheduleClasses` iterates through `theClasses` and adds each member (class) to the attendance schedule for the day.

#### `private void addClassListener(String classKey, DateTime startTime, DateTime endTime)`

`addClassListener` schedules a single class to start and end at given times.

---

### `public class Dates`

Dates is a wrapper class for DateTime, which provides any and all Date or Time functionality needed to use this attendance system.

#### `public static String dateToday()`

`dateToday` returns today's date as a String.

#### `public static String timeNow()`

`timeNow` returns a the current time as a String.

#### `public static boolean classHasEnded(String endTimeStr)`

`classHasEnded` is used to determine if a class has ended its attendance taking. It accounts for a 3 minute buffer to prevent a race condition. Because classes normally stop attendance 20 minutes before their end time, this should leave sufficient time to take attendance in the instance of a reboot mid-day.

#### `public static DateTime parseTime(String time)`

`parseTime` is used to parse a time string of format `"h:mm a"`.

---

### `public class FirebaseDAO implements ValueEventListener`

FirebaseDAO facilitates all communication (in the realm of data retrieval) with Firebase. It retrieves all of the classes in the attendance system and filters them by room and meet days.

#### `private Firebase ref`

A reference to the Firebase database

#### `private HashMap<String, HashMap> theClasses`

A collection of the day's classes

#### `private boolean isDone`

A signal to block further action in the application until Firebase queries are complete

#### `private String room`

A String representation of the classroom (e.g. `"Stuenkel 120"`)

#### `private String day`

A single character string representation of the day (e.g. Tuesday -> `"T"`, Thursday -> `"R"`)

#### `public HashMap<String, HashMap> retrieveClasses(String day, String room) throws InterruptedException`

`retrieveClasses` establishes a single event listener on the value of all classes. Then the classes are filtered on the meeting days and the room.

#### `public void addAttendanceRecord(String classKey, String date, String studentID, String time)`

`addAttendanceRecord` creates a new attendance record for the class corresponding to `classKey`, for the day `date` at the time `time`.

#### `public void onCancelled(FirebaseError error)`

`onCancelled` overrides the `ValueEventListener`'s method and is fired when a query to Firebase is canceled.

#### `public void onComplete(FirebaseError error, Firebase ref)`

`onComplete` overrides the `ValueEventListener`'s method and is fired when a query to Firebase is completed.

---

## Attendance_Web

### HTML and AngularJS

Each HTML page has a corresponding AngularJS file to accomplish the problems they need to solve.

#### dashboard

*dashboard.html* and *dashboard.js* are responsible for most of the professor only features such as adding a class, removing a class, adding a student to a class, and removing a student from a class.

#### index

*index.html* and *index.js* are responsible for displaying all classes enrolled in the Attendance system and the attendance for each of those classes.

This is on the home page and requires no authentication so that professors can have quick and easy access to it. Students (unauthenticated users) may also access it.

#### login

*login.html* and *login.js* are responsible for authenticating the user and redirecting them to *dahsboard.html*.

#### profile

*profile.html* are *profile.js* are responsible for editing information regarding to the user's account. Currently it only supports password changes.

#### registerStudent

*registerStudent.html* and *registerStudent.js* are responsible for registering students for the attendance system. The page also contains a table of current students registered in the Attendance system.

#### signup

*signup.html* and *signup.js* are responsible for signing a professor up, authenticating them, and creating an instructor record for them in Firebase.

Account creation is handled by the Node.js server to limit it to faculty only. Passwords are hashed before being sent to the server.

### CSS

#### attendance.css

This is a simple CSS theme I created for the Attendance Website as a whole.

#### auth.css

This is a slightly modified login form css file I found at http://codepen.io/frytyler/share/zip/EGdtg/. I use it for *login.html* and *signup.html*

### Node.js Server

#### server.js

Server.js handles all requests made to the server. It sends static files in the *public* folder, responds to API requests with JSON, and serves a 404 page if any other request is made.

See the [API Documentation](/AttendanceAPI.md) for more information.
