<section class="box box___block_main_newsletter_signup_done"><div class="box-inner">
	<h3>{!NEWSLETTER}{$?,{$NEQ,{NEWSLETTER_TITLE},{!GENERAL}},: {NEWSLETTER_TITLE*}}</h3>

	{$?,{PATH_EXISTS},{!SUCCESS_NEWSLETTER_AUTO_INSTANT,{PASSWORD*}},{!SUCCESS_NEWSLETTER_AUTO,{PASSWORD*}}}
</div></section>
