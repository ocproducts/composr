<section class="box box---block-bottom-about-us">
	<div class="box-inner">
		<h3 class="box-heading">{!ABOUT_US}</h3>
		<div class="box-body">
			<h1 class="logo">
				<a class="logo-link" target="_self" href="{$PAGE_LINK*,:}" rel="home">
					{+START,IF,{$NOT,{$THEME_OPTION,use_site_name_text_as_logo}}}
					<img class="logo-image logo-image-white" src="{$IMG*,logo/small_white_logo}" alt="{$SITE_NAME*}" />
					{+END}
					{+START,IF,{$THEME_OPTION,use_site_name_text_as_logo}}
					<span class="logo-text">{$SITE_NAME*}</span>
					{+END}
				</a>
			</h1>
			
			<p>
				{SITE_DESCRIPTION*}
			</p>

			<div class="btn-row social-buttons">
				{+START,IF_PASSED,FACEBOOK_URL}
				<a href="{FACEBOOK_URL*}" class="btn btn-secondary">{+START,INCLUDE,ICON}NAME=links/facebook{+END}</a>
				{+END}
				{+START,IF_PASSED,TWITTER_URL}
				<a href="{TWITTER_URL*}" class="btn btn-secondary">{+START,INCLUDE,ICON}NAME=links/twitter{+END}</a>
				{+END}
				{+START,IF_PASSED,INSTAGRAM_URL}
				<a href="{INSTAGRAM_URL*}" class="btn btn-secondary">{+START,INCLUDE,ICON}NAME=links/instagram{+END}</a>
				{+END}
				{+START,IF_PASSED,YOUTUBE_URL}
				<a href="{YOUTUBE_URL*}" class="btn btn-secondary">{+START,INCLUDE,ICON}NAME=links/youtube{+END}</a>
				{+END}
			</div>
		</div>
	</div>
</section>