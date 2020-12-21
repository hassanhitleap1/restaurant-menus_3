{OVERALL_HEADER}
<div id="titlebar">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h2>{LANG_TESTIMONIALS}</h2>
                <!-- Breadcrumbs -->
                <nav id="breadcrumbs">
                    <ul>
                        <li><a href="{LINK_INDEX}">{LANG_HOME}</a></li>
                        <li><a href="{LINK_TESTIMONIALS}">{LANG_TESTIMONIALS}</a></li>
                    </ul>
                </nav>

            </div>
        </div>
    </div>
</div>
<div class="container margin-bottom-50">
    <div class="row">
        {LOOP: TESTIMONIALS}
            <div class="col-md-4">
                <div class="single-testimonial">
                    <div class="single-inner">
                        <div class="testimonial-content">
                            <p>{TESTIMONIALS.content}</p>
                        </div>
                        <div class="testi-author-info">
                            <div class="image"><img src="{SITE_URL}storage/testimonials/{TESTIMONIALS.image}"
                                                    alt="{TESTIMONIALS.name}"></div>
                            <h5 class="name">{TESTIMONIALS.name}</h5>
                            <span class="designation">{TESTIMONIALS.designation}</span>
                        </div>
                    </div>
                </div>
            </div>
        {/LOOP: TESTIMONIALS}
    </div>
    IF({SHOW_PAGING}){
    <div class="pagination-container margin-top-20">
        <nav class="pagination">
            <ul>
                {LOOP: PAGES}
                    IF("{PAGES.current}"=="0"){
                    <li><a href="{PAGES.link}">{PAGES.title}</a></li>
                {ELSE}
                    <li><a href="#" class="current-page">{PAGES.title}</a></li>
                {:IF}
                {/LOOP: PAGES}
            </ul>
        </nav>
    </div>
    {:IF}
</div>
{OVERALL_FOOTER}