<?php
// if testimonial is disable
if(!$config['testimonials_enable']){
    error($lang['PAGE_NOT_FOUND'], __LINE__, __FILE__, 1);
}

if(checkloggedin()) {
    update_lastactive();
}

if(!isset($_GET['page']))
    $page = 1;
else
    $page = $_GET['page'];

$limit = 9;

$sql = "SELECT * FROM `".$config['db']['pre']."testimonials`";

$total = mysqli_num_rows(mysqli_query($mysqli, "SELECT 1 FROM ".$config['db']['pre']."testimonials"));
$query = "$sql LIMIT ".($page-1)*$limit.",$limit";

$result = ORM::for_table($config['db']['pre'].'testimonials')->raw_query($query)->find_many();

$testimonials = array();
if ($result) {
    foreach ($result as $row)
    {
        $testimonials[$row['id']]['id'] = $row['id'];
        $testimonials[$row['id']]['name'] = $row['name'];
        $testimonials[$row['id']]['designation'] = $row['designation'];
        $testimonials[$row['id']]['content'] = $row['content'];
        $testimonials[$row['id']]['image'] = !empty($row['image']) ? $row['image'] : 'default_user.png';
    }
}

$pagging = pagenav($total,$page,$limit,$link['TESTIMONIALS']);

$page = new HtmlTemplate ('templates/' . $config['tpl_name'] . '/testimonials.tpl');
$page->SetParameter ('OVERALL_HEADER', create_header($lang['TESTIMONIALS']));
$page->SetLoop ('TESTIMONIALS',$testimonials);
$page->SetLoop ('PAGES', $pagging);
$page->SetParameter('SHOW_PAGING', (int)($total > $limit));
$page->SetParameter ('OVERALL_FOOTER', create_footer());
$page->CreatePageEcho();
?>
