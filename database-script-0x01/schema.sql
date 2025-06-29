CREATE TABLE `USER` (
  `user_id` INT PRIMARY KEY,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `email` VARCHAR(50) UNIQUE NOT NULL,
  `password_hash` VARCHAR(50) NOT NULL,
  `phone_number` VARCHAR(10) NULL,
  `role` ENUM('guest', 'host', 'admin') NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_email` (`email`)  -- Index for fast lookups on email
);

CREATE TABLE `PROPERTY` (
  `property_id` INT PRIMARY KEY,
  `host_id` INT,
  `name` VARCHAR NOT NULL,
  `description` TEXT NOT NULL,
  `location` VARCHAR NOT NULL,
  `price_per_night` DECIMAL(10, 2) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`host_id`) REFERENCES `USER`(`user_id`),
  INDEX `idx_location` (`location`)  -- Index for fast lookups on location
);

CREATE TABLE `Booking` (
  `booking_id` INT PRIMARY KEY,
  `property_id` INT,
  `user_id` INT,
  `start_date` TIMESTAMP NOT NULL,
  `end_date` TIMESTAMP NOT NULL,
  `total_price` DECIMAL(10, 2) NOT NULL,
  `status` ENUM('pending', 'confirmed', 'canceled') NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`property_id`) REFERENCES `PROPERTY`(`property_id`),
  FOREIGN KEY (`user_id`) REFERENCES `USER`(`user_id`),
  INDEX `idx_status` (`status`)  -- Index on status for faster filtering
);

CREATE TABLE `Review` (
  `review_id` INT PRIMARY KEY,
  `property_id` INT,
  `user_id` INT,
  `rating` INTEGER CHECK (rating >= 1 AND rating <= 5),
  `comment` TEXT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`property_id`) REFERENCES `PROPERTY`(`property_id`),
  FOREIGN KEY (`user_id`) REFERENCES `USER`(`user_id`),
  INDEX `idx_rating` (`rating`)  -- Index for fast lookup on ratings
);

CREATE TABLE `Payment` (
  `payment_id` INT PRIMARY KEY,
  `booking_id` INT,
  `amount` DECIMAL(10, 2) NOT NULL,
  `payment_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `payment_method` ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
  FOREIGN KEY (`booking_id`) REFERENCES `Booking`(`booking_id`),
  INDEX `idx_payment_method` (`payment_method`)  -- Index on payment method for fast lookups
);
