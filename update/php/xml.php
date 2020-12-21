<?php
header('Content-type: text/xml');

function text_replace_for_xml($text){
    $text = str_replace("&","&amp;",stripslashes($text));
    $text = str_replace('<','&lt;',$text);
    $text = str_replace('>','&gt;',$text);
    return $text;
}

if($config['xml_latest'] == 1){
    echo '<?xml version="1.0" encoding="UTF-8"?>';
    echo '<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:image="http://www.google.com/schemas/sitemap-image/1.1" xmlns:video="http://www.google.com/schemas/sitemap-video/1.1" xmlns:news="http://www.google.com/schemas/sitemap-news/0.9" xmlns:mobile="http://www.google.com/schemas/sitemap-mobile/1.0" xmlns:pagemap="http://www.google.com/schemas/sitemap-pagemap/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">';

    $rows = ORM::for_table($config['db']['pre'].'restaurant')
        ->order_by_desc('id')
        ->find_many();

    foreach ($rows as $info)
    {
        $slug = create_slug($info['name']);
        $url = $link['RESTAURANT'] .'/'.$info['id'].'/'.$slug;

        echo '<url>';
        echo '<loc>' . $url . '</loc>';
        echo '<changefreq>daily</changefreq>';
        echo '<priority>1</priority>';
        echo '</url>';
    }

    echo '</urlset>';
}