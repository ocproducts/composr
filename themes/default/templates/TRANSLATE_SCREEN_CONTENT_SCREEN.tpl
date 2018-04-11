{TITLE}

{!TRANSLATE_CONTENT_SCREEN,{LANG_NICE_NAME*}}

{+START,IF_NON_EMPTY,{GOOGLE}}
	<p>
		{!POWERED_BY,<a rel="external" title="Google {!LINK_NEW_WINDOW}" target="_blank" href="http://translate.google.com/">Google</a>}.
	</p>
{+END}

<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div class="wide-table-wrap really-long-table-wrap"><table class="columned-table results-table wide-table autosized-table responsive-table">
		<thead>
			<tr>
				<th>
					{!CODENAME}
				</th>
				<th>
					{!ORIGINAL}{+START,IF,{$NEQ,{LANG_ORIGINAL_NAME},{LANG}}} ({LANG_NICE_ORIGINAL_NAME*}?){+END}
					&rarr;
					{LANG_NICE_NAME*}
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
		<button accesskey="u" data-disable-on-click="1" class="button-screen buttons--save" type="submit">{!SAVE}</button>
	</p>

	{+START,IF,{TOO_MANY}}
		<p class="more-here">{!TRANSLATE_TOO_MANY,{TOTAL*},{MAX*}}</p>
	{+END}
</form>

{PAGINATION}
