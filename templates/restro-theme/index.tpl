{OVERALL_HEADER}

<div class="hero-section">
    <div class="container">

        <!-- Intro Headline -->
        <div class="row">
            <div class="col-md-12">
                <div class="text-center hero-content">
                    <img class="lazy-load" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC"  data-original="{SITE_URL}templates/{TPL_NAME}/images/qr-screen.png">

                    <h1 class="margin-bottom-10">
                        <strong>{LANG_QUICK_QR_SCAN}</strong>
                        <br>{LANG_QUICK_QR_SCAN}
                        {LANG_CONTACTLESS_DIGITAL_MENU}
                    </h1>

                    <p><span>{LANG_HOME_DESCRIPTION1} <strong>{LANG_HOME_DESCRIPTION2}</strong> <br>{LANG_HOME_DESCRIPTION3}</span></p>
                    IF('{USERNAME}'!=""){
                    <a href="{LINK_QRBUILDER}" class="button ripple-effect">{LANG_QRBUILDER}</a>
                    {ELSE}
                    <a href="#sign-in-dialog" class="popup-with-zoom-anim button ripple-effect">{LANG_JOIN_NOW}</a>
                    {:IF}
                </div>

            </div>
        </div>

    </div>
</div>
<div class="section padding-top-65 padding-bottom-75">
    <div class="container">
        <div class="service">
            <div class="row align-items-center flex-row-reverse tabs">
                <div class="col-lg-5">
                    <div class="service_content tabs-header">
                        <div class="section_title undefined"><h6>{LANG_WHAT_WE_DO}</h6>
                            <h2>{LANG_INNOVATIVE_SOLUTIONS}</h2>
                        </div>
                        <p>{LANG_WHAT_WE_DO_DESC}</p>
                        <ul class="nav nav-tabs" id="myTab" role="tablist">
                            <li class="nav-item active">
                                <a class="nav-link" href="#tab-1" data-tab-id="1">{LANG_CREATE_YOUR_MENU}</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#tab-2" data-tab-id="2">{LANG_DESIGN_QR_DOWNLOAD}</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#tab-3" data-tab-id="3">{LANG_GETTING_LIVE}</a>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="col-lg-7">
                    <div class="tabs-content" id="myTabContent">
                        <div class="tab active" data-tab-id="1">
                            <div class="service_img"><img src="{SITE_URL}templates/{TPL_NAME}/images/menu.png" alt="" width="500px"></div>
                        </div>
                        <div class="tab" data-tab-id="2">
                            <div class="service_img"><img src="{SITE_URL}templates/{TPL_NAME}/images/qrcode-genrate.png" alt="" width="500px"></div>
                        </div>
                        <div class="tab" data-tab-id="3">
                            <div class="service_img"><img src="{SITE_URL}templates/{TPL_NAME}/images/golive.png" alt="" width="500px"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Section Service End-->

<!-- Testimonials -->
IF({TESTIMONIALS_ENABLE} && {SHOW_TESTIMONIALS_HOME}){
<div class="section padding-top-65 padding-bottom-55 gray">

    <div class="container">
        <div class="row">
            <div class="col-xl-12">
                <!-- Section Headline -->
                <div class="section-headline centered margin-top-0 margin-bottom-5">
                    <h3>{LANG_TESTIMONIALS}</h3>
                </div>
            </div>
        </div>
    </div>

    <!-- Categories Carousel -->
    <div class="fullwidth-carousel-container margin-top-20">
        <div class="testimonial-carousel testimonials">
            <!-- Item -->
            {LOOP: TESTIMONIALS}
                <div class="fw-carousel-review">
                    <div class="testimonial-box">
                        <div class="testimonial-avatar">
                            <img class="lazy-load" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC"  data-original="{SITE_URL}storage/testimonials/{TESTIMONIALS.image}" alt="{TESTIMONIALS.name}">
                        </div>
                        <div class="testimonial-author">
                            <h4>{TESTIMONIALS.name}</h4>
                            <span>{TESTIMONIALS.designation}</span>
                        </div>
                        <div class="testimonial">{TESTIMONIALS.content}</div>
                    </div>
                </div>
            {/LOOP: TESTIMONIALS}
        </div>
    </div>
    <!-- Categories Carousel / End -->
</div>
{:IF}
<!-- Testimonials / End -->
IF("{PURCHASE_TYPE}"=="pro"){
<!-- Membership Plans -->
<div class="section padding-top-60 padding-bottom-75">
    <div class="container">
        <div class="row">

            <div class="col-xl-12">
                <!-- Section Headline -->
                <div class="section-headline centered margin-top-0 margin-bottom-75">
                    <h3>{LANG_MEMBERSHIPPLAN}</h3>
                </div>
            </div>


            <div class="col-xl-12">
                <form name="form1" method="post" action="{LINK_MEMBERSHIP}/changeplan">
                <div class="billing-cycle-radios margin-bottom-70">
                    IF("{TOTAL_MONTHLY}"!="0"){
                    <div class="radio billed-monthly-radio">
                        <input id="radio-monthly" name="billed-type" type="radio" value="monthly" checked="">
                        <label for="radio-monthly"><span class="radio-label"></span> {LANG_MONTHLY}</label>
                    </div>
                    {:IF}
                    IF("{TOTAL_ANNUAL}"!="0"){
                    <div class="radio billed-yearly-radio">
                        <input id="radio-yearly" name="billed-type" type="radio" value="yearly">
                        <label for="radio-yearly"><span class="radio-label"></span> {LANG_YEARLY}</label>
                    </div>
                    {:IF}
                    IF("{TOTAL_LIFETIME}"!="0"){
                    <div class="radio billed-lifetime-radio">
                        <input id="radio-lifetime" name="billed-type" type="radio" value="lifetime">
                        <label for="radio-lifetime"><span class="radio-label"></span> {LANG_LIFETIME}</label>
                    </div>
                    {:IF}
                </div>
                <!-- Pricing Plans Container -->
                <div class="pricing-plans-container">
                    {LOOP: SUB_TYPES}
                    <!-- Plan -->
                    <div class="pricing-plan IF("{SUB_TYPES.recommended}"=="yes"){ recommended {:IF}">
                    IF("{SUB_TYPES.recommended}"=="yes"){ <div class="recommended-badge">{LANG_RECOMMENDED}</div> {:IF}
                    <h3>{SUB_TYPES.title}</h3>
                    IF("{SUB_TYPES.id}"=="free" || "{SUB_TYPES.id}"=="trial"){
                    <div class="pricing-plan-label"><strong>
                            IF("{SUB_TYPES.id}"=="free"){
                            {LANG_FREE}
                            {ELSE}
                            {LANG_TRIAL}
                            {:IF}
                        </strong></div>
                    {ELSE}
                    IF("{TOTAL_MONTHLY}"!="0"){
                    <div class="pricing-plan-label billed-monthly-label"><strong>{SUB_TYPES.monthly_price}</strong>/ {LANG_MONTHLY}</div>
                    {:IF}
                    IF("{TOTAL_ANNUAL}"!="0"){
                    <div class="pricing-plan-label billed-yearly-label"><strong>{SUB_TYPES.annual_price}</strong>/ {LANG_YEARLY}</div>
                    {:IF}
                    IF("{TOTAL_LIFETIME}"!="0"){
                    <div class="pricing-plan-label billed-lifetime-label"><strong>{SUB_TYPES.lifetime_price}</strong> {LANG_LIFETIME}</div>
                    {:IF}
                    {:IF}
                    <div class="pricing-plan-features">
                        <strong>{LANG_FEATURES_OF} {SUB_TYPES.title}</strong>
                        <ul>
                            <li>{SUB_TYPES.category_limit} {LANG_MENU_CATEGORIES}</li>
                            <li>{SUB_TYPES.menu_limit} {LANG_MENU_ITEMS_PER_CATEGORY}</li>
                            <li>{SUB_TYPES.scan_limit} {LANG_SCANS_PER_MONTH}</li>
                            <li>
                                IF("{SUB_TYPES.allow_ordering}"=="1"){
                                <span class="icon-text yes"><i class="icon-feather-check-circle margin-right-2"></i></span>
                                {ELSE}
                                <span class="icon-text no"><i class="icon-feather-x-circle margin-right-2"></i></span>
                                {:IF}
                                {LANG_ALLOW_RESTAURANTS_ORDERS}
                            </li>
                            {SUB_TYPES.custom_settings}
                        </ul>
                    </div>

                    IF("{SUB_TYPES.Selected}"=="0"){
                    IF('{USERNAME}'!=""){
                    <button type="submit" class="button full-width margin-top-20 ripple-effect" name="upgrade" value="{SUB_TYPES.id}">{LANG_UPGRADE}</button>

                    {ELSE}
                    <a href="#sign-in-dialog" class="popup-with-zoom-anim button full-width margin-top-20 ripple-effect">{LANG_JOIN_NOW}</a>
                    {:IF}
                    {ELSE}
                    <a href="javascript:void(0);" class="button full-width margin-top-20 ripple-effect">
                        {LANG_CURRENT_PLAN}
                    </a>
                    {:IF}
                </div>
                {/LOOP: SUB_TYPES}
                </div>
            </form>
            </div>

        </div>
    </div>
</div>
<!-- Membership Plans / End-->
{:IF}

<!-- Recent Blog Posts -->
IF({BLOG_ENABLE} && {SHOW_BLOG_HOME}){
<div class="section IF("{PURCHASE_TYPE}"=="pro"){ gray {:IF} padding-top-65 padding-bottom-50">
    <div class="container">
        <div class="row">
            <div class="col-xl-12">
                <!-- Section Headline -->
                <div class="section-headline margin-top-0 margin-bottom-45">
                    <h3>{LANG_RECENT_BLOG}</h3>
                    <a href="{LINK_BLOG}" class="headline-link">{LANG_VIEW_BLOG}</a>
                </div>

                <div class="row">
                    <!-- Blog Post Item -->
                    {LOOP: RECENT_BLOG}
                        <div class="col-xl-4">
                            <a href="{RECENT_BLOG.link}" class="blog-compact-item-container">
                                <div class="blog-compact-item">
                                    <img class="lazy-load" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC"  data-original="{SITE_URL}storage/blog/{RECENT_BLOG.image}"
                                         alt="{RECENT_BLOG.title}">
                                    <span class="blog-item-tag">{RECENT_BLOG.author}</span>
                                    <div class="blog-compact-item-content">
                                        <ul class="blog-post-tags">
                                            <li>{RECENT_BLOG.created_at}</li>
                                        </ul>
                                        <h3>{RECENT_BLOG.title}</h3>
                                        <p>{RECENT_BLOG.description}</p>
                                    </div>
                                </div>
                            </a>
                        </div>
                    {/LOOP: RECENT_BLOG}
                    <!-- Blog post Item / End -->
                </div>
            </div>
        </div>
    </div>
</div>
    {:IF}
    <!-- Recent Blog Posts / End -->
{OVERALL_FOOTER}