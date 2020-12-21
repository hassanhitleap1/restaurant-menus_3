{OVERALL_HEADER}
<link rel="stylesheet" href="{SITE_URL}templates/{TPL_NAME}/css/jquery.dataTables.min.css">
<link rel="stylesheet" href="{SITE_URL}templates/{TPL_NAME}/css/responsive.dataTables.min.css">
<div id="titlebar">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h2>{LANG_TRANSACTIONS}</h2>
                <!-- Breadcrumbs -->
                <nav id="breadcrumbs" class="dark">
                    <ul>
                        <li><a href="{LINK_INDEX}">{LANG_HOME}</a></li>
                        <li>{LANG_TRANSACTIONS}</li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>
<div class="container">
    <table id="datatable">
        <thead>
            <tr>
                <th class="small-width"></th>
                <th>{LANG_TITLE}</th>
                <th class="small-width">{LANG_AMOUNT}</th>
                <th class="small-width">{LANG_PREMIUM}</th>
                <th>{LANG_PAYMENT_METHOD}</th>
                <th>{LANG_DATE}</th>
                <th class="small-width">{LANG_STATUS}</th>
                <th class="small-width"></th>
            </tr>
        </thead>
        IF("{T_BLANK}"=="0"){
        <tbody>
        <tr>
            <td colspan="7" class="text-center">{LANG_NO_RESULT_FOUND}</td>
        </tr>
        </tbody>
        {ELSE}
        <tbody>
            {LOOP: TRANSACTIONS}
            <tr>
                <td></td>
                <td>{TRANSACTIONS.product_name}</td>
                <td>
                    {TRANSACTIONS.amount}
                </td>
                <td>{TRANSACTIONS.premium}</td>
                <td>{TRANSACTIONS.payment_by}</td>
                <td>{TRANSACTIONS.time}</td>
                <td>{TRANSACTIONS.status}</td>
                <td>
                    IF("{TRANSACTIONS.invoice}"!=""){
                    <a href="{TRANSACTIONS.invoice}" class="button ico" data-tippy-placement="top" title="{LANG_INVOICE}" target="_blank"><i class="icon-feather-file-text"></i></a>
                    {:IF}
                </td>
            </tr>
            {/LOOP: TRANSACTIONS}
        </tbody>
        {:IF}
    </table>
    <div class="margin-bottom-50"></div>
</div>
<script src="{SITE_URL}templates/{TPL_NAME}/js/jquery.dataTables.min.js"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/dataTables.responsive.min.js"></script>
<script>
    
    $(document).ready(function () {
        $('#datatable').DataTable({
            responsive: {
                details: {
                    type: 'column'
                }
            },
            "language": {
                "paginate": {
                    "previous": "{LANG_PREVIOUS}",
                    "next": "{LANG_NEXT}"
                },
                "search": "{LANG_SEARCH}",
                "lengthMenu": "{LANG_DISPLAY} _MENU_",
                "zeroRecords": "{LANG_NO_RESULT_FOUND}",
                "info": "{LANG_PAGE} _PAGE_ - _PAGES_",
                "infoEmpty": "{LANG_NO_RESULT_FOUND}",
                "infoFiltered": "( {LANG_TOTAL_RECORD} _MAX_)"
            },
            columnDefs: [{
                className: 'control',
                orderable: false,
                targets: 0
            }]
        });
    });

</script>
{OVERALL_FOOTER}