<?php
$limit = 6;

// get recent blog
$sql = "SELECT
b.*, u.name, u.username, u.image author_pic, GROUP_CONCAT(c.title) categories, GROUP_CONCAT(c.slug) cat_slugs
FROM `".$config['db']['pre']."blog` b
LEFT JOIN `".$config['db']['pre']."admins` u ON u.id = b.author
LEFT JOIN `" . $config['db']['pre'] . "blog_cat_relation` bc ON bc.blog_id = b.id
LEFT JOIN `" . $config['db']['pre'] . "blog_categories` c ON bc.category_id = c.id
WHERE b.status = 'publish' GROUP BY b.id ORDER BY b.created_at DESC LIMIT 3";
$rows = ORM::for_table($config['db']['pre'].'blog')->raw_query($sql)->find_many();
$recent_blog = array();
foreach ($rows as $info) {
    $recent_blog[$info['id']]['id'] = $info['id'];
    $recent_blog[$info['id']]['title'] = $info['title'];
    $recent_blog[$info['id']]['image'] = !empty($info['image'])?$info['image']:'default.png';
    $recent_blog[$info['id']]['description'] = strlimiter(strip_tags(stripslashes($info['description'])),100);
    $recent_blog[$info['id']]['author'] = $info['name'];
    $recent_blog[$info['id']]['author_link'] = $link['BLOG-AUTHOR'].'/'.$info['username'];
    $recent_blog[$info['id']]['author_pic'] = !empty($info['author_pic'])?$info['author_pic']:'default_user.png';
    $recent_blog[$info['id']]['created_at'] = timeAgo($info['created_at']);
    $recent_blog[$info['id']]['link'] = $link['BLOG-SINGLE'].'/'.$info['id'].'/'.create_slug($info['title']);

    $categories = explode(',',$info['categories']);
    $cat_slugs = explode(',',$info['cat_slugs']);
    $arr = array();
    for($i = 0; $i < count($categories); $i++){
        $arr[] = '<a href="'.$link['BLOG-CAT'].'/'.$cat_slugs[$i].'">'.$categories[$i].'</a>';
    }
    $recent_blog[$info['id']]['categories'] = implode(', ',$arr);
}

// get testimonials
$rows = ORM::for_table($config['db']['pre'] . 'testimonials')
    ->order_by_desc('id')
    ->limit(5)
    ->find_many();
$testimonials = array();
foreach ($rows as $row) {
    $testimonials[$row['id']]['id'] = $row['id'];
    $testimonials[$row['id']]['name'] = $row['name'];
    $testimonials[$row['id']]['designation'] = $row['designation'];
    $testimonials[$row['id']]['content'] = $row['content'];
    $testimonials[$row['id']]['image'] = !empty($row['image']) ? $row['image'] : 'default_user.png';
}

// get membership
$sub_info = get_user_membership_detail(isset($_SESSION['user']['id'])?$_SESSION['user']['id']:null);
$sub_types = array();

// custom settings
$plan_custom = ORM::for_table($config['db']['pre'].'plan_options')
    ->where('active', 1)
    ->order_by_asc('position')
    ->find_many();

$plan = json_decode(get_option('free_membership_plan'), true);
if($plan['status']){
    if($plan['id'] == $sub_info['id']) {
        $sub_types[$plan['id']]['Selected'] = 1;
    } else {
        $sub_types[$plan['id']]['Selected'] = 0;
    }

    $sub_types[$plan['id']]['id'] = $plan['id'];
    $sub_types[$plan['id']]['title'] = $plan['name'];
    $sub_types[$plan['id']]['monthly_price'] = price_format(0,$config['currency_code']);
    $sub_types[$plan['id']]['annual_price'] = price_format(0,$config['currency_code']);
    $sub_types[$plan['id']]['lifetime_price'] = price_format(0,$config['currency_code']);

    $settings = $plan['settings'];
    $sub_types[$plan['id']]['category_limit'] = ($settings['category_limit'] == "999")? $lang['UNLIMITED']: $settings['category_limit'];
    $sub_types[$plan['id']]['menu_limit'] = ($settings['menu_limit'] == "999")? $lang['UNLIMITED']: $settings['menu_limit'];
    $sub_types[$plan['id']]['scan_limit'] = ($settings['scan_limit'] == "999")? $lang['UNLIMITED']: $settings['scan_limit'];
    $sub_types[$plan['id']]['allow_ordering'] = $settings['allow_ordering'];

    $sub_types[$plan['id']]['custom_settings'] = '';
    if(!empty($plan_custom)) {
        foreach ($plan_custom as $custom) {
            if(!empty($custom['title']) && trim($custom['title']) != '') {
                $tpl = '<li><span class="icon-text no"><i class="icon-feather-x-circle margin-right-2"></i></span> ' . $custom['title'] . '</li>';

                if (isset($settings['custom'][$custom['id']]) && $settings['custom'][$custom['id']] == '1') {
                    $tpl = '<li><span class="icon-text yes"><i class="icon-feather-check-circle margin-right-2"></i></span> ' . $custom['title'] . '</li>';
                }
                $sub_types[$plan['id']]['custom_settings'] .= $tpl;
            }
        }
    }
}

$plan = json_decode(get_option('trial_membership_plan'), true);
if($plan['status']){
    if($plan['id'] == $sub_info['id']) {
        $sub_types[$plan['id']]['Selected'] = 1;
    } else {
        $sub_types[$plan['id']]['Selected'] = 0;
    }

    $sub_types[$plan['id']]['id'] = $plan['id'];
    $sub_types[$plan['id']]['title'] = $plan['name'];
    $sub_types[$plan['id']]['monthly_price'] = price_format(0,$config['currency_code']);
    $sub_types[$plan['id']]['annual_price'] = price_format(0,$config['currency_code']);
    $sub_types[$plan['id']]['lifetime_price'] = price_format(0,$config['currency_code']);

    $settings = $plan['settings'];
    $sub_types[$plan['id']]['category_limit'] = ($settings['category_limit'] == "999")? $lang['UNLIMITED']: $settings['category_limit'];
    $sub_types[$plan['id']]['menu_limit'] = ($settings['menu_limit'] == "999")? $lang['UNLIMITED']: $settings['menu_limit'];
    $sub_types[$plan['id']]['scan_limit'] = ($settings['scan_limit'] == "999")? $lang['UNLIMITED']: $settings['scan_limit'];
    $sub_types[$plan['id']]['allow_ordering'] = $settings['allow_ordering'];

    $sub_types[$plan['id']]['custom_settings'] = '';
    if(!empty($plan_custom)) {
        foreach ($plan_custom as $custom) {
            if(!empty($custom['title']) && trim($custom['title']) != '') {
                $tpl = '<li><span class="icon-text no"><i class="icon-feather-x-circle margin-right-2"></i></span> ' . $custom['title'] . '</li>';

                if (isset($settings['custom'][$custom['id']]) && $settings['custom'][$custom['id']] == '1') {
                    $tpl = '<li><span class="icon-text yes"><i class="icon-feather-check-circle margin-right-2"></i></span> ' . $custom['title'] . '</li>';
                }
                $sub_types[$plan['id']]['custom_settings'] .= $tpl;
            }
        }
    }
}

$total_monthly = $total_annual = $total_lifetime = 0;

$rows = ORM::for_table($config['db']['pre'].'plans')
    ->where('status', '1')
    ->find_many();

foreach ($rows as $plan)
{
    if($plan['id'] == $sub_info['id']) {
        $sub_types[$plan['id']]['Selected'] = 1;
    } else {
        $sub_types[$plan['id']]['Selected'] = 0;
    }

    $sub_types[$plan['id']]['id'] = $plan['id'];
    $sub_types[$plan['id']]['title'] = $plan['name'];
    $sub_types[$plan['id']]['recommended'] = $plan['recommended'];

    $total_monthly += $plan['monthly_price'];
    $total_annual += $plan['annual_price'];
    $total_lifetime += $plan['lifetime_price'];

    $sub_types[$plan['id']]['monthly_price'] = price_format($plan['monthly_price'],$config['currency_code']);
    $sub_types[$plan['id']]['annual_price'] = price_format($plan['annual_price'],$config['currency_code']);
    $sub_types[$plan['id']]['lifetime_price'] = price_format($plan['lifetime_price'],$config['currency_code']);

    $settings = json_decode($plan['settings'], true);
    $sub_types[$plan['id']]['category_limit'] = ($settings['category_limit'] == "999")? $lang['UNLIMITED']: $settings['category_limit'];
    $sub_types[$plan['id']]['menu_limit'] = ($settings['menu_limit'] == "999")? $lang['UNLIMITED']: $settings['menu_limit'];
    $sub_types[$plan['id']]['scan_limit'] = ($settings['scan_limit'] == "999")? $lang['UNLIMITED']: $settings['scan_limit'];
    $sub_types[$plan['id']]['allow_ordering'] = $settings['allow_ordering'];

    $sub_types[$plan['id']]['custom_settings'] = '';
    if(!empty($plan_custom)) {
        foreach ($plan_custom as $custom) {
            if(!empty($custom['title']) && trim($custom['title']) != '') {
                $tpl = '<li><span class="icon-text no"><i class="icon-feather-x-circle margin-right-2"></i></span> ' . $custom['title'] . '</li>';

                if (isset($settings['custom'][$custom['id']]) && $settings['custom'][$custom['id']] == '1') {
                    $tpl = '<li><span class="icon-text yes"><i class="icon-feather-check-circle margin-right-2"></i></span> ' . $custom['title'] . '</li>';
                }
                $sub_types[$plan['id']]['custom_settings'] .= $tpl;
            }
        }
    }
}

$currency_data = get_currency_by_code(get_option('currency_code'));

$page = new HtmlTemplate ('templates/'.$config['tpl_name'].'/index.tpl');
$page->SetParameter ('OVERALL_HEADER', create_header());
$page->SetParameter('BANNER_IMAGE', $config['home_banner']);
$page->SetParameter('MAP_COLOR', $config['map_color']);
$page->SetParameter('CURRENCY_SIGN', $currency_data['html_entity']);
$page->SetParameter('CURRENCY_LEFT', $currency_data['in_left']);

// Get Cron Job Settings
$cron_time = isset($config['cron_time']) ? $config['cron_time'] : time();
$cron_exec_time = isset($config['cron_exec_time']) ? $config['cron_exec_time'] : "86400";
if((time()-$cron_exec_time) > $cron_time) {
    run_cron_job();
}
$page->SetParameter('TOTAL_MONTHLY', $total_monthly);
$page->SetParameter('TOTAL_ANNUAL', $total_annual);
$page->SetParameter('TOTAL_LIFETIME', $total_lifetime);
$page->SetLoop ('SUB_TYPES', $sub_types);
$page->SetLoop('RECENT_BLOG', $recent_blog);
$page->SetLoop('TESTIMONIALS', $testimonials);
$page->SetParameter ('OVERALL_FOOTER', create_footer());
$page->CreatePageEcho();