# Campus — Student Management System

A working Next.js App Router / React / TypeScript student management project with a persistent SQLite database and responsive registrar workspace. This distribution uses Vinext (a Next.js API-compatible Cloudflare runtime), Cloudflare D1 and Drizzle migrations.

Portfolio demonstration by RowLee Tanawan. The implementation uses Next.js-compatible App Router APIs with the Vinext runtime; deployment targets Cloudflare Workers. It is not a conventional standalone `next dev` deployment.

## Features

- Dashboard: student counts, course capacity, enrollment activity, weighted grades and follow-up items.
- Students: add/edit records, searchable directory, program/year, contact/guardian/address information, Active/Inactive/Graduated status and profile history.
- Courses: code/title/instructor/academic term/credits/capacity/schedule description; open/close enrollment.
- Enrollment: capacity enforcement, unique student/course enrollment, withdrawal with retained history.
- Attendance: course/date roster, Present/Absent/Late/Excused, mark all present, save changed marks, editable daily records.
- Gradebook: final course score 0–100, validation, grade clearing and result labels.

## Technology

React, TypeScript, Next.js-compatible App Router, Vinext, Vite and responsive CSS. Cloudflare D1 SQLite and Drizzle migrations provide persistent data.

## Run locally

Node.js 22.13+ is required. Follow [installation, database initialization and walkthrough instructions](docs/SETUP.md), including the project-specific migration command. Dependencies and local database files are excluded from source control.

## Screenshots

Actual application screenshots are pending capture. No mockup is presented as a running application screenshot.

## Project layout

- `app/page.tsx`: application interface
- `app/globals.css`: responsive styling
- `app/api/`: server workflows, where applicable
- `db/` and `drizzle/`: schema and migrations, where applicable
- `docs/SETUP.md`: full setup, workflow rules and limitations

## Demo scope

Use fictional data for portfolio demonstrations. See [documented limitations](docs/SETUP.md) before deployment; authentication, payment integrations and operational safeguards vary by project and are not implied by the portfolio presentation.
