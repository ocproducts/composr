{TITLE}

<p>{!SUPPORT_SEARCH_FAQ}</p>

{RESULTS}

<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<input type="hidden" name="faq_searched" value="1" />

	{POST_FIELDS}

	<p class="proceed_button">
		<input data-disable-after-click="1" class="button_screen buttons__send" type="submit" value="{!MAKE_POST}" />
	</p>
</form>
