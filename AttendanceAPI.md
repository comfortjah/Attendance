# Attendance API

An API providing read-only access to the data in the Attendance System .

## Table of Contents

- [Endpoints](#endpoints)
  - [Attendance](#attendance)
    - [GET /api/attendance](#get-apiattendance)
    - [GET /api/attendance/className/:class_name](#get-apiattendanceclassnameclass_name)
    - [GET /api/attendance/className/:class_name/date/:date](#get-apiattendanceclassnameclass_namedatedate)
    - [GET /api/attendance/instructor/:first_name/:last_name](#get-apiattendanceinstructorfirst_namelast_name)
    - [GET /api/attendance/student/:first_name/:last_name](#get-apiattendancestudentfirst_namelast_name)
  - [Student](#student)
    - [GET /api/student ](#get-apistudent)
  - [Roster](#roster)
    - [GET /api/roster](#get-apiroster)
    - [GET /api/roster/className/:class_name](#get-apirosterclassnameclass_name)
- [History](#history)
- [Credits](#credits)
- [License](#license)

## Endpoints

### Attendance

#### <code>GET</code> /api/attendance

Retrieve all of the attendance records

Example:

http://attendance-cuwcs.herokuapp.com/api/attendance

---

#### <code>GET</code> /api/attendance/className/:class_name

Retrieve the attendance records for the class specified by name

Example:

http://attendance-cuwcs.herokuapp.com/api/attendance/className/CSC518

---

#### <code>GET</code> /api/attendance/className/:class_name/date/:date

Retrieve the attendance record for the class specified by name and data

Example:

http://attendance-cuwcs.herokuapp.com/api/attendance/className/CSC518/date/2-27-16

---

#### <code>GET</code> /api/attendance/instructor/:first_name/:last_name

Retrieve all of the attendance records for all classes with the specified instructor (with the provided first name and last name)

Example:

http://attendance-cuwcs.herokuapp.com/api/attendance/instructor/Mike/Litman

---

#### <code>GET</code> /api/attendance/student/:first_name/:last_name

Retrieve the attendance records for a specified student (with the provided first name and last name)

Example:

http://attendance-cuwcs.herokuapp.com/api/attendance/student/David/Haxton

---

### Student

#### <code>GET</code> /api/student

Retrieve all the students enrolled in the attendance system

Example:

http://attendance-cuwcs.herokuapp.com/api/student

---

### Roster

#### <code>GET</code> /api/roster

Retrieve all of the classes' rosters

Example:

http://attendance-cuwcs.herokuapp.com/api/roster

---

#### <code>GET</code> /api/roster/className/:class_name

Retrieve a roster for a class specified by name

Example:

http://attendance-cuwcs.herokuapp.com/api/roster/className/CSC518

---

## History

TODO: Write history

## Credits

TODO: Write credits

## License

TODO: Write license
