# Attendance API

An API providing read-only access to the data in the Attendance System .

## Table of Contents

## Endpoints

### Attendance

#### <code>GET</code> /api/attendance

Retrieve all of the attendance records

Example:

http://attendance-cuwcs.herokuapp.com/api/attendance

#### <code>GET</code> /api/attendance/className/:class_name

Retrieve the attendance records for the class specified by name

Example:

http://attendance-cuwcs.herokuapp.com/api/className/CSC518

#### <code>GET</code> /api/attendance/instructor/:instructor

TODO: Fix this route to support instructor JSON Objects

Retrieve all of the attendance records for all classes with the provided instructor

Example:

http://attendance-cuwcs.herokuapp.com/api/instructor/Litman

#### <code>GET</code> /api/attendance/:class_name/:date

Retrieve the attendance record for the class specified by name and data

Example:

http://attendance-cuwcs.herokuapp.com/api/attendance/CSC518/2-27-16

#### <code>GET</code> /api/attendance/:first_name/:last_name

Retrieve the attendance records for a specified student (with the provided first name and last name)

Example:

http://attendance-cuwcs.herokuapp.com/api/attendance/David/Haxton

### Students

#### <code>GET</code> /api/students

Retrieve all the students enrolled in the attendance system

Example:

http://attendance-cuwcs.herokuapp.com/api/students

### Class Rosters

#### <code>GET</code> /api/roster

Retrieve all of the classes' rosters

Example:

http://attendance-cuwcs.herokuapp.com/api/roster

#### <code>GET</code> /api/roster/:class_name

Retrieve a roster for a class specified by name

Example:

http://attendance-cuwcs.herokuapp.com/api/roster/CSC518

## History

TODO: Write history

## Credits

TODO: Write credits

## License

TODO: Write license
