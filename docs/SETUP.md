# Campus — Student Management System

A working Next.js App Router / React / TypeScript student management project with a persistent SQLite database and responsive registrar workspace. This distribution uses Vinext (a Next.js API-compatible Cloudflare runtime), Cloudflare D1 and Drizzle migrations.

## Included modules

- Dashboard: student counts, course capacity, enrollment activity, weighted grades and follow-up items.
- Students: add/edit records, searchable directory, program/year, contact/guardian/address information, Active/Inactive/Graduated status and profile history.
- Courses: code/title/instructor/academic term/credits/capacity/schedule description; open/close enrollment.
- Enrollment: capacity enforcement, unique student/course enrollment, withdrawal with retained history.
- Attendance: course/date roster, Present/Absent/Late/Excused, mark all present, save changed marks, editable daily records.
- Gradebook: final course score 0–100, validation, grade clearing and result labels.
- Reports: credit-weighted averages, attendance rates, student summaries, CSV export and print-friendly unofficial academic report.
- Sample campus: 12 fictional students, 4 courses, 42 enrollments and 126 attendance records.

## Requirements

Node.js 22.13 or newer, npm and internet access for the initial dependency installation. Use the included package-lock.json. The source is suitable for Windows, macOS and Linux with current Node installed.

## Local setup

1. Extract this ZIP. Open a terminal in the `campus-students` folder containing package.json.
2. Install:

   `npm ci`

3. Build:

   `npm run build`

4. Initialize the local database schema (once per fresh local database):

   `npx wrangler d1 execute site-creator-d1 --local --config dist/server/wrangler.json --persist-to .wrangler/state --file drizzle/0000_acoustic_betty_ross.sql`

5. Run:

   `npm start`

6. Open the localhost URL printed in the terminal, normally http://127.0.0.1:8787.
7. Click **Load sample campus**, or add students/courses manually.

For development with hot reload, use `npm run dev` after schema initialization. The Vite Cloudflare environment persists data under `.wrangler/state`. If its configuration uses a separate persistence location, initialize that local binding using the included SQL and the same configuration/persistence path as the server. The build/start sequence above uses an explicit persistence path.

## Walkthrough

1. Students: add a student, then open their record. Edit contacts or change the status.
2. Courses: add a course with an academic term and capacity. Course code is unique within a term.
3. Enrollment: select an Active student and an Open course. Duplicate enrollment and full courses are rejected.
4. Attendance: select the course and today's date, assign marks or Mark all present, then Save attendance. Records can be changed on the same date without duplicates.
5. Gradebook: select a course, enter a final grade, then Save grade. Blank clears a grade.
6. Reports: filter by term, view academic metrics, export records and print an individual student's summary.

## Business rules

- Student email is unique; student IDs are generated automatically and remain stable.
- Birth dates must be before today; years are 1–6.
- Courses require 1–12 credits and capacity 1–500.
- Course details are immutable once enrollment history exists. Create another course/term rather than changing historical credits, title or term. Open/Closed controls new enrollments only.
- A student can have one enrollment record for a course. Withdrawal releases capacity and preserves grade/attendance history. Withdrawal is terminal in this demo; reenrollment in that same course is blocked. Create the course under a new term for a repeat attempt.
- Inactive/Graduated students cannot receive new enrollments or attendance marks. Their existing records remain available. Registrar grade updates can still be made for current enrollments.
- Attendance is unique by enrollment and date. Dates cannot be in the future or precede enrollment in Manila calendar time. The schedule is descriptive; it does not automatically restrict attendance to weekdays or sessions.
- Grades use a 0–100 scale; demo passing score is 75. Institutions must adapt grading policies before official use.
- Weighted average = sum(score × course credits) / sum(credits) for graded Enrolled records. This is a percentage score, not a 4.0 GPA.
- Attendance rate = (Present + Late) / (Present + Late + Absent). Excused records are excluded. Unrecorded days are not counted as absences.
- Individual summaries show all terms and all recorded attendance, including retained withdrawn-course attendance. Student rows in the term report use current enrollments for their attendance rate; overall term attendance metrics cover all recorded marks in that term.

## Validation

`npx tsc --noEmit`

`node tests/workflows.mjs`

`npm run build`

The workflow test runs the actual route implementation against isolated in-memory SQLite with transactional batch behavior. It checks seed data, uniqueness/capacity, course-history locking, grade ranges/clearing, attendance updates and date/status restrictions, withdrawal history, duplicate enrollment and course closure. It does not alter the app's database. Browser interaction tests are not included.

## Source map

- `app/page.tsx`: registrar UI, dialogs, rosters, exports and print summary.
- `app/globals.css`: responsive theme and print stylesheet.
- `app/api/school/route.ts`: server validation and database operations.
- `db/schema.ts`: students, courses, enrollments and attendance tables.
- `drizzle/`: SQLite migration and generated metadata.
- `tests/workflows.mjs`: API workflow tests.
- `vite.config.ts`, `build/`, `scripts/`: Cloudflare Worker / Next.js-compatible runtime.
- `.openai/hosting.json`: D1 binding DB; hosted Site identity is removed from this ZIP.

## API overview

GET `/api/school` returns the staff datasets.

GET `/api/school?studentId=ID` returns the student's profile, enrollment/grade history and attendance.

POST `/api/school` accepts JSON with `action`:

- student: name, email, phone, birthDate, program, year, guardian, address; optional id for update.
- studentStatus: id, status (Active, Inactive, Graduated).
- course: code, title, instructor, term, credits, capacity, schedule; optional id updates a course with no enrollment history.
- courseStatus: id, status (Open or Closed).
- enroll: studentId, courseId.
- withdraw: id (enrollment ID).
- grade: id (enrollment ID), score (0–100 number or null).
- attendance: courseId, day (YYYY-MM-DD), rows [{enrollmentId, status}].
- seed: sample records only when no students exist.

Validation is server-side. Enrollment's capacity check is inside the INSERT, and duplicate enrollment/daily attendance are protected by database uniqueness constraints. Bulk attendance is saved through a transactional D1 batch.

## Deployment and scope

The private hosted app provisions D1 and applies migrations. For independent Cloudflare deployment, create a D1 database, bind it as DB, apply remote migrations, configure the built Worker/static assets and deploy. Replace the local placeholder database ID. The app uses Next.js App Router conventions with a Cloudflare-specific D1 adapter; plain `next start` requires adapting the database/runtime configuration.

This is a functional private registrar demo, without application-level staff authentication or role authorization. Keep it private and use fictional data. Before commercial/public use, add staff login and API authorization, audit logs, backups/recovery, privacy and retention controls, rate limiting and production security tests. Summaries are unofficial and do not implement an institution's official transcript or grading accreditation rules.

It does not include tuition/accounting, online payments, document/photo uploads, notifications, admission workflows, timetable conflict resolution, teacher payroll, student/guardian login or assignment/LMS features. Instructor names and programs are text fields, not separate staff/program catalogs. Attendance is marked by date, not by class meeting/session. Reports use loaded limits: 2,000 students, 500 courses, 5,000 enrollments and 10,000 attendance records. Individual profiles load their complete history. No automatic email is sent when records change.
