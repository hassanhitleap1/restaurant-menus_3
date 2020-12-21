<?php
/*
Copyright (c) 2020 Devendra Katariya (bylancer.com)
*/
require_once('includes.php');

// initilize all variable
$params = $columns = $order = $totalRecords = $data = array();
$params = $_REQUEST;
if ($params['order'][0]['column'] == 0) {
    $params['order'][0]['dir'] = "desc";
}
//define index of column
$columns = array(
    0 => 'b.created_at',
    1 => 'b.title',
    2 => 'b.description',
    3 => 'u.name',
    4 => '',
    5 => 'b.status',
    6 => 'b.updated_at',
);

$where = $sqlTot = $sqlRec = "";

// check search value exist
if (!empty($params['search']['value'])) {
    if (isset($_GET['status'])) {
        $where .= " WHERE ";
        $where .= " u.name LIKE '%" . $params['search']['value'] . "%' ";
        $where .= " OR b.title LIKE '" . $params['search']['value'] . "%' ";
    } elseif (isset($_GET['hide'])) {
        $where .= " WHERE ";
        $where .= " u.name LIKE '%" . $params['search']['value'] . "%' ";
        $where .= " OR b.title LIKE '" . $params['search']['value'] . "%' ";
    } else {
        $where .= " WHERE ";
        $where .= " u.name LIKE '%" . $params['search']['value'] . "%' ";
        $where .= " OR b.title LIKE '" . $params['search']['value'] . "%' ";
    }
}


// getting total number records without any search
$sql = "SELECT b.*, u.name, GROUP_CONCAT(c.title) categories FROM `" . $config['db']['pre'] . "blog` b
LEFT JOIN `" . $config['db']['pre'] . "admins` u ON u.id = b.author
LEFT JOIN `" . $config['db']['pre'] . "blog_cat_relation` bc ON bc.blog_id = b.id
LEFT JOIN `" . $config['db']['pre'] . "blog_categories` c ON bc.category_id = c.id GROUP BY b.id";
$sqlTot .= $sql;
$sqlRec .= $sql;
//concatenate search sql if value exist
if (isset($where) && $where != '') {
    $sqlTot .= $where;
    $sqlRec .= $where;
} else {
    if (isset($_GET['status'])) {
        $where .= " Where ( b.status = '" . $_GET['status'] . "' )";
        $sqlTot .= $where;
        $sqlRec .= $where;
    }
}

$sqlRec .= " ORDER BY " . $columns[$params['order'][0]['column']] . " " . $params['order'][0]['dir'] . " LIMIT " . $params['start'] . " ," . $params['length'] . " ";
//echo $sqlRec;

$queryTot = $pdo->query($sqlTot);
$totalRecords = $queryTot->rowCount();
$queryRecords = $pdo->query($sqlRec);

//iterate on results row and create new index array of data
foreach ($queryRecords as $row) {
    $id = $row['id'];
    $title = htmlspecialchars($row['title']);
    $desc = strlimiter(strip_tags(stripslashes(($row['description']))), 100);
    $status = '';
    if ($row['status'] == "publish") {
        $status = '<span class="label label-success">Publish</span>';
    } elseif ($row['status'] == "pending") {
        $status = '<span class="label label-warning">Pending</span>';
    }
    $categories = !empty($row['categories']) ? implode(', ',explode(',',$row['categories'])) : '&#8211;';

    $row0 = '<td>
                <label class="css-input css-checkbox css-checkbox-default">
                    <input type="checkbox" class="service-checker" value="' . $id . '" id="row_' . $id . '" name="row_' . $id . '"><span></span>
                </label>
            </td>';
    $row1 = '<td class="text-center">
                <p class="font-500 m-b-0"><a href="blog-new.php?id=' . $id . '">' . $title . '</a></p>
            </td>';
    $row2 = '<td class="hidden-xs">' . $desc . '</td>';
    $row3 = '<td class="hidden-xs">' . $row['name'] . '</td>';
    $row4 = '<td class="hidden-xs">' . $categories . '</td>';
    $row5 = '<td class="hidden-xs"><strong>' . $status . '</strong></td>';
    $row6 = '<td class="hidden-xs hidden-sm">' . timeAgo($row['updated_at']) . '</td>';
    $row7 = '<td class="text-center">
                <div class="btn-group">
                    <a href="blog-new.php?id=' . $id . '" title="Edit" class="btn btn-xs btn-default"> <i class="ion-edit"></i> </a>
                    <a href="#" title="Delete" class="btn btn-xs btn-default item-js-delete" data-ajax-action="deleteBlog"><i class="ion-close"></i></a>
                </div>
            </td>';
    $value = array(
        "DT_RowId" => $id,
        0 => $row0,
        1 => $row1,
        2 => $row2,
        3 => $row3,
        4 => $row4,
        5 => $row5,
        6 => $row6,
        7 => $row7,
    );
    $data[] = $value;

    //print_r($value);

}

$json_data = array(
    "draw" => intval($params['draw']),
    "recordsTotal" => intval($totalRecords),
    "recordsFiltered" => intval($totalRecords),
    "data" => $data   // total data array
);

echo json_encode($json_data);  // send data as json format
?>
