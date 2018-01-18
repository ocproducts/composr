{$REQUIRE_JAVASCRIPT,core_language_editing}

<div data-tpl="translateScreen">
	{TITLE}

	{+START,IF,{$NEQ,{LANG},EN}}
		<p>
			{!TRANSLATION_GUIDE,https://www.transifex.com/organization/ocproducts/dashboard/composr-cms-{$VERSION_NUMBER*,1},{LANG},{$TUTORIAL_URL,tut_intl}}
		</p>
	{+END}

	{+START,IF_NON_EMPTY,{GOOGLE}}
		<p>
			{!POWERED_BY,<a rel="external" title="Google {!LINK_NEW_WINDOW}" target="_blank" href="http://translate.google.com/">Google</a>}.
		</p>
	{+END}

	<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off" data-submit-pd="1" class="js-form-submit-modsecurity-workaround">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div class="wide-table-wrap really-long-table-wrap"><table class="autosized-table columned-table results-table wide-table responsive-table">
			<thead>
				<tr>
					<th class="translate-line-first">
						{!NAME}/{!DESCRIPTION}
					</th>
					<th>
						{!OLD}/{!NEW}
					</th>
					{+START,IF_NON_EMPTY,{GOOGLE}}
						<th>
							{!ACTIONS}
						</th>
					{+END}
				</tr>
			</thead>
			<tbody>
				{LINES}
			</tbody>
		</table></div>

		<p class="proceed-button">
			<input accesskey="u" data-disable-on-click="1" class="button-screen buttons--save" type="submit" value="{!SAVE}" />
		</p>
	</form>

	<form title="" id="hack_form" action="http://translate.google.com/translate_t" method="post" autocomplete="off">
		<div>
			<input type="hidden" id="hack_input" name="text" value="" />
			<input type="hidden" name="langpair" value="en|{GOOGLE*}" />
		</div>
	</form>
</div>
