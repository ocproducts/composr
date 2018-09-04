{TITLE}

{$REQUIRE_CSS,messages}

<div class="site-special-message">
	<div class="site-special-message-inner">
		<div class="box box---redirect-screen"><div class="box-inner">
			<p>{TEXT*}</p>

			{+START,IF_PASSED_AND_TRUE,REDIRECT_TEXT_NO_COMPLETE}
				<p>{!REDIRECT_TEXT_NO_COMPLETE,{URL*}}</p>
			{+END}

			{+START,IF_NON_PASSED_OR_FALSE,REDIRECT_TEXT_NO_COMPLETE}
				<p>{!REDIRECT_TEXT,{URL*}}</p>
			{+END}
		</div></div>
	</div>
</div>
