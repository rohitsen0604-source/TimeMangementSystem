-- PTMS Database Schema for MySQL 8 / Cloud

SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS `employee_list` (
  `id` int(30) NOT NULL AUTO_INCREMENT,
  `code` varchar(100) NOT NULL,
  `firstname` text NOT NULL,
  `middlename` text DEFAULT NULL,
  `lastname` text NOT NULL,
  `gender` varchar(50) NOT NULL,
  `email` text NOT NULL,
  `department` text NOT NULL,
  `position` text NOT NULL,
  `password` text NOT NULL,
  `generated_password` text DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `avatar` text DEFAULT NULL,
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=6;

INSERT INTO `employee_list` (`id`, `code`, `firstname`, `middlename`, `lastname`, `gender`, `email`, `department`, `position`, `password`, `generated_password`, `status`, `avatar`, `date_created`, `date_updated`) VALUES
(1, '2022-0001', 'John', 'D', 'Smith', 'Male', 'jsmith@sample.com', 'IT Department', 'Web Developer', '5f92de022efaded7349590bf1fd332a6', 'zku8jn7x', 1, 'uploads/employee-1.png?v=1641966652', '2022-01-12 13:39:50', '2022-01-12 13:50:52'),
(2, '2022-0002', 'Claire', 'D', 'Blake', 'Male', 'cblake@sample.com', 'HR Department', 'Department Manager', '19e36ca1b52bb940291854cd5cd50328', 'j295eq4f', 1, 'uploads/employee-2.png?v=1641966673', '2022-01-12 13:46:11', '2022-01-12 13:53:03'),
(4, '2022-0003', 'Mark', 'Z', 'Cooper', 'Male', 'mcooper@sample.com', 'IT Department', 'Department Manager', 'c7162ff89c647f444fcaa5c635dac8c3', '', 1, 'uploads/employee-4.png?v=1641966950', '2022-01-12 13:55:50', '2022-01-12 14:20:24'),
(5, '2022-0004', 'Samantha', 'C', 'Miller', 'Female', 'sam23@sample.com', 'HR Department', 'Office Clerk', 'b7d631291e99998916529dcaf68f05dd', '21iqfz9v', 0, 'uploads/employee-5.png?v=1641967103', '2022-01-12 13:58:23', '2022-01-12 14:04:43')
ON DUPLICATE KEY UPDATE `id`=`id`;

CREATE TABLE IF NOT EXISTS `project_list` (
  `id` int(30) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `description` text NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0= New, 1= In-Progress, 2= Closed',
  `delete_flag` tinyint(1) NOT NULL DEFAULT 0,
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=6;

INSERT INTO `project_list` (`id`, `name`, `description`, `status`, `delete_flag`, `date_created`, `date_updated`) VALUES
(1, 'Project 101', 'This is a sample project only.', 2, 0, '2022-01-12 10:59:11', '2022-01-13 09:13:55'),
(2, 'Project 102', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', 1, 0, '2022-01-12 11:33:31', '2022-01-12 15:46:14'),
(3, 'Project 103', 'Sed faucibus dictum orci quis facilisis.', 0, 0, '2022-01-12 11:33:47', NULL),
(4, 'Project 104', 'Suspendisse metus mi, vehicula ac massa a.', 0, 0, '2022-01-12 11:33:59', NULL),
(5, 'Project 105', 'Etiam ultrices, purus a blandit porta.', 0, 1, '2022-01-12 11:34:12', '2022-01-12 11:34:25')
ON DUPLICATE KEY UPDATE `id`=`id`;

CREATE TABLE IF NOT EXISTS `work_type_list` (
  `id` int(30) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `description` text NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `delete_flag` tinyint(1) NOT NULL DEFAULT 0,
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=9;

INSERT INTO `work_type_list` (`id`, `name`, `description`, `status`, `delete_flag`, `date_created`, `date_updated`) VALUES
(1, 'Support', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', 1, 0, '2022-01-12 11:30:31', NULL),
(2, 'Technical', 'Quisque congue nibh leo, vitae placerat massa fringilla eget.', 1, 0, '2022-01-12 11:31:53', NULL),
(3, 'Revision', 'Ut ultrices ex at lacinia egestas.', 1, 0, '2022-01-12 11:32:15', NULL),
(4, 'Quality Control', 'Aenean scelerisque quam ac tellus porttitor.', 1, 0, '2022-01-12 11:32:36', NULL),
(5, 'Testing', 'Suspendisse auctor diam sit amet magna sollicitudin.', 1, 0, '2022-01-12 11:33:13', NULL),
(6, 'Design', 'In vulputate, lacus at cursus pharetra.', 1, 0, '2022-01-12 11:34:54', NULL),
(7, 'Maintenance', 'Maecenas bibendum est quis lacus tincidunt porttitor.', 0, 0, '2022-01-12 11:35:14', NULL),
(8, 'Beta Testing', 'In faucibus posuere sodales.', 1, 1, '2022-01-12 11:35:31', '2022-01-12 11:35:37')
ON DUPLICATE KEY UPDATE `id`=`id`;

CREATE TABLE IF NOT EXISTS `report_list` (
  `id` int(30) NOT NULL AUTO_INCREMENT,
  `project_id` int(30) NOT NULL,
  `employee_id` int(30) NOT NULL,
  `work_type_id` int(30) NOT NULL,
  `description` text NOT NULL,
  `datetime_from` datetime NOT NULL,
  `datetime_to` datetime NOT NULL,
  `duration` float NOT NULL DEFAULT 0,
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `project_id` (`project_id`),
  KEY `employee_id` (`employee_id`),
  KEY `work_type_id` (`work_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=6;

CREATE TABLE IF NOT EXISTS `system_info` (
  `id` int(30) NOT NULL AUTO_INCREMENT,
  `meta_field` text NOT NULL,
  `meta_value` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=25;

INSERT INTO `system_info` (`id`, `meta_field`, `meta_value`) VALUES
(1, 'name', 'Online Project Time Management System - PHP'),
(6, 'short_name', 'PTMS - PHP'),
(11, 'logo', 'uploads/logo-1641955218.png'),
(13, 'user_avatar', 'uploads/user_avatar.jpg'),
(14, 'cover', 'uploads/cover-1641954928.png')
ON DUPLICATE KEY UPDATE `id`=`id`;

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(250) NOT NULL,
  `middlename` text DEFAULT NULL,
  `lastname` varchar(250) NOT NULL,
  `username` text NOT NULL,
  `password` text NOT NULL,
  `avatar` text DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `type` tinyint(1) NOT NULL DEFAULT 0,
  `status` int(1) NOT NULL DEFAULT 1 COMMENT '0=not verified, 1 = verified',
  `date_added` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=7;

INSERT INTO `users` (`id`, `firstname`, `middlename`, `lastname`, `username`, `password`, `avatar`, `last_login`, `type`, `status`, `date_added`, `date_updated`) VALUES
(1, 'Adminstrator', NULL, 'Admin', 'admin', '0192023a7bbd73250516f069df18b500', 'uploads/avatar-1.png?v=1639468007', NULL, 1, 1, '2021-01-20 14:02:37', '2021-12-14 15:47:08'),
(6, 'Claire', NULL, 'Blake', 'cblake', '4744ddea876b11dcb1d169fadf494418', 'uploads/avatar-6.png?v=1641629093', NULL, 2, 1, '2022-01-08 16:04:17', '2022-01-08 16:04:53')
ON DUPLICATE KEY UPDATE `id`=`id`;

SET FOREIGN_KEY_CHECKS = 1;
