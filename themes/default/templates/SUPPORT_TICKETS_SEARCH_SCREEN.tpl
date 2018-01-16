{TITLE}

<p>{!SUPPORT_SEARCH_FAQ}</p>

{RESULTS}

<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<input type="hidden" name="faq_searched" value="1" />

	{POST_FIELDS}

	<p class="proceed-button">
		<input data-disable-on-click="1" class="button-screen buttons--send" type="submit" value="{!MAKE_POST}" />
	</p>
</form>
