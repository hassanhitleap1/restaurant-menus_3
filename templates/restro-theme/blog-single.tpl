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
                        <li>{TITLE}</li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>
<div class="container margin-bottom-50">
    <div class="row">
        <div class="col-md-8 col-12">
            <!-- Blog Post -->
            <div class="blog-post single-post">
                IF({BLOG_BANNER}){
                IF('{IMAGE}'){
                <!-- Blog Post Thumbnail -->
                <div class="blog-post-thumbnail">
                    <div class="blog-post-thumbnail-inner">
                        <img class="lazy-load" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC"  data-original="{SITE_URL}storage/blog/{IMAGE}" alt="{TITLE}">
                    </div>
                </div>
                {:IF}
                {:IF}

                <!-- Blog Post Content -->
                <div class="blog-post-content">
                    <h3 class="margin-bottom-10">{TITLE}</h3>

                    <div class="blog-post-info-list margin-bottom-20">
                        <span class="blog-post-info"><i class="la la-clock-o"></i> {CREATED_AT}</span>
                        <span class="blog-post-info"><i class="fa fa-folder-o"></i> {CATEGORIES}</span>
                    </div>
                    <div class="user-html">{DESCRIPTION}</div>
                    IF({SHOW_TAG}){
                    <div class="task-tags margin-bottom-20">
                        {LANG_TAGS}: {BLOG_TAGS}
                    </div>
                    {:IF}
                    <!-- Share Buttons -->
                    <div class="share-buttons margin-top-25">
                        <div class="share-buttons-trigger"><i class="icon-feather-share-2"></i></div>
                        <div class="share-buttons-content">
                            <span><strong>{LANG_SHARE_IT}</strong></span>
                            <ul class="share-buttons-icons">
                                <li><a href="mailto:?subject={TITLE}&body={BLOG_LINK}" data-button-color="#dd4b39"
                                       title="{LANG_SHARE_EMAIL}" data-tippy-placement="top" rel="nofollow"
                                       target="_blank"><i class="fa fa-envelope"></i></a></li>
                                <li><a href="https://facebook.com/sharer/sharer.php?u={BLOG_LINK}"
                                       data-button-color="#3b5998" title="{LANG_SHARE_FACEBOOK}"
                                       data-tippy-placement="top" rel="nofollow" target="_blank"><i
                                                class="fa fa-facebook"></i></a></li>
                                <li><a href="https://twitter.com/share?url={BLOG_LINK}&text={TITLE}"
                                       data-button-color="#1da1f2" title="{LANG_SHARE_TWITTER}"
                                       data-tippy-placement="top" rel="nofollow" target="_blank"><i
                                                class="fa fa-twitter"></i></a></li>
                                <li><a href="https://www.linkedin.com/shareArticle?mini=true&url={BLOG_LINK}"
                                       data-button-color="#0077b5" title="{LANG_SHARE_LINKEDIN}"
                                       data-tippy-placement="top" rel="nofollow" target="_blank"><i
                                                class="fa fa-linkedin"></i></a></li>
                                <li>
                                    <a href="https://pinterest.com/pin/create/bookmarklet/?&url={BLOG_LINK}&description={TITLE}"
                                       data-button-color="#bd081c" title="{LANG_SHARE_PINTEREST}"
                                       data-tippy-placement="top" rel="nofollow" target="_blank"><i
                                                class="fa fa-pinterest-p"></i></a></li>
                                <li><a href="https://web.whatsapp.com/send?text={BLOG_LINK}" data-button-color="#25d366"
                                       title="{LANG_SHARE_WHATSAPP}" data-tippy-placement="top" rel="nofollow"
                                       target="_blank"><i class="fa fa-whatsapp"></i></a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            IF({BLOG_COMMENT_ENABLE}){
            <div class="blog-widget">
                <h3 class="widget-title margin-bottom-25">{LANG_COMMENTS} ({COMMENTS_COUNT})</h3>
                <div class="latest-comments">
                    <ul>
                        {LOOP: COMMENTS}
                            <li id="li-comment-{COMMENTS.id}" IF({COMMENTS.is_child}){
                                class="children-{COMMENTS.level}" {:IF}>
                                <div class="comments-box" id="comment-{COMMENTS.id}">
                                    <div class="comments-avatar">
                                        <img src="{SITE_URL}storage/profile/{COMMENTS.avatar}" alt="{COMMENTS.name}">
                                    </div>
                                    <div class="comments-text">
                                        <div class="avatar-name">
                                            <h5>{COMMENTS.name}</h5>
                                            <span>{COMMENTS.created_at}</span>
                                            IF({COMMENTS.level} < 3){
                                            <a class="comments-reply comment-reply-link" href="javascript:void(0)"
                                               data-commentid="{COMMENTS.id}" data-postid="{BLOG_ID}"
                                               data-belowelement="comment-{COMMENTS.id}"
                                               data-respondelement="respond"><i class="fa fa-reply"></i>{LANG_REPLY}</a>
                                            {:IF}
                                        </div>
                                        <p>{COMMENTS.comment}</p>
                                    </div>
                                </div>
                            </li>
                        {/LOOP: COMMENTS}
                    </ul>
                </div>
            </div>

            IF({SHOW_PAGING}){
            <div class="pagination-container margin-bottom-20">
                <nav class="pagination">
                    <ul>
                        {LOOP: COMMENT_PAGING}
                            IF("{COMMENT_PAGING.current}"=="0"){
                            <li><a href="{COMMENT_PAGING.link}">{COMMENT_PAGING.title}</a></li>
                        {ELSE}
                            <li><a href="#" class="current-page">{COMMENT_PAGING.title}</a></li>
                        {:IF}
                        {/LOOP: COMMENT_PAGING}
                    </ul>
                </nav>
            </div>
            {:IF}
            IF({SHOW_COMMENT_FORM}){
            <div class="blog-widget" id="respond">
                <h3 class="widget-title">{LANG_POST_COMMENT}
                    <small><a rel="nofollow" id="cancel-comment-reply-link" href="javascript:void(0)"
                              style="display: none;">{LANG_CANCEL_REPLY}</a></small>
                </h3>

                <div class="widget-content">
                    IF('{COMMENT_ERROR}'){
                    <div class="notification error">
                        <p>{COMMENT_ERROR}</p>
                    </div>
                    {:IF}
                    IF('{COMMENT_SUCCESS}'){
                    <div class="notification success">
                        <p>{COMMENT_SUCCESS}</p>
                    </div>
                    {:IF}
                    <form action="#respond" method="post" id="commentform" class="blog-comment-form">
                        <div class="row">
                            IF(!({ADMIN_LOGGED_IN} || {LOGGED_IN})){
                            <div class="col-md-6">
                                <div class="input-with-icon">
                                    <input class="with-border" type="text" placeholder="{LANG_YNAME} *" name="user_name"
                                           value="{USER_NAME}" required="">
                                    <i class="icon-feather-user"></i>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="input-with-icon">
                                    <input class="with-border" type="email" placeholder="{LANG_YEMAIL} *"
                                           name="user_email" value="{USER_EMAIL}" required>
                                    <i class="icon-feather-mail"></i>
                                </div>
                            </div>
                            {:IF}
                            IF({ADMIN_LOGGED_IN} && {LOGGED_IN}){
                            <div class="col-md-12">
                                <div class="commenting-as">
                                    <label for="commenting-as">{LANG_COMMENTING_AS}</label>
                                    <select id="commenting-as" name="commenting-as"
                                            class="selectpicker with-border col-md-4">
                                        <option value="admin">{ADMIN_USERNAME} ({LANG_ADMIN})</option>
                                        <option value="user">{USERNAME}</option>
                                    </select>
                                </div>
                            </div>
                            ELSEIF({ADMIN_LOGGED_IN}){
                            <div class="col-md-12">
                                <p>{LANG_COMMENTING_AS} <strong>{ADMIN_USERNAME}</strong> ({LANG_ADMIN})</p>
                            </div>
                            ELSEIF({LOGGED_IN}){
                            <div class="col-md-12">
                                <p>{LANG_COMMENTING_AS} <strong>{USERNAME}</strong></p>
                            </div>
                            {:IF}
                            <div class="col-md-12">
                                <textarea rows="5" id="comment-field" class="with-border" name="comment" placeholder="{LANG_YOUR_COMMENT}"
                                          required>{COMMENT}</textarea>
                                <button type="submit" name="comment-submit"
                                        class="button ripple-effect">{LANG_SUBMIT}</button>
                                <input type="hidden" name="comment_parent" id="comment_parent" value="0">
                                <input type="hidden" name="comment_post_ID" value="{BLOG_ID}" id="comment_post_ID">
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            {ELSE}
            <div class="blog-widget">
                {LANG_LOGIN_POST_COMMENT}
            </div>
            {:IF}
            {:IF}
        </div>
        <div class="col-md-4 hide-under-768px">
            <div class="blog-widget">
                <form action="{LINK_BLOG}">
                    <div class="input-with-icon">
                        <input class="with-border" type="text" placeholder="{LANG_SEARCH}..." name="s"
                               id="search-widget">
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
            <div class="blog-widget">
                <h3 class="widget-title">{LANG_RECENT_BLOG}</h3>

                <div class="recent-post-widget">
                    {LOOP: RECENT_BLOG}
                        <div>
                            IF({BLOG_BANNER}){
                            <a href="{RECENT_BLOG.link}">
                                <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC"  data-original="{SITE_URL}storage/blog/{RECENT_BLOG.image}" alt="{RECENT_BLOG.title}"
                                     class="post-thumb lazy-load">
                            </a>
                            {:IF}

                            <div class="recent-post-widget-content">
                                <h2><a href="{RECENT_BLOG.link}">{RECENT_BLOG.title}</a></h2>

                                <div class="post-date">
                                    <i class="icon-feather-clock"></i> {RECENT_BLOG.created_at}
                                </div>
                            </div>
                        </div>
                    {/LOOP: RECENT_BLOG}
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
                    <div class="job-tags">
                        {ALL_TAGS}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="{SITE_URL}templates/{TPL_NAME}/js/comment-reply.js"></script>
{OVERALL_FOOTER}