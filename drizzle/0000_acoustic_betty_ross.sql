CREATE TABLE `attendance` (
	`id` text PRIMARY KEY NOT NULL,
	`enrollment_id` text NOT NULL,
	`day` text NOT NULL,
	`status` text NOT NULL,
	`updated_at` text NOT NULL,
	FOREIGN KEY (`enrollment_id`) REFERENCES `enrollments`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `enrollment_day_uq` ON `attendance` (`enrollment_id`,`day`);--> statement-breakpoint
CREATE TABLE `courses` (
	`id` text PRIMARY KEY NOT NULL,
	`code` text NOT NULL,
	`title` text NOT NULL,
	`instructor` text NOT NULL,
	`term` text NOT NULL,
	`credits` integer NOT NULL,
	`capacity` integer NOT NULL,
	`schedule` text NOT NULL,
	`status` text DEFAULT 'Open' NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `course_code_term_uq` ON `courses` (`code`,`term`);--> statement-breakpoint
CREATE TABLE `enrollments` (
	`id` text PRIMARY KEY NOT NULL,
	`student_id` text NOT NULL,
	`course_id` text NOT NULL,
	`status` text DEFAULT 'Enrolled' NOT NULL,
	`score` real,
	`created_at` text NOT NULL,
	FOREIGN KEY (`student_id`) REFERENCES `students`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`course_id`) REFERENCES `courses`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `student_course_uq` ON `enrollments` (`student_id`,`course_id`);--> statement-breakpoint
CREATE TABLE `students` (
	`id` text PRIMARY KEY NOT NULL,
	`code` text NOT NULL,
	`name` text NOT NULL,
	`email` text NOT NULL,
	`phone` text NOT NULL,
	`birth_date` text NOT NULL,
	`program` text NOT NULL,
	`year` integer NOT NULL,
	`guardian` text NOT NULL,
	`address` text NOT NULL,
	`status` text DEFAULT 'Active' NOT NULL,
	`created_at` text NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `student_code_uq` ON `students` (`code`);--> statement-breakpoint
CREATE UNIQUE INDEX `student_email_uq` ON `students` (`email`);