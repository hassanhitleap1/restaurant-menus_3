<?php
ignore_user_abort(1);

// version 1.1
if($config['version'] < 1.1){
    // add mollie payment gateway
    $sql = "INSERT INTO `".$config['db']['pre']."payments` (`payment_id`, `payment_install`, `payment_title`, `payment_folder`, `payment_desc`) VALUES (NULL, '0', 'Mollie', 'mollie', 'You will be redirected to Mollie to complete payment.');";
    mysqli_query($mysqli,$sql);

    // add currency in user table
    $sql = "ALTER TABLE `".$config['db']['pre']."user` ADD `currency` VARCHAR(10) NULL DEFAULT NULL AFTER `notify_cat`;";
    mysqli_query($mysqli,$sql);

    // add menu type in user table
    $sql = "ALTER TABLE `".$config['db']['pre']."user` ADD `menu_layout` ENUM('both','grid','list') NOT NULL DEFAULT 'both' AFTER `currency`;";
    mysqli_query($mysqli,$sql);
}

// version 2.0
if($config['version'] < 2.0){
    update_option("restaurant_text_editor", 1);

    // create database tables
    $sql = "CREATE TABLE `".$config['db']['pre']."menu_extras` (
              `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
              `menu_id` int(11) DEFAULT NULL,
              `title` varchar(255) DEFAULT NULL,
              `price` decimal(10,2) DEFAULT '0.00',
              `position` int(11) NOT NULL DEFAULT '9999',
              `active` tinyint(1) NOT NULL DEFAULT '1'
            ) ENGINE=InnoDB DEFAULT CHARSET=latin1;";
    mysqli_query($mysqli,$sql);

    // insert mollie if not inserted already
    $sql = "SELECT COUNT(*) total FROM `".$config['db']['pre']."payments` WHERE `payment_title` = 'Mollie'";
    $result = mysqli_query($mysqli,$sql);
    $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
    if($row['total'] == 0) {
        $sql = "INSERT INTO `".$config['db']['pre']."payments` (`payment_id`, `payment_install`, `payment_title`, `payment_folder`, `payment_desc`) VALUES (NULL, '0', 'Mollie', 'mollie', 'You will be redirected to Mollie to complete payment.');";
        mysqli_query($mysqli,$sql);
    }

    // add currency if not inserted already
    $sql = "SHOW COLUMNS FROM `".$config['db']['pre']."user` LIKE 'currency'";
    $result = mysqli_query($mysqli,$sql);
    $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
    if(!isset($row['Field'])){
        $sql = "ALTER TABLE `".$config['db']['pre']."user` ADD `currency` VARCHAR(10) NULL DEFAULT NULL AFTER `notify_cat`;";
        mysqli_query($mysqli,$sql);
    }

    // add menu_layout if not inserted already
    $sql = "SHOW COLUMNS FROM `".$config['db']['pre']."user` LIKE 'menu_layout'";
    $result = mysqli_query($mysqli,$sql);
    $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
    if(!isset($row['Field'])){
        $sql = "ALTER TABLE `".$config['db']['pre']."user` ADD `menu_layout` ENUM('both','grid','list') NOT NULL DEFAULT 'both' AFTER `currency`;";
        mysqli_query($mysqli,$sql);
    }
}

// version 3.0
if($config['version'] < 3.0){
    // add options
    update_option("email_sub_new_order",'{RESTAURANT_NAME} - {LANG_NEW_ORDER}');
    update_option("email_message_new_order",'{RESTAURANT_NAME}\\n\\n{LANG_NEW_ORDER}\\n\\n{LANG_CUSTOMER}: {CUSTOMER_NAME}\\n{LANG_TABLE_NUMBER}: {TABLE_NUMBER}\\n{LANG_MESSAGE}: {MESSAGE}\\n\\n{LANG_ORDERS}\\n{ORDER}');

    // create database tables
    $sql = "CREATE TABLE `".$config['db']['pre']."orders` (
              `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
              `restaurant_id` int(11) DEFAULT NULL,
              `customer_name` varchar(255) DEFAULT NULL,
              `table_number` int(11) DEFAULT NULL,
              `status` enum('pending','completed') NOT NULL DEFAULT 'pending',
              `message` varchar(255) DEFAULT NULL,
              `created_at` datetime DEFAULT NULL
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";
    mysqli_query($mysqli,$sql);

    $sql = "CREATE TABLE `".$config['db']['pre']."order_items` (
              `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
              `order_id` int(11) DEFAULT NULL,
              `item_id` int(11) DEFAULT NULL,
              `variation` int(11) DEFAULT NULL,
              `quantity` int(11) NOT NULL DEFAULT '1'
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";
    mysqli_query($mysqli,$sql);

    $sql = "CREATE TABLE `".$config['db']['pre']."order_item_extras` (
              `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
              `order_item_id` int(11) DEFAULT NULL,
              `extra_id` int(11) DEFAULT NULL,
              `quantity` int(11) NOT NULL DEFAULT '1'
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
    mysqli_query($mysqli,$sql);
}

// version 4.0
if($config['version'] < 4.0){
    $sql = "CREATE TABLE `".$config['db']['pre']."restaurant_options` (
              `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
              `restaurant_id` int(11) DEFAULT NULL,
              `option_name` varchar(191) DEFAULT NULL,
              `option_value` longtext
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";
    mysqli_query($mysqli,$sql);

    $sql = "ALTER TABLE `".$config['db']['pre']."menu` ADD `type` ENUM('veg','nonveg') NOT NULL DEFAULT 'veg' AFTER `image`;";
    mysqli_query($mysqli,$sql);
}

// version 4.1
if($config['version'] < 4.1){
    update_option("quickad_user_secret_file",'');
}

// version 4.2
if($config['version'] < 4.2){
    $sql = "ALTER TABLE `".$config['db']['pre']."orders` ADD `seen` TINYINT(1) NOT NULL DEFAULT '0' AFTER `message`;";
    mysqli_query($mysqli,$sql);

    $sql = "UPDATE `".$config['db']['pre']."menu` SET `active` = '1';";
    mysqli_query($mysqli,$sql);
}

// version 5.0
if($config['version'] < 5.0){

    $sql = "CREATE TABLE `".$config['db']['pre']."plans` (
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
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;";
    mysqli_query($mysqli,$sql);

    $sql = "CREATE TABLE `".$config['db']['pre']."taxes` (
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
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;";
    mysqli_query($mysqli,$sql);

    $sql = "CREATE TABLE `".$config['db']['pre']."plan_options` (
              `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
              `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
              `translation_lang` longtext COLLATE utf8mb4_unicode_ci,
              `translation_name` longtext COLLATE utf8mb4_unicode_ci,
              `position` int(10) DEFAULT NULL,
              `active` tinyint(1) NOT NULL DEFAULT '1'
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;";
    mysqli_query($mysqli,$sql);

    $sql = "CREATE TABLE `".$config['db']['pre']."user_options` (
              `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
              `user_id` int(11) DEFAULT NULL,
              `option_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
              `option_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;";
    mysqli_query($mysqli,$sql);

    $sql = "ALTER TABLE `".$config['db']['pre']."restaurant` CHANGE `name` `name` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL;";
    mysqli_query($mysqli,$sql);

    $sql = "ALTER TABLE `".$config['db']['pre']."user` CHANGE `group_id` `group_id` VARCHAR(16) NOT NULL DEFAULT 'free';";
    mysqli_query($mysqli,$sql);

    $sql = "ALTER TABLE `".$config['db']['pre']."upgrades` CHANGE `sub_id` `sub_id` VARCHAR(16) NOT NULL DEFAULT '0';";
    mysqli_query($mysqli,$sql);

    $sql = "ALTER TABLE `".$config['db']['pre']."upgrades` ADD `pay_mode` ENUM('one_time','recurring') NOT NULL DEFAULT 'one_time' AFTER `user_id`;";
    mysqli_query($mysqli,$sql);

    $sql = "ALTER TABLE `".$config['db']['pre']."transaction` ADD `payment_id` VARCHAR(64) NULL DEFAULT NULL AFTER `status`;";
    mysqli_query($mysqli,$sql);

    $sql = "ALTER TABLE `".$config['db']['pre']."transaction` ADD `frequency` ENUM('MONTHLY','YEARLY','LIFETIME') NULL DEFAULT NULL AFTER `transaction_method`;";
    mysqli_query($mysqli,$sql);

    $sql = "ALTER TABLE `".$config['db']['pre']."transaction` ADD `billing` TEXT NULL DEFAULT NULL AFTER `frequency`;";
    mysqli_query($mysqli,$sql);

    $sql = "ALTER TABLE `".$config['db']['pre']."transaction` ADD `taxes_ids` TEXT NULL DEFAULT NULL AFTER `billing`;";
    mysqli_query($mysqli,$sql);

    $sql = "ALTER TABLE `".$config['db']['pre']."transaction` ADD `base_amount` DOUBLE(9,2) NULL DEFAULT NULL AFTER `amount`;";
    mysqli_query($mysqli,$sql);

    $free_plan = json_encode(array(
        'id' => 'free',
        'name' => 'Free',
        'badge' => '',
        'settings' => array(
            'category_limit' => 5,
            'menu_limit' => 5,
            'scan_limit' => 50,
            'allow_ordering' => 0
        ),
        'status' => 0
    ));
    update_option('free_membership_plan', $free_plan);

    $trial_plan = json_encode(array(
        'id' => 'trial',
        'name' => 'Trial',
        'badge' => '',
        'days' => 7,
        'settings' => array(
            'category_limit' => 5,
            'menu_limit' => 5,
            'scan_limit' => 50,
            'allow_ordering' => 0
        ),
        'status' => 0
    ));
    update_option('trial_membership_plan', $trial_plan);

    update_option("paypal_payment_mode",'one_time');
    update_option("stripe_payment_mode",'one_time');

    /* Insert current membership plan */
    $sql = "SELECT * FROM `".$config['db']['pre']."subscriptions` s LEFT JOIN `".$config['db']['pre']."usergroups` g ON g.group_id = s.group_id";
    $query = mysqli_query($mysqli, $sql);
    while($info = mysqli_fetch_assoc($query)){
        $monthly_price = $annual_price = $lifetime_price = 0;

        if($info['sub_term'] == 'MONTHLY'){
            $monthly_price = $info['sub_amount'];
        } else if($info['sub_term'] == 'YEARLY'){
            $annual_price = $info['sub_amount'];
        }
        $settings = json_encode(array(
            'category_limit' => $info['category_limit'],
            'menu_limit' => $info['menu_limit'],
            'scan_limit' => $info['scan_limit'],
            'allow_ordering' => 1
        ));

        $insert = "INSERT INTO `".$config['db']['pre']."plans` 
        (`name`, `monthly_price`, `annual_price`, `lifetime_price`, `recommended`, `settings`, `status`, `date`) VALUES 
        ('{$info['sub_title']}', $monthly_price, $annual_price, $lifetime_price, '{$info['recommended']}', '$settings',{$info['active']}, '".date('Y-m-d H:i:s')."');";
        mysqli_query($mysqli,$insert);

        if($id = mysqli_insert_id($mysqli)) {
            $update = "UPDATE `" . $config['db']['pre'] . "user` set `group_id` = '$id' WHERE `group_id` = '" . $info['group_id'] . "'";
            mysqli_query($mysqli, $update);
        }
    }

    update_option("show_update_notice",'1');

    /* update collate of all tables */
    $sql = "ALTER TABLE `".$config['db']['pre']."admins` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."balance` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."blog` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."blog_cat_relation` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."blog_categories` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."blog_comment` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."catagory_main` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."countries` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."currencies` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."faq_entries` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."languages` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."logs` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."menu` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."menu_extras` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."options` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."order_item_extras` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."order_items` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."orders` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."pages` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."payments` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."plan_options` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."plans` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."restaurant` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."restaurant_options` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."restaurant_view` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."subscriptions` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."taxes` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."testimonials` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."time_zones` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."transaction` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."upgrades` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."user` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."user_options` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
            ALTER TABLE `".$config['db']['pre']."usergroups` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;";
    mysqli_query($mysqli,$sql);
}