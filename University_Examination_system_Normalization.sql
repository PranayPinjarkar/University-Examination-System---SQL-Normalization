#Assignment 2: University Examination System Normalization

#Tasks (5 Total)

#Task 1: Identify Primary Key and Composite Keys 
#Primary Key for unnormalized table could be (StudentID, CourseID, ExamSemester) as together they uniquely identify a student's exam record.

#Task 2: Identify Functional Dependencies (Conceptual - no SQL)
#Example functional dependencies:
#StudentID → StudentName, DeptCode
#DeptCode → DeptName, DeptLocation
#CourseID → CourseTitle, CourseCredits, FacultyID
#FacultyID → FacultyName
#(StudentID, CourseID, ExamSemester) → Grade

#Task 3: Normalize to 1NF
use Normalization;

DROP TABLE IF EXISTS ACADEMIC_RECORD;

CREATE TABLE ACADEMIC_RECORD (
  StudentID VARCHAR(10),
  StudentName VARCHAR(100),
  DeptCode VARCHAR(10),
  DeptName VARCHAR(100),
  DeptLocation VARCHAR(100),
  CourseID VARCHAR(10),
  CourseTitle VARCHAR(100),
  CourseCredits INTEGER,
  FacultyID VARCHAR(10),
  FacultyName VARCHAR(100),
  ExamSemester VARCHAR(20),
  Grade CHAR(1),
  PRIMARY KEY (StudentID, CourseID, ExamSemester)
);

#Insert the sample data from the pdf.
INSERT INTO ACADEMIC_RECORD VALUES 
('23CS102', 'Priya Sharma', 'CS01', 'Computer Science', 'Block A, Main Campus', 'CS205', 'Data Structures', 3, 'F001', 'Dr. A Sharma', '2025-Fall', 'A'),
('23CS103', 'Arjun Mehta', 'CS01', 'Computer Science', 'Block A, Main Campus', 'CS206', 'Operating Systems', 3, 'F002', 'Dr. S Kumar', '2025-Fall', 'B'),
('23EE201', 'Neha Gupta', 'EE02', 'Electrical Engineering', 'Block B, East Campus', 'EE301', 'Circuit Theory', 4, 'F003', 'Dr. V Singh', '2025-Fall', 'A'),
('23ME045', 'Rohan Verma', 'ME01', 'Mechanical Engineering', 'Block C, Engineering Wing', 'ME302', 'Thermodynamics', 3, 'F004', 'Dr. R Patil', '2025-Fall', 'B');


#Task 4: Normalize to 2NF - Split partial dependencies
CREATE TABLE IF NOT exists STUDENT (
  StudentID VARCHAR(10) PRIMARY KEY,
  StudentName VARCHAR(100),
  DeptCode VARCHAR(10)
);

CREATE TABLE IF NOT exists DEPARTMENT (
  DeptCode VARCHAR(10) PRIMARY KEY,
  DeptName VARCHAR(100),
  DeptLocation VARCHAR(100)
);

CREATE TABLE IF NOT exists FACULTY (
  FacultyID VARCHAR(10) PRIMARY KEY,
  FacultyName VARCHAR(100)
);

CREATE TABLE IF NOT exists COURSE (
  CourseID VARCHAR(10) PRIMARY KEY,
  CourseTitle VARCHAR(100),
  CourseCredits INTEGER,
  FacultyID VARCHAR(10),
  FOREIGN KEY (FacultyID) REFERENCES FACULTY(FacultyID)
);

CREATE TABLE IF NOT exists EXAM_RESULT (
  StudentID VARCHAR(10),
  CourseID VARCHAR(10),
  ExamSemester VARCHAR(20),
  Grade CHAR(1),
  PRIMARY KEY (StudentID, CourseID, ExamSemester),
  FOREIGN KEY (StudentID) REFERENCES STUDENT(StudentID),
  FOREIGN KEY (CourseID) REFERENCES COURSE(CourseID)
);

#Insert the corresponding sample data
INSERT INTO STUDENT VALUES 
('23CS102', 'Priya Sharma', 'CS01'),
('23CS103', 'Arjun Mehta', 'CS01'),
('23EE201', 'Neha Gupta', 'EE02'),
('23ME045', 'Rohan Verma', 'ME01');

INSERT INTO DEPARTMENT VALUES
('CS01', 'Computer Science', 'Block A, Main Campus'),
('EE02', 'Electrical Engineering', 'Block B, East Campus'),
('ME01', 'Mechanical Engineering', 'Block C, Engineering Wing');

INSERT INTO FACULTY VALUES
('F001', 'Dr. A Sharma'),
('F002', 'Dr. S Kumar'),
('F003', 'Dr. V Singh'),
('F004', 'Dr. R Patil');

INSERT INTO COURSE VALUES
('CS205', 'Data Structures', 3, 'F001'),
('CS206', 'Operating Systems', 3, 'F002'),
('EE301', 'Circuit Theory', 4, 'F003'),
('ME302', 'Thermodynamics', 3, 'F004');

INSERT INTO EXAM_RESULT VALUES
('23CS102', 'CS205', '2025-Fall', 'A'),
('23CS103', 'CS206', '2025-Fall', 'B'),
('23EE201', 'EE301', '2025-Fall', 'A'),
('23ME045', 'ME302', '2025-Fall', 'B');

#Task 5: Normalize to 3NF/BCNF
#The above structure removes transitive dependencies (faculty separate linked to course, department separate linked to student) so final normalized form is achieved. No further splitting needed.

SELECT * FROM STUDENT;
SELECT * FROM DEPARTMENT;
SELECT * FROM FACULTY;
SELECT * FROM COURSE;
SELECT * FROM EXAM_RESULT;
SELECT 
  s.StudentID, s.StudentName, d.DeptName, d.DeptLocation,
  c.CourseID, c.CourseTitle, c.CourseCredits,
  f.FacultyName,
  e.ExamSemester, e.Grade
FROM EXAM_RESULT e
JOIN STUDENT s ON e.StudentID = s.StudentID
JOIN COURSE c ON e.CourseID = c.CourseID
JOIN FACULTY f ON c.FacultyID = f.FacultyID
JOIN DEPARTMENT d ON s.DeptCode = d.DeptCode;

