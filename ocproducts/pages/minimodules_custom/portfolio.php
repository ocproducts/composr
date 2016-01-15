<?php

require_css('composr_homesite__portfolio');

$projects = array(
    'cms' => array(
        'TITLE' => 'compo.sr',
        'INTRO' => 'The compo.sr site (this site) is perhaps the best example we can give of Composr, as it is our own site that we keep up-to-date.' . "\n\n" . 'compo.sr involves and integrates a wide range of technologies, as well as serving background maintenance requests from individual Composr websites.',
        'FEATURES' => array('Member signup', 'Maps', 'Forums', 'News', 'Downloads', 'Review/Comments', 'Custom modules', 'Custom blocks', 'Custom theme', 'Banners', 'Catalogues'),
    ),
    'fm' => array(
        'TITLE' => 'FishingMobile',
        'INTRO' => 'FishingMobile is a mobile app available for iOS and Android, and website built with Composr. The mobile app has over 100,000 downloads, and the majority of users rate the app 5 out of 5 stars.' . "\n\n" . 'ocProducts manages all aspects of development.' . "\n\n" . 'Third-party contributors submit content to the website, taking advantage of the high-quality content management functionality.' . "\n\n" . 'A large number of ocProducts technologies are involved, all working together in harmony across several platforms.',
        'FEATURES' => array('Member signup', 'Maps', 'Forums', 'News', 'Composr Mobile SDK', 'Review/Comments', 'Custom modules', 'Custom blocks', 'Custom theme', 'Banners'),
    ),
    'viewfindr' => array(
        'TITLE' => 'Viewfindr',
        'INTRO' => 'Viewfindr is a tool for photographers and sightseers to share the best spots around the world. Sights are organised by GPS, in an extensive world-wide taxonomy (down to the level of villages), and tagged against many searchable criteria.' . "\n\n" . 'The slide-show interface for navigating media is wonderfully user-friendly, as are all the interfaces for managing and browsing content. Heavy use of JavaScript and HTML5 technologies lead to a highly interactive experience.' . "\n\n" . 'Without Composr this project would have required a very large investment just to provide the basic technology framework -- instead through Composr all investment is channeled into the website\'s unique functionality. The web design was done by the very talented [url="http://www.hypeandslippers.com/"]Hype & Slippers[/url] team and implemented by ocProducts.',
        'FEATURES' => array('Member signup', 'Maps', 'Galleries', 'Catalogues', 'Quizzes', 'News', 'Awards', 'Banners', 'Review/Comments', 'Custom modules', 'Custom blocks', 'Custom theme'),
        'TESTIMONIAL' => 'I am extremely glad that I chose Composr and its development team for Viewfindr.  Composr is powerful and packed with the features I needed straight out of the box, yet is still intuitive and easy to use.  The development team truly go above and beyond - they really took the time to understand Viewfindr\'s concept, its aims and its target market, and created a finished product that\'s better than I could have imagined. I would not hesitate to recommend Composr for any website, big or small.',
    ),
    'apr' => array(
        'TITLE' => 'Accessible Property Register',
        'INTRO' => 'APR is a property website specially designed to advertise property and holiday resorts for people with special needs. The site uses many standard Composr features, but we also wrote a property addon tailored to the needs of APR. Composr\'s strong technical framework made this quick and easy for us. APR has been going strong as a successful property website for over 10 years.',
        'FEATURES' => array('news', 'quizzes', 'Comcode pages/WYSIWYG', 'eCommerce', 'addon framework', 'banners'),
        'TESTIMONIAL' => "&ldquo;Compared with the previous version of the website the Composr version is better on every measure.  Looks better, more visitors, more page views etc.  We are now consistently getting more than 1000 page views per day  (prev' 50 views was a good day).&rdquo; -- Conrad Hodgkinson",
    ),
    'wa' => array(
        'TITLE' => 'Warsash Association',
        'INTRO' => 'The Warsash Association website is a new online community for ex-members of the leading Merchant Navy training establishment that has existed since 1936. The website allows ex-cadets and senior ex-students who attended the Warsash Maritime Academy for officer training course, and staff, to keep in touch, share stories, pictures and experiences.',
        'FEATURES' => array('news', 'forum', 'calendar', 'downloads', 'galleries', 'Comcode pages', 'images of the day', 'polls', 'auto-generated drop down menus', 'search (website-wide and focused)'),
        'MORE' => "The Warsash Association (which represents former cadets, senior students and staff members of the Warsash Maritime Association) approached ocProducts for a complete regeneration of their web presence due to a number of problems with their old website. As with any major transition project, there was a large amount of existing content that needed to be transferred alongside new content that needed to be added, however the high percentage of older users necessitated that the site design remained simple to navigate with easily accessible content (which fits with ocProducts' goal of producing the most accessible/standards-compliant CMS in production).",
        'TESTIMONIAL' => "&ldquo;In conjunction with vigorous research and recruiting campaign membership increased from 217 in December 2008 to current 348 members. Two new branches established in Australia and New Zealand. Averaging about 2 online applications to join per week. The site now has far greater usage  compared with previous static website; now around 50--100 unique visitors/ day (the previous average was unknown but probably 1--2/ day if that)\n\nThe great strength of using Composr is that it offers a large range of functions and features which are totally integrated. These functions include members only access, forums, galleries, newsletters, event calendars and online payments. Throughout the project ocProducts demonstrated a high degree of professionalism and great technical expertise. Its highly co-operative approach and prompt response to suggestions has contributed greatly to a superb website tailored to our needs.\n\nThis initial phase of development was completed within our own fairly relaxed timescale and to a fixed-price budget. The website is moderated and maintained on a day to day basis by ourselves using Composr with ocProducts providing second line support when required. We intend to use ocProducts for any major enhancements in the future.&rdquo; Chris Clarke -- Web Director -- The Warsash Association\n\n&ldquo;The diligent manner in which you provide constructive technical advice has been most helpful and the cooperation and close attention your company has given to our needs, exemplary. We are delighted with the end product and consider this to represent very good value.\n\nThe website has enabled our association to consolidate its widespread membership, bringing together many members who have been out of touch for decades. It has also proved to be a most valuable and productive recruiting tool.&rdquo; Commodore AD Barrett -- President of the Warsash association.",
    ),
    'blaby' => array(
        'TITLE' => 'Blaby Council Intranet',
        'INTRO' => 'A low-cost but high-value redevelopment of the Blaby District Council intranet systems, providing a content management system with tiered administration privileges and an automatic login system tied to network user accounts via Active Directory.' . "\n\n" . 'Primarily implementing Composr product features that are supplied "out of the box", the Blaby District Council intranet project illustrates how Composr can be deployed for a fully functional solution with minimal development and at very low cost.',
        'FEATURES' => array('Zones', 'User generated content', 'News aggregation via RSS', 'Templated newsletters', 'Event calendars', 'Classifieds', 'Polls/consultations', 'FAQs', 'Forums', 'Site search'),
    ),
    'ads' => array(
        'TITLE' => 'The Autodidact Symposium',
        'INTRO' => 'The ADS site was built to showcase information about an upcoming conference: allowing guests to see the benefits, review the speakers, and apply for registration.' . "\n\n" . 'The site doesn\'t use many features, but this illustrates how well Composr can scale down; later on the site may be scaled up with new features such a forum, which Composr would make very easy.',
        'FEATURES' => array('member signup', 'Comcode pages'),
    ),
    'pty' => array(
        'TITLE' => 'Property to you',
        'INTRO' => 'PTY is a property website in reverse &ndash; instead of advertising property, users submit their requirements and other users with matching property can then respond.' . "\n\n" . 'It\'s ideal for people thinking of moving but not ready to put their home on the open market, and a great convenience for those looking to buy. It also cuts out the middle-man.',
        'FEATURES' => array('news', 'Comcode pages/WYSIWYG', 'addon framework', 'banners'),
    ),
    'xerox' => array(
        'TITLE' => 'Project for Xerox (confidential)',
        'INTRO' => 'We maintain a tool for automating student assessment within Xerox\'s learning services division.',
        'OTHER_FEATURES' => array('Databases', 'Formulae'),
    ),
    'att' => array(
        'TITLE' => 'Project for AT&T (confidential)',
        'INTRO' => 'We maintain a training tool for AT&T involving Composr.',
        'OTHER_FEATURES' => array('Members', 'Permissions', 'Ultra high security'),
    ),
);

$type = get_param_string('type', null);

if (is_null($type)) {
    $title = get_screen_title('Portfolio: a few select ocProducts projects', false);
    $title->evaluate_echo();

    echo "<p>These are just a few of the projects we've done over the years. We expect it will give you an idea of the scope and flexibility of a Composr solution.</p>";

    echo "<p>To be honest keeping this page updated is a low priority for us, as we tend to focus on serving the daily needs of empowering Composr users rather than promoting ourselves as an agency &ndash; a huge task, given there are over 500 open feature requests at the time of writing.</p>";

    echo "<p>We suggest contacting us so we can explain how Composr can apply for you and give you an answer grounded in the fundamentals of our technology.</p>";

    echo "<hr />";
} else {
    $title = get_screen_title($projects[$type]['TITLE'], false);
    $title->evaluate_echo();
}

foreach ($projects as $codename => $project) {
    if ((!is_null($type)) && ($type != $codename)) {
        continue;
    }

    if (is_string($project)) {
        if (is_null($type)) {
            echo '<h2>' . $project . '</h2>';
        }
    } else {
        echo '
            <div class="project float_surrounder">
        ';

        // Heading
        if (is_null($type)) {
            echo '<h3>' . escape_html($project['TITLE']) . '</h3>';
        }

        // Image
        if (file_exists(get_custom_file_base() . '/uploads/website_specific/compo.sr/portfolio/' . $codename . '_thumb.png')) {
            $link_tag_open = '<a rel="lightbox" target="_blank" title="' . escape_html($project['TITLE']) . '" href="' . get_base_url() . '/uploads/website_specific/compo.sr/portfolio/' . escape_html($codename) . '.png">';
            $link_tag_close = '</a>';
            echo '
                <div class="project_image">
                    ' . $link_tag_open . '<img alt="Screenshot of ' . escape_html($project['TITLE']) . '" title="" src="' . get_base_url() . '/uploads/website_specific/compo.sr/portfolio/' . escape_html($codename) . '_thumb.png" />' . $link_tag_close . '
                    <p class="project_click_caption">' . $link_tag_open . '&raquo; Click to enlarge' . $link_tag_close . '</p>
                </div>
            ';
        }

        // Description
        //$comcode = '[section="About"]' . $project['INTRO'] . '[/section][section="Features"]' . "\n" . 'Standard Composr features used include:' . "\n";
        $comcode = '';
        $comcode .= $project['INTRO'];
        if (isset($project['FEATURES'])) {
            $comcode .= "\n\n" . 'Standard Composr features used include:' . "\n";
            foreach ($project['FEATURES'] as $f) {
                $comcode .= ' - ' . escape_html($f) . "\n";
            }
        }
        if (isset($project['OTHER_FEATURES'])) {
            $comcode .= "\n\n" . 'This project involved:' . "\n";
            foreach ($project['OTHER_FEATURES'] as $f) {
                $comcode .= ' - ' . escape_html($f) . "\n";
            }
        }
        //$comcode .= '[/section][section_controller]About,Features[/section_controller]';
        $intro = comcode_to_tempcode($comcode);
        echo '
            <div class="project_description">' . $intro->evaluate() . '</div>
        ';
        if (is_null($type)) {
            if ((isset($project['MORE'])) || (isset($project['TESTIMONIAL']))) {
                $url = build_url(array('page' => '_SELF', 'type' => $codename), '_SELF');
                echo '
                    <p class="project_description">&raquo; <a href="' . escape_html($url->evaluate()) . '" title="More on ' . escape_html($project['TITLE']) . '">Read more</a></p>
            ';
            }
        } else {
            if (isset($project['MORE'])) {
                $more = comcode_to_tempcode($project['MORE']);

                echo '
                    <h3 class="project_further_descrip">Background details</h3>
                    <div class="project_description">' . $more->evaluate() . '</div>
                ';
            }

            if (isset($project['TESTIMONIAL'])) {
                $testimonial = comcode_to_tempcode($project['TESTIMONIAL']);

                echo '
                    <h3 class="project_further_descrip">What our client had to say</h3>
                    <div class="project_description">' . $testimonial->evaluate() . '</div>
                ';
            }
        }
        echo '
            </div>
        ';
    }
}
