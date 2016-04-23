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
- [API](#api)
- [History](#history)
- [Credits](#credits)
- [License](#license)

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

TODO: Describe the installation process

## API

The computer science students of Concordia make projects like this one from time to time. Providing them access to the attendance data via an API could definitely spark some creativity.

See the [API Documentation](/AttendanceAPI.md).

## History

TODO: Write history

## Credits

TODO: Write credits

## License

TODO: Write license
