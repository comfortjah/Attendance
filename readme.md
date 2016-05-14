# Attendance

Raspberry Pi/RFID based student attendance system with Web and iOS components.

## Table of Contents

- [Project Overview](#project-overview)
  - [Problem Definition](#problem-definition)
  - [Objectives](#objectives)
    - [Simplify Attendance Taking Process](#simplify-attendance-taking-process)
    - [Prepare for Banner Inegration](#prepare-for-banner-integration)
  - [Justification](#justification)
    - [Specific to CUW CS Department](#specific-to-cuw-cs-department)
    - [Impression on Visitors and Prospective Students](#impression-on-visitors-and-prospective-students)
- [Installation](#installation)
  - [iOS Client](#ios-client)
  - [Web Client & Server](#web-client--server)
  - [Raspberry Pi](#raspberry-pi)
- [Dependencies](#dependencies)
  - [Swift](#swift)
  - [Java](#java)
  - [AngularJS](#angularjs)
  - [Node.js](#nodejs)
- [Usage](#usage)
- [API](#api)
- [Future Work](#future-work)
- [History](#history)
- [Credits](#credits)

## Project Overview

### Problem Definition

As it stands, the process for taking attendance at Concordia is inconsistent and annoying. It can change year to year and requires professors to take head counts of their students. Most students show up to class on time, but if someone is late to class, they will miss the head count. If the professor didn’t notice a student who was in class, they will be marked absent. The professor has to keep track of these occurrences. This traditional method of attendance taking places unnecessary responsibility on the professor.

### Objectives

#### Simplify Attendance Taking process

Rather than head counts, students should become responsible for themselves. In this proposed solution, the student scans his or her student ID on the RFID reader when they enter the class. The professor will still have to enter the attendance into the Banner system, as he or she currently does, but will no longer need to take a head count. Instead the professor can let the Raspberry Pi and the database keep track of students in attendance, and view the records with their phone or from a website.

#### Prepare for Banner Integration

Perhaps the most effective way to accomplish these objectives would be to develop a system that integrates directly with Banner. Unfortunately, there is too much red tape to accomplish that. That is a future goal of this project. This project will be documented so that when that tape has been crossed, someone can integrate this attendance system with Banner.

### Justification

#### Specific to CUW CS Department

The Computer Science department could surely find an attendance system already created and ready to use. That is not the only value of this project. I have spent four years as a computer science student at Concordia. This project is being specifically designed and optimized for Concordia’s computer science department.

#### Impression on Visitors and Prospective Students

On top of that, one of the other values of the project is to make an impression on visitors and prospective students. This isn’t a revolutionary idea. However, this is exactly the kind of project a well studied computer science student could take on, if he or she were to attend Concordia.

## Installation

Download the package above and follow the instructions for each component below.

### iOS Client

The Attendance_iOS folder is an Xcode project utilizing Cocoapods. You will need to open *Attendance_iOS.xcworkspace*, **NOT** *Attendance_iOS.xcproj*, otherwise the installed libraries (pods) will not be usable.

If it is your first time running the project, there is a chance a Cocoapods bug will be unable to import the libraries without a successful build first. If Xcode indicates it cannot find or load a module, do your best to comment out all references to that library and run/build the project before uncommenting them.

If you can successfully build the project, it can be installed to any iOS device plugged into the Mac with this project (as long as they allow apps from the developer account in their phone settings).

This app will also work on iPads, but is visually designed with the iPhone in mind.

### Web Client & Server

I've successfully hosted this server on heroku, but I'm sure it is possible to do so with another hosting service that supports Node.js. Hopefully [this guide](https://devcenter.heroku.com/articles/deploying-nodejs "Deploying Node.js Apps on Heroku") will assist you. Otherwise this project, in its state as of 5/13/16 will be hosted at http://attendance-cuwcs.herokuapp.com.

All pages are in the *public* folder. Their respective javascript and css files are in *public/js* and *public/css*. The Node.js server will only serve pages and files that abide by the current folder structure, unless you alter the Node.js server.

*package.json* contains the Node.js modules heroku will need to install when running the server. The *node_modules* folder is only used for local hosting. The Procfile informs heroku that the Node.js server is *server.js*.

### Raspberry Pi

The Raspberry Pi has a scheduled reboot at 12:00 AM every day and runs *AttendanceLauncher.sh*, a shell script, on start up. Everything needed for the Raspberry Pi is in its respective folder. The *Attendance_Java* folder is the source code for *attendance.jar* an exported runnable jar file created with Eclipse.

Few (if any) changes would need to be made to the source code; however, if any are made, be sure to configure the build path to include the external .jar files in *Attendance_Java/libs*. *joda-time-2.93-javadoc.jar* and *joda-time-2.93-sources.jar* are not libraries, but the source and javadoc for joda-time-2.9.3. You may optionally add them to the joda-time library you configure in the build path. If you would also like the Firebase javadoc, you will need to enter https://www.firebase.com/docs/java-api/javadoc/.

## Dependencies

### Swift

- [*AlamoFire*](https://github.com/Alamofire/Alamofire)

- [*AlamoFireSwiftyJSON*](https://github.com/SwiftyJSON/Alamofire-SwiftyJSON)

- [*CryptoSwift*](https://github.com/krzyzanowskim/CryptoSwift)

- [*Firebase*](https://www.firebase.com/docs/ios/quickstart.html)

- [*SwiftyJSON*](https://github.com/SwiftyJSON/SwiftyJSON)

### Java

- [*Firebase*](https://cdn.firebase.com/java/firebase-client-jvm-2.5.2.jar)

- [*joda-time*](https://github.com/JodaOrg/joda-time/releases)

### AngularJS

- [*Sha256.js*](http://www.bichlmeier.info/sha256.js)

### Node.js

- [*body-parser*](https://www.npmjs.com/package/body-parser)

- [*express*](https://www.npmjs.com/package/express)

- [*firebase*](https://www.npmjs.com/package/firebase)

NOTE: Include these in *package.json* as in the above source code. If you want to run the Node.js server locally, run

```bash
npm install
```

in the directory with your terminal or command prompt. This will install all of the dependencies in node_modules.

You may also download them manually.

## Usage

See the [Attendance Documentation](/AttendanceDoc.md).

## API

The computer science students of Concordia make projects like this one from time to time. Providing them access to the attendance data via an API could definitely spark some creativity.

See the [API Documentation](/AttendanceAPI.md).

## Future Work

### Report Generation

The faculty of the Computer Science department at Concordia have spoken and would greatly benefit from a report generation from these attendance records. I'm not sure how I would solve this problem quite yet, but it is definitely something that will complement the current system.

### Push Notifications

Push Notifications could pop up on the iOS devices when class is over almost as a reminder to the professor to enter the attendance. Not only that, but the push notification could open up to a view of the attendance, maximizing the convenience of the current process.

### Alerts

Alerts could be sent to the professor or student via email. Maybe a student has missed 5 classes in a row, which triggers an alert. It could email the student and professor notifying them of this pattern, helping facilitate better communication between professor and students as well as better class attendance.

### Additional Polishing

The iOS app and Node.js server could use some polishing perhaps. See the repository's [issues](/../../issues/) for additional information.

## History

| Version  | Date    | Activity                                            |
|:--------:|:-------:|:---------------------------------------------------:|
| 1.0      | 5/13/16 | Jake Wert released v1.0 of Attendance to Dr. Litman |

## Credits

Thank you to the Computer Science department at Concordia University Wisconsin for the opportunity to create something useful and for the knowledge to do so as well.
