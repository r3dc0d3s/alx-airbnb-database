### Explanation of Our Normalization Step

In this schema, we applied the principles of **Database Normalization** to bring the structure into **3rd Normal Form (3NF)**. The goal of normalization is to eliminate redundancy, ensure data integrity, and make it easier to maintain the database.

---

#### Step-by-Step Breakdown:

### 1. **First Normal Form (1NF)**:
- **Definition**: A table is in **1NF** if it only contains atomic (indivisible) values. Each record must have a unique identifier (primary key), and each column should store one value per record.
  
  - **Why 1NF?**: The tables in the schema each follow this rule by:
    - Ensuring that each column holds only a single value (e.g., `first_name` is a single value, not a list).
    - Using a primary key (e.g., `user_id`, `property_id`) to uniquely identify records.

### 2. **Second Normal Form (2NF)**:
- **Definition**: A table is in **2NF** if it is in **1NF** and there are no **partial dependencies**. In other words, every non-key attribute must depend on the **entire primary key**, not just a part of it.
  
  - **Why 2NF?**: In our schema, each table has non-key attributes that depend on the **entire primary key**:
    - In the `PROPERTY` table, for instance, `host_id` (the foreign key) points to `user_id` in the `USER` table. Non-key attributes like `name`, `description`, `location`, etc., depend on the **entire `property_id`** and not just part of it.
    - This ensures that no column in a table depends on only part of the composite primary key.

### 3. **Third Normal Form (3NF)**:
- **Definition**: A table is in **3NF** if it is in **2NF** and there are no **transitive dependencies**. This means that non-key attributes should depend **only** on the primary key, not on each other.
  
  - **Why 3NF?**: In our schema:
    - Non-key columns are only dependent on the primary key and do not depend on other non-key columns. 
    - For example:
      - In the `USER` table, `first_name`, `last_name`, `email`, etc., depend solely on `user_id`. They do not depend on each other.
      - In the `PROPERTY` table, `name`, `description`, and `price_per_night` depend on `property_id`, and not on the `host_id` or any other non-key attribute.

### Key Steps in Achieving 3NF:

#### **Foreign Keys**:
- Foreign keys are used to establish relationships between tables while maintaining referential integrity.
  - For example, the `PROPERTY` table has a foreign key `host_id` that links to the `USER` table's `user_id`.
  - Similarly, the `Booking` and `Payment` tables reference the `PROPERTY` and `USER` tables via foreign keys.
  
  This ensures that data redundancy is avoided (e.g., instead of storing full user information in the `PROPERTY` table, we store a reference to the `USER` table via `host_id`).

#### **Eliminating Redundancy**:
- By creating separate tables for `USER`, `PROPERTY`, `Booking`, `Review`, and `Payment`, we ensure that no data is repeated across the system. For example, user information is stored only in the `USER` table, not in the `PROPERTY` or `Booking` tables.

#### **Indexes**:
- Indexes are created on frequently queried columns (e.g., `email`, `status`, `payment_method`) to speed up lookups. These indexes improve performance when retrieving records based on these fields.
  
---

### Benefits of Our 3NF Design:
- **Data Integrity**: By adhering to 3NF, the database minimizes redundancy and ensures that data is consistent and accurate.
- **Efficiency**: Smaller, normalized tables lead to faster query performance, especially with proper indexing.
- **Maintainability**: Since related data is stored in separate tables, updating or deleting records is simpler and less error-prone.
  
This normalized schema allows us to handle relationships effectively and ensures the data remains structured in a way that's easy to manage and scale.


```
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
```
