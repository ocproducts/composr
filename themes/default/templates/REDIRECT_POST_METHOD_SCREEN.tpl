{TITLE}

{$REQUIRE_CSS,messages}

<div class="site-special-message">
	<div class="site-special-message-inner">
		<form title="{!PROCEED}" action="{URL*}" id="redir_form" method="post" autocomplete="off">
			{$INSERT_SPAMMER_BLACKHOLE}

			<div class="box box___login_redirect_screen"><div class="box-inner">
				{TEXT}

				<p>
					{!PROCEED_TEXT,<input accesskey="c" class="button-hyperlink" type="submit" value="{!HERE}" />}
				</p>

				{POST}
			</div></div>
		</form>
	</div>
</div>

{REFRESH}
