SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


DROP TABLE IF EXISTS `<<prefix>>admins`;
CREATE TABLE `<<prefix>>admins` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `username` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password_hash` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'default_user.png',
  `permission` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>balance`;
CREATE TABLE `<<prefix>>balance` (
  `id` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `current_balance` double(9,2) DEFAULT NULL,
  `total_earning` double(9,2) DEFAULT NULL,
  `total_withdrawal` double(9,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>blog`;
CREATE TABLE `<<prefix>>blog` (
  `id` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `author` int(10) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tags` text CHARACTER SET utf32 COLLATE utf32_unicode_ci,
  `status` enum('publish','pending') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'publish',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>blog_categories`;
CREATE TABLE `<<prefix>>blog_categories` (
  `id` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `title` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slug` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` int(10) NOT NULL DEFAULT '0',
  `active` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>blog_cat_relation`;
CREATE TABLE `<<prefix>>blog_cat_relation` (
  `id` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `blog_id` int(10) DEFAULT NULL,
  `category_id` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>blog_comment`;
CREATE TABLE `<<prefix>>blog_comment` (
  `id` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `blog_id` int(10) DEFAULT NULL,
  `user_id` int(10) DEFAULT NULL,
  `is_admin` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `name` tinytext COLLATE utf8mb4_unicode_ci,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `active` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `parent` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>catagory_main`;
CREATE TABLE `<<prefix>>catagory_main` (
  `cat_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` int(11) DEFAULT NULL,
  `cat_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cat_order` int(10) DEFAULT NULL,
  `slug` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon` varchar(300) NOT NULL DEFAULT 'fa-usd',
  `picture` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>countries`;
CREATE TABLE `<<prefix>>countries` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `code` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `longitude` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `iso3` char(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `iso_numeric` int(10) UNSIGNED DEFAULT NULL,
  `fips` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `asciiname` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `capital` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area` int(10) UNSIGNED DEFAULT NULL,
  `population` int(10) UNSIGNED DEFAULT NULL,
  `continent_code` char(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tld` char(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency_code` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `postal_code_format` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `postal_code_regex` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `languages` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `neighbours` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `equivalent_fips_code` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>currencies`;
CREATE TABLE `<<prefix>>currencies` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `code` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `html_entity` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'From Github : An array of currency symbols as HTML entities',
  `font_arial` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `font_code2000` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unicode_decimal` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unicode_hex` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `in_left` tinyint(1) DEFAULT '0',
  `decimal_places` int(10) UNSIGNED DEFAULT '2' COMMENT 'Currency Decimal Places - ISO 4217',
  `decimal_separator` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '.',
  `thousand_separator` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT ',',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>faq_entries`;
CREATE TABLE `<<prefix>>faq_entries` (
  `faq_id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `translation_lang` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `translation_of` int(10) UNSIGNED DEFAULT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `faq_pid` smallint(4) NOT NULL DEFAULT '0',
  `faq_weight` mediumint(6) NOT NULL DEFAULT '0',
  `faq_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `faq_content` mediumtext COLLATE utf8mb4_unicode_ci,
  `active` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>languages`;
CREATE TABLE `<<prefix>>languages` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `code` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direction` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_name` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `default` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>logs`;
CREATE TABLE `<<prefix>>logs` (
  `log_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `log_date` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `log_summary` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `log_details` longtext COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>menu`;
CREATE TABLE `<<prefix>>menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `cat_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `restro_id` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `price` float DEFAULT '0',
  `image` varchar(255) DEFAULT 'default.png',
  `type` ENUM('veg','nonveg') NOT NULL DEFAULT 'veg',
  `active` enum('0','1') NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>menu_extras`;
CREATE TABLE `<<prefix>>menu_extras` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `menu_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT '0.00',
  `position` int(11) NOT NULL DEFAULT '9999',
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>options`;
CREATE TABLE `<<prefix>>options` (
  `option_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `option_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `option_value` longtext COLLATE utf8mb4_unicode_ci,
  UNIQUE KEY `option_name` (`option_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>orders`;
CREATE TABLE `<<prefix>>orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `restaurant_id` int(11) DEFAULT NULL,
  `customer_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `table_number` int(11) DEFAULT NULL,
  `status` enum('pending','completed') NOT NULL DEFAULT 'pending',
  `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seen` TINYINT(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>order_items`;
CREATE TABLE `<<prefix>>order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `order_id` int(11) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `variation` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>order_item_extras`;
CREATE TABLE `<<prefix>>order_item_extras` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `order_item_id` int(11) DEFAULT NULL,
  `extra_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>pages`;
CREATE TABLE `<<prefix>>pages` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `translation_lang` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `translation_of` int(10) UNSIGNED DEFAULT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `type` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slug` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>payments`;
CREATE TABLE `<<prefix>>payments` (
  `payment_id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `payment_install` enum('0','1') NOT NULL DEFAULT '0',
  `payment_title` varchar(255) DEFAULT NULL,
  `payment_folder` varchar(30) DEFAULT NULL,
  `payment_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>plans`;
CREATE TABLE `<<prefix>>plans` (
 `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `name` varchar(255) NOT NULL DEFAULT '',
 `badge` TEXT NULL DEFAULT NULL,
 `monthly_price` float DEFAULT NULL,
 `annual_price` float DEFAULT NULL,
 `lifetime_price` float DEFAULT NULL,
 `recommended` ENUM('yes','no') NOT NULL DEFAULT 'no',
 `settings` text NOT NULL,
 `taxes_ids` text,
 `status` tinyint(4) NOT NULL,
 `date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>plan_options`;
CREATE TABLE `<<prefix>>plan_options` (
    `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `translation_lang` longtext COLLATE utf8mb4_unicode_ci,
    `translation_name` longtext COLLATE utf8mb4_unicode_ci,
    `position` int(10) DEFAULT NULL,
    `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>restaurant`;
CREATE TABLE `<<prefix>>restaurant` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `status` enum('active','pending','rejected') NOT NULL DEFAULT 'active',
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `sub_title` varchar(255) DEFAULT NULL,
  `timing` varchar(50) DEFAULT NULL,
  `description` text,
  `address` varchar(150) DEFAULT NULL,
  `latitude` varchar(50) DEFAULT NULL,
  `longitude` varchar(50) DEFAULT NULL,
  `main_image` varchar(255) DEFAULT 'default.png',
  `cover_image` varchar(255) DEFAULT 'default.png',
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>restaurant_view`;
CREATE TABLE `<<prefix>>restaurant_view` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `restaurant_id` int(11) DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>restaurant_options`;
CREATE TABLE `<<prefix>>restaurant_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `restaurant_id` int(11) DEFAULT NULL,
  `option_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `option_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>subscriptions`;
CREATE TABLE `<<prefix>>subscriptions` (
  `sub_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `sub_title` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_term` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MONTHLY',
  `sub_amount` double(8,2) NOT NULL DEFAULT '0.00',
  `sub_image` text COLLATE utf8mb4_unicode_ci,
  `group_id` smallint(10) DEFAULT NULL,
  `pay_mode` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `recommended` enum('yes','no') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'no',
  `discount_badge` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>taxes`;
CREATE TABLE `<<prefix>>taxes` (
 `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `internal_name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
 `name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
 `description` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
 `value` DECIMAL(10,2) DEFAULT NULL,
 `value_type` enum('percentage','fixed') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
 `type` enum('inclusive','exclusive') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
 `billing_type` enum('personal','business','both') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
 `countries` text COLLATE utf8mb4_unicode_ci,
 `datetime` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>testimonials`;
CREATE TABLE `<<prefix>>testimonials` (
  `id` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `designation` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>time_zones`;
CREATE TABLE `<<prefix>>time_zones` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `country_code` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time_zone_id` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `gmt` float DEFAULT NULL,
  `dst` float DEFAULT NULL,
  `raw` float DEFAULT NULL,
  UNIQUE KEY `time_zone_id` (`time_zone_id`),
  KEY `country_code` (`country_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>transaction`;
CREATE TABLE `<<prefix>>transaction` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `product_name` varchar(225) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `seller_id` int(11) DEFAULT NULL,
  `amount` double(9,2) DEFAULT NULL,
  `base_amount` DOUBLE(9,2) NULL DEFAULT NULL,
  `featured` enum('0','1') DEFAULT '0',
  `urgent` enum('0','1') DEFAULT '0',
  `highlight` enum('0','1') DEFAULT '0',
  `transaction_time` int(11) DEFAULT NULL,
  `status` enum('pending','success','failed','cancel') DEFAULT NULL,
  `payment_id` VARCHAR(64) NULL DEFAULT NULL,
  `transaction_gatway` varchar(255) DEFAULT NULL,
  `transaction_ip` varchar(15) DEFAULT NULL,
  `transaction_description` varchar(255) DEFAULT NULL,
  `transaction_method` varchar(20) DEFAULT NULL,
  `frequency` ENUM('MONTHLY','YEARLY','LIFETIME') NULL DEFAULT NULL,
  `billing` TEXT NULL DEFAULT NULL,
  `taxes_ids` TEXT NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>upgrades`;
CREATE TABLE `<<prefix>>upgrades` (
  `upgrade_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `sub_id` VARCHAR(16) NOT NULL DEFAULT '0',
  `user_id` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `pay_mode` ENUM('one_time','recurring') NOT NULL DEFAULT 'one_time',
  `upgrade_lasttime` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `upgrade_expires` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `unique_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `invoice_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paypal_subscription_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paypal_profile_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stripe_customer_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stripe_subscription_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `authorizenet_subscription_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `billing_day` int(2) DEFAULT NULL,
  `length` int(4) DEFAULT NULL,
  `interval` int(4) DEFAULT NULL,
  `trial_days` int(4) DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_trial_ends` date DEFAULT NULL,
  `date_canceled` datetime DEFAULT NULL,
  `date_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>user`;
CREATE TABLE `<<prefix>>user` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `group_id` VARCHAR(16) NOT NULL DEFAULT 'free',
  `username` varchar(255) DEFAULT NULL,
  `user_type` enum('user','employer') DEFAULT NULL,
  `balance` float(10,2) NOT NULL DEFAULT '0.00',
  `password_hash` varchar(255) DEFAULT NULL,
  `forgot` varchar(255) DEFAULT NULL,
  `confirm` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `status` enum('0','1','2') DEFAULT NULL,
  `view` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(225) DEFAULT NULL,
  `tagline` varchar(255) DEFAULT NULL,
  `description` text,
  `dob` date DEFAULT NULL,
  `salary_min` bigint(20) NOT NULL DEFAULT '0',
  `salary_max` bigint(20) NOT NULL DEFAULT '0',
  `category` int(11) DEFAULT NULL,
  `subcategory` int(11) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `sex` enum('Male','Female','Other') DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `postcode` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `city` varchar(225) DEFAULT NULL,
  `city_code` char(50) DEFAULT NULL,
  `state_code` char(50) DEFAULT NULL,
  `country_code` char(50) DEFAULT NULL,
  `image` varchar(225) NOT NULL DEFAULT 'default_user.png',
  `lastactive` datetime DEFAULT NULL,
  `facebook` varchar(255) DEFAULT NULL,
  `twitter` varchar(255) DEFAULT NULL,
  `googleplus` varchar(255) DEFAULT NULL,
  `instagram` varchar(255) DEFAULT NULL,
  `linkedin` varchar(255) DEFAULT NULL,
  `youtube` varchar(255) DEFAULT NULL,
  `oauth_provider` enum('','facebook','google','twitter') DEFAULT NULL,
  `oauth_uid` varchar(100) DEFAULT NULL,
  `oauth_link` varchar(255) DEFAULT NULL,
  `online` enum('0','1') NOT NULL DEFAULT '0',
  `notify` enum('0','1') DEFAULT '0',
  `notify_cat` varchar(255) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `menu_layout` ENUM('both','grid','list') NOT NULL DEFAULT 'both'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>user_options`;
CREATE TABLE `<<prefix>>user_options` (
    `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` int(11) DEFAULT NULL,
    `option_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `option_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `<<prefix>>usergroups`;
CREATE TABLE `<<prefix>>usergroups` (
  `group_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `group_removable` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `group_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_limit` int(11) NOT NULL DEFAULT '0',
  `menu_limit` int(11) NOT NULL DEFAULT '0',
  `scan_limit` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS=1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;