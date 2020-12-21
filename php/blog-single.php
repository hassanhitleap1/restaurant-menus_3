<?php
// if blog is disable
if(!$config['blog_enable']){
    error($lang['PAGE_NOT_FOUND'], __LINE__, __FILE__, 1);
}

$is_login = false;
if (checkloggedin()) {
    update_lastactive();
    $is_login = true;
}

global $match;
if (!isset($match['params']['id'])) {
    error($lang['PAGE_NOT_FOUND'], __LINE__, __FILE__, 1);
    exit;
}

function get_comment_reply($blog, $parent, $comments, $level = 2)
{
    global $config;
    $reply_result = ORM::for_table($config['db']['pre'] . 'blog_comment')
        ->where('active', '1')
        ->where('blog_id', $blog)
        ->where('parent', $parent)
        ->order_by_asc('created_at')
        ->find_many();

    foreach ($reply_result as $reply) {
        $comments[$reply['id']]['is_child'] = 1;
        $comments[$reply['id']]['id'] = $reply['id'];
        $comments[$reply['id']]['name'] = $reply['name'];
        $comments[$reply['id']]['parent'] = $reply['parent'];
        $comments[$reply['id']]['level'] = $level;
        $comments[$reply['id']]['comment'] = nl2br(stripcslashes($reply['comment']));
        $comments[$reply['id']]['created_at'] = date('d, M Y', strtotime($reply['created_at']));
        if ($reply['is_admin']) {
            $info = ORM::for_table($config['db']['pre'] . 'admins')->find_one($reply['user_id']);
            $comments[$reply['id']]['avatar'] = !empty($info['image']) ? $info['image'] : 'default_user.png';
        } else {
            $user_data = get_user_data(null, $reply['user_id']);
            $comments[$reply['id']]['avatar'] = !empty($user_data['image']) ? $user_data['image'] : 'default_user.png';
        }
        $comments = get_comment_reply($blog, $reply['id'], $comments, $level++);
    }
    return $comments;
}

$_GET['id'] = $match['params']['id'];

$comment_error = $comment_success = $name = $email = $user_id = $comment = null;
// submit comment
if (isset($_POST['comment-submit'])) {
    $is_admin = '0';
    if (!($is_login || isset($_SESSION['admin']['id']))) {
        if (empty($_POST['user_name']) || empty($_POST['user_email'])) {
            $comment_error = $lang['ALL_FIELDS_REQ'];
        } else {
            $name = removeEmailAndPhoneFromString($_POST['user_name']);
            $email = $_POST['user_email'];

            $regex = '/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$/';
            if (!preg_match($regex, $email)) {
                $comment_error = $lang['EMAILINV'];
            }
        }
    } else if ($is_login && isset($_SESSION['admin']['id'])) {
        $commenting_as = 'admin';
        if (!empty($_POST['commenting-as'])) {
            if (in_array($_POST['commenting-as'], array('admin', 'user'))) {
                $commenting_as = $_POST['commenting-as'];
            }
        }
        if ($commenting_as == 'admin') {
            $is_admin = '1';
            $info = ORM::for_table($config['db']['pre'] . 'admins')->find_one($_SESSION['admin']['id']);
            $user_id = $_SESSION['admin']['id'];
            $name = $info['name'];
            $email = $info['email'];
        } else {
            $user_id = $_SESSION['user']['id'];
            $user_data = get_user_data(null, $user_id);
            $name = $user_data['name'];
            $email = $user_data['email'];
        }
    } else if ($is_login) {
        $user_id = $_SESSION['user']['id'];
        $user_data = get_user_data(null, $user_id);
        $name = $user_data['name'];
        $email = $user_data['email'];
    } else if (isset($_SESSION['admin']['id'])) {
        $is_admin = '1';
        $info = ORM::for_table($config['db']['pre'] . 'admins')->find_one($_SESSION['admin']['id']);
        $user_id = $_SESSION['admin']['id'];
        $name = $info['name'];
        $email = $info['email'];
    }

    if (empty($_POST['comment'])) {
        $comment_error = $lang['ALL_FIELDS_REQ'];
    } else {
        $comment = validate_input($_POST['comment']);
    }

    $duplicates = ORM::for_table($config['db']['pre'] . 'blog_comment')
        ->where('blog_id', $_GET['id'])
        ->where('name', $name)
        ->where('email', $email)
        ->where('comment', $comment)
        ->count();

    if ($duplicates > 0) {
        $comment_error = $lang['DUPLICATE_COMMENT'];
    }

    if (!$comment_error) {
        if($is_admin){
            $approve = '1';
        }else{
            $comment_success = $lang['COMMENT_REVIEW'];
            if($config['blog_comment_approval'] == 1){
                $approve = '0';
            }else if($config['blog_comment_approval'] == 2){
                if($is_login){
                    $approve = '1';
                    $comment_success = null;
                }else{
                    $approve = '0';
                }
            }else{
                $approve = '1';
                $comment_success = null;
            }
        }

        $blog_cmnt = ORM::for_table($config['db']['pre'] . 'blog_comment')->create();
        $blog_cmnt->blog_id = $_GET['id'];
        $blog_cmnt->user_id = $user_id;
        $blog_cmnt->is_admin = $is_admin;
        $blog_cmnt->name = $name;
        $blog_cmnt->email = $email;
        $blog_cmnt->comment = $comment;
        $blog_cmnt->created_at = date('Y-m-d H:i:s');
        $blog_cmnt->active = $approve;
        $blog_cmnt->parent = $_POST['comment_parent'];
        $blog_cmnt->save();

        $name = $email = $comment = null;
    }
}

$query = ORM::for_table($config['db']['pre'] . 'blog')
    ->where('id', $_GET['id']);
if (!isset($_SESSION['admin']['id'])) {
    $query->where('status', 'publish');
}
$num_row = $query->count();

if ($num_row > 0) {
    $sql = "SELECT b.*, u.name, u.username, u.image author_pic, GROUP_CONCAT(c.title) categories, GROUP_CONCAT(c.slug) cat_slugs
    FROM `" . $config['db']['pre'] . "blog` b
    LEFT JOIN `" . $config['db']['pre'] . "admins` u ON u.id = b.author
    LEFT JOIN `" . $config['db']['pre'] . "blog_cat_relation` bc ON bc.blog_id = b.id
    LEFT JOIN `" . $config['db']['pre'] . "blog_categories` c ON bc.category_id = c.id
    WHERE b.id = " . $_GET['id'] . " GROUP BY b.id";

    if (!isset($_SESSION['admin']['id'])) {
        $sql .= " AND b.status = 'publish'";
    }
    $info = ORM::for_table($config['db']['pre'] . 'blog')->raw_query($sql)->find_one();

    $id = $info['id'];
    $title = $info['title'];
    $image = $info['image'];
    $description = stripslashes($info['description']);
    $author = $info['name'];
    $author_link = $link['BLOG-AUTHOR'] . '/' . $info['username'];
    $author_pic = !empty($info['author_pic']) ? $info['author_pic'] : 'default_user.png';
    $created_at = date('d, M Y', strtotime($info['created_at']));
    $blog_link = $link['BLOG-SINGLE'] . '/' . $info['id'] . '/' . create_slug($info['title']);

    $blog_tags = array();
    $show_tag = 0;
    if (!empty($info['tags'])) {
        $tag = explode(',', $info['tags']);
        $tag2 = array();
        foreach ($tag as $val) {
            //REMOVE SPACE FROM $VALUE ----
            $tagTrim = preg_replace("/[\s_]/", "-", trim($val));
            $tag2[] = '<a href="' . $link['BLOG'] . '?s=' . $tagTrim . '"><span>' . $val . '</span></a>';
        }
        $blog_tags = implode('  ', $tag2);
        $show_tag = 1;
    }

    $categories = explode(',', $info['categories']);
    $cat_slugs = explode(',', $info['cat_slugs']);
    $arr = array();
    for ($i = 0; $i < count($categories); $i++) {
        $arr[] = '<a href="' . $link['BLOG-CAT'] . '/' . $cat_slugs[$i] . '">' . $categories[$i] . '</a>';
    }


    // get comments
    if (!isset($_GET['page']))
        $page = 1;
    else
        $page = $_GET['page'];

    $limit = 20;

    $total_cmnt = ORM::for_table($config['db']['pre'] . 'blog_comment')
        ->where('active', '1')
        ->where('blog_id', $id)
        ->where('parent', 0)
        ->count();

    $cmnt_result = ORM::for_table($config['db']['pre'] . 'blog_comment')
        ->where('active', '1')
        ->where('blog_id', $id)
        ->where('parent', 0)
        ->order_by_desc('created_at')
        ->limit($limit)
        ->offset(($page - 1) * $limit)
        ->find_many();

    $comments = array();
    foreach ($cmnt_result as $row) {
        $comments[$row['id']]['is_child'] = 0;
        $comments[$row['id']]['id'] = $row['id'];
        $comments[$row['id']]['name'] = $row['name'];
        $comments[$row['id']]['parent'] = $row['parent'];
        $comments[$row['id']]['level'] = 1;
        $comments[$row['id']]['comment'] = nl2br(stripcslashes($row['comment']));
        $comments[$row['id']]['created_at'] = date('d, M Y', strtotime($row['created_at']));
        if ($row['is_admin']) {
            $info = ORM::for_table($config['db']['pre'] . 'admins')->find_one($row['user_id']);
            $comments[$row['id']]['avatar'] = !empty($info['image']) ? $info['image'] : 'default_user.png';
        } else {
            $user_data = get_user_data(null, $row['user_id']);
            $comments[$row['id']]['avatar'] = !empty($user_data['image']) ? $user_data['image'] : 'default_user.png';
        }

        // get comment reply
        $comments = get_comment_reply($id, $row['id'], $comments);
    }
    $pagging = pagenav($total_cmnt, $page, $limit, $blog_link);

    // get categories
    $sql = "SELECT
c.*, COUNT(bc.blog_id) blog
FROM `".$config['db']['pre']."blog_categories` c
LEFT JOIN `" . $config['db']['pre'] . "blog_cat_relation` bc ON bc.category_id = c.id
LEFT JOIN `" . $config['db']['pre'] . "blog` b ON bc.blog_id = b.id
WHERE c.active = '1' AND b.status = 'publish' GROUP BY c.id ORDER BY c.position";
    $result = ORM::for_table($config['db']['pre'].'blog_categories')->raw_query($sql)->find_many();
    $blog_cat = array();
    foreach($result as $row){
        $blog_cat[$row['id']]['id'] = $row['id'];
        $blog_cat[$row['id']]['title'] = $row['title'];
        $blog_cat[$row['id']]['blog'] = $row['blog'];
        $blog_cat[$row['id']]['link'] = $link['BLOG-CAT'].'/'.$row['slug'];
    }

    // get recent blog
    $rows = ORM::for_table($config['db']['pre'] . 'blog')
        ->where('status', 'publish')
        ->order_by_desc('created_at')
        ->limit(3)
        ->find_many();
    $recent_blog = array();
    foreach ($rows as $row) {
        $recent_blog[$row['id']]['id'] = $row['id'];
        $recent_blog[$row['id']]['title'] = $row['title'];
        $recent_blog[$row['id']]['created_at'] = timeAgo($row['created_at']);
        $recent_blog[$row['id']]['image'] = !empty($row['image']) ? $row['image'] : 'default.png';
        $recent_blog[$row['id']]['link'] = $link['BLOG-SINGLE'] . '/' . $row['id'] . '/' . create_slug($row['title']);
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

    // get all tags
    $rows = ORM::for_table($config['db']['pre'] . 'blog')
        ->select('tags')
        ->where('status', 'publish')
        ->find_many();
    $all_tags = array();
    $tag2 = array();
    foreach ($rows as $row) {
        if (!empty($row['tags'])) {
            $tag = explode(',', $row['tags']);
            foreach ($tag as $val) {
                //REMOVE SPACE FROM $VALUE ----
                $tagTrim = preg_replace("/[\s_]/", "-", trim($val));
                $tag2[] = '<a href="' . $link['BLOG'] . '?s=' . $tagTrim . '">' . $val . '</a>';
            }
        }
    }
    $all_tags = implode('  ', array_unique($tag2));

    $show_comment_form = 1;
    if(!$config['blog_comment_user']){
        if($is_login || isset($_SESSION['admin']['id'])){
            $show_comment_form = 1;
        }else{
            $show_comment_form = 0;
        }
    }


    $page = new HtmlTemplate ('templates/' . $config['tpl_name'] . '/blog-single.tpl');
    $page->SetParameter('OVERALL_HEADER', create_header($title));
    $page->SetParameter('BLOG_ID', $id);
    $page->SetParameter('TITLE', $title);
    $page->SetParameter('IMAGE', $image);
    $page->SetParameter('DESCRIPTION', $description);
    $page->SetParameter('AUTHOR', $author);
    $page->SetParameter('AUTHOR_LINK', $author_link);
    $page->SetParameter('AUTHOR_PIC', $author_pic);
    $page->SetParameter('CREATED_AT', $created_at);
    $page->SetParameter('BLOG_LINK', $blog_link);
    $page->SetParameter('CATEGORIES', implode(', ', $arr));
    $page->SetParameter('BLOG_TAGS', $blog_tags);
    $page->SetParameter('SHOW_TAG', $show_tag);
    $page->SetParameter('ALL_TAGS', $all_tags);
    $page->SetParameter('COMMENT_ERROR', $comment_error);
    $page->SetParameter('COMMENT_SUCCESS', $comment_success);
    $page->SetParameter('USER_NAME', $name);
    $page->SetParameter('USER_EMAIL', $email);
    $page->SetParameter('COMMENT', $comment);
    $page->SetParameter('ADMIN_LOGGED_IN', (int)isset($_SESSION['admin']['id']));
    $page->SetParameter('ADMIN_USERNAME', isset($_SESSION['admin']['username']) ? $_SESSION['admin']['username'] : '');
    $page->SetParameter('COMMENTS_COUNT', $total_cmnt);
    $page->SetParameter('SHOW_PAGING', (int)($total_cmnt > $limit));
    $page->SetParameter('SHOW_COMMENT_FORM', $show_comment_form);
    $page->SetLoop('COMMENT_PAGING', $pagging);
    $page->SetLoop('COMMENTS', $comments);
    $page->SetLoop('BLOG_CAT', $blog_cat);
    $page->SetLoop('RECENT_BLOG', $recent_blog);
    $page->SetLoop('TESTIMONIALS', $testimonials);
    $page->SetParameter('OVERALL_FOOTER', create_footer());
    $page->CreatePageEcho();
} else {
    error($lang['PAGE_NOT_FOUND'], __LINE__, __FILE__, 1);
    exit;
}