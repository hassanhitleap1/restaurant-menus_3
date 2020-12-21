<?php

$id = $_GET['id'];

$rows = ORM::for_table($config['db']['pre'] . 'transaction')->find_one($id);

if (isset($rows['id'])) {
    if (isset($_SESSION['user']['id']) || isset($_SESSION['admin']['id'])) {

        if(isset($_SESSION['user']['id']) && ($rows['seller_id'] != $_SESSION['user']['id']) ){
            /* redirect to 404 */
            error($lang['PAGE_NOT_FOUND'], __LINE__, __FILE__, 1);
        }

        $billing = json_decode((string)$rows['billing'], true);
        $billing_country = get_countryName_by_code(
            isset($billing['country'])
                ? $billing['country']
                : get_user_option($_SESSION['user']['id'], 'billing_country')
        );

        $invoice_date = date('d M Y', $rows['transaction_time']);
        $item_price = !empty($rows['base_amount'])?$rows['base_amount']:$rows['amount'];

        /* Get payment gateway */
        $payment_gateway = ORM::for_table($config['db']['pre'] . 'payments')
            ->where('payment_folder', $rows['transaction_gatway'])
            ->find_one();

        /* get applied taxes */
        $plan_taxes = array();
        $taxes = ORM::for_table($config['db']['pre'].'taxes')
            ->where_id_in(explode(',', $rows['taxes_ids']))
            ->find_many();

        $inclusive_tax = $exclusive_tax = 0;

        foreach ($taxes as $tax){

            /* Create variable */
            $plan_taxes[$tax['id']]['id'] = $tax['id'];
            $plan_taxes[$tax['id']]['name'] = $tax['name'];
            $plan_taxes[$tax['id']]['description'] = $tax['description'];
            $plan_taxes[$tax['id']]['type'] = $tax['type'];

            /* calculate inclusive taxes */
            if($tax['type'] == 'inclusive'){
                $inclusive_tax += $tax['value_type'] == 'percentage' ? $item_price * ($tax['value'] / 100) : $tax['value'];
                $plan_taxes[$tax['id']]['value_formatted'] = price_format($inclusive_tax, get_option('currency_code'));
            }

            $tax_ids[] = $tax['id'];
        }

        $price_without_inclusive = $item_price - $inclusive_tax;

        /* calculate exclusive taxes */
        foreach ($taxes as $tax){
            if($tax['type'] == 'exclusive'){
                $exclusive_tax += $tax['value_type'] == 'percentage' ? $price_without_inclusive * ($tax['value'] / 100) : $tax['value'];
                $plan_taxes[$tax['id']]['value_formatted'] = price_format($exclusive_tax, get_option('currency_code'));
            }
        }

        $page = new HtmlTemplate ('templates/' . $config['tpl_name'] . '/invoice.tpl');
        $page->SetParameter('INVOICE_DATE', $invoice_date);
        $page->SetParameter('INVOICE_ID', $rows['id']);
        $page->SetParameter('ITEM_NAME', $rows['product_name']);
        $page->SetParameter('PAID_VIA', $payment_gateway['payment_title']);
        $page->SetParameter('ITEM_AMOUNT', price_format($price_without_inclusive,get_option('currency_code')));
        $page->SetParameter('TOTAL_AMOUNT', price_format($rows['amount'],get_option('currency_code')));

        $page->SetLoop ('TAXES', $plan_taxes);

        $page->SetParameter('ADMIN_COUNTRY', get_countryName_by_code($config['invoice_admin_country']));
        $page->SetParameter('BILLING_DETAILS_TYPE', isset($billing['type']) ? $billing['type'] : get_user_option($_SESSION['user']['id'], 'billing_details_type'));
        $page->SetParameter('BILLING_TAX_ID', isset($billing['tax_id']) ? $billing['tax_id'] : get_user_option($_SESSION['user']['id'], 'billing_tax_id'));
        $page->SetParameter('BILLING_NAME', isset($billing['name']) ? $billing['name'] : get_user_option($_SESSION['user']['id'], 'billing_name'));
        $page->SetParameter('BILLING_ADDRESS', isset($billing['address']) ? $billing['address'] : get_user_option($_SESSION['user']['id'], 'billing_address'));
        $page->SetParameter('BILLING_CITY', isset($billing['city']) ? $billing['city'] : get_user_option($_SESSION['user']['id'], 'billing_city'));
        $page->SetParameter('BILLING_STATE', isset($billing['state']) ? $billing['state'] : get_user_option($_SESSION['user']['id'], 'billing_state'));
        $page->SetParameter('BILLING_ZIPCODE', isset($billing['zipcode']) ? $billing['zipcode'] : get_user_option($_SESSION['user']['id'], 'billing_zipcode'));
        $page->SetParameter('BILLING_COUNTRY', $billing_country);

        $page->CreatePageEcho();
        exit();
    }
}

/* redirect to 404 */
error($lang['PAGE_NOT_FOUND'], __LINE__, __FILE__, 1);