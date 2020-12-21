{OVERALL_HEADER}
<div id="titlebar">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h2>{TITLE}</h2>
                <!-- Breadcrumbs -->
                <nav id="breadcrumbs">
                    <ul>
                        <li><a href="{LINK_INDEX}">{LANG_HOME}</a></li>
                        <li><a href="{LINK_BLOG}">{LANG_BLOG}</a></li>
                    </ul>
                </nav>

            </div>
        </div>
    </div>
</div>
<div class="container margin-bottom-50">
    <div class="row">
        <div class="col-md-8 col-12">
            IF({RESULT_FOUND}){
            <div class="listings-container grid-layout">
                {LOOP: BLOG}
                    <a href="{BLOG.link}" class="blog-post">
                        IF({BLOG_BANNER}){
                        <!-- Blog Post Thumbnail -->
                        <div class="blog-post-thumbnail">
                            <div class="blog-post-thumbnail-inner">
                                <img class="lazy-load" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC"  data-original="{SITE_URL}storage/blog/{BLOG.image}" alt="{BLOG.title}">
                            </div>
                        </div>
                        {:IF}
                        <!-- Blog Post Content -->
                        <div class="blog-post-content">
                            <span class="blog-post-date">{BLOG.created_at}</span>
                            <h3>{BLOG.title}</h3>
                            <p>{BLOG.description}</p>
                        </div>
                        <!-- Icon -->
                        <div class="entry-icon"></div>
                    </a>
                {/LOOP: BLOG}
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
            {ELSE}
            <div class="blog-not-found">
                <h2><span>:</span>(</h2>
                <p>
                    {LANG_BLOG_NOT_FOUND}
                </p>
            </div>
            {:IF}
        </div>
        <div class="col-md-4 hide-under-768px">
            <div class="blog-widget">
                <form action="{LINK_BLOG}">
                    <div class="input-with-icon">
                        <input class="with-border" type="text" placeholder="{LANG_SEARCH}..." name="s"
                               id="search-widget" value="{SEARCH}">
                        <i class="icon-feather-search"></i>
                    </div>
                </form>
            </div>
            <div class="blog-widget">
                <h3 class="widget-title">{LANG_CATEGORIES}</h3>
                <div class="widget-content">
                    <ul>
                        {LOOP: BLOG_CAT}
                            <li class="clearfix">
                                <a href="{BLOG_CAT.link}">
                                    <span class="pull-left">{BLOG_CAT.title}</span>
                                    <span class="pull-right">({BLOG_CAT.blog})</span></a>
                            </li>
                        {/LOOP: BLOG_CAT}
                    </ul>
                </div>
            </div>
            IF({TESTIMONIALS_ENABLE} && {SHOW_TESTIMONIALS_BLOG}){
            <div class="blog-widget">
                <h3 class="widget-title">{LANG_TESTIMONIALS}</h3>
                <div class="single-carousel">
                    {LOOP: TESTIMONIALS}
                        <div class="single-testimonial">
                            <div class="single-inner">
                                <div class="testimonial-content">
                                    <p>{TESTIMONIALS.content}</p>
                                </div>
                                <div class="testi-author-info">
                                    <div class="image"><img src="{SITE_URL}storage/testimonials/{TESTIMONIALS.image}" alt="{TESTIMONIALS.name}"></div>
                                    <h5 class="name">{TESTIMONIALS.name}</h5>
                                    <span class="designation">{TESTIMONIALS.designation}</span>
                                </div>
                            </div>
                        </div>
                    {/LOOP: TESTIMONIALS}
                </div>
            </div>
            {:IF}
            <div class="blog-widget">
                <h3 class="widget-title">{LANG_TAGS}</h3>
                <div class="widget-content">
                    <div class="task-tags">
                        {ALL_TAGS}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
{OVERALL_FOOTER}