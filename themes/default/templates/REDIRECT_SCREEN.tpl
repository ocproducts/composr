{TITLE}

{$REQUIRE_CSS,messages}

<div class="site_special_message">
	<div class="site_special_message_inner">
		<div class="box box___redirect_screen"><div class="box_inner">
			<p>{TEXT}</p>
			{+START,IF_PASSED_AND_TRUE,REDIRECT_TEXT_NO_COMPLETE}
				<p>{!REDIRECT_TEXT_NO_COMPLETE,{URL*}}</p>
			{+END}

			{+START,IF_NON_PASSED_OR_FALSE,REDIRECT_TEXT_NO_COMPLETE}
				<p>{!REDIRECT_TEXT,{URL*}}</p>
			{+END}
		</div></div>
	</div>
</div>

