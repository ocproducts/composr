{TITLE}

{+START,IF_NON_EMPTY,{TRACKBACKS}}
	{+START,IF,{LOTS}}
		<p><em>{!ONLY_1000_SHOWN}</em></p>
	{+END}

	<form title="{!PRIMARY_PAGE_FORM}" action="{$PAGE_LINK*,_SEARCH:admin_trackbacks:delete}" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		{TRACKBACKS}

		<p class="proceed-button">
			<input data-disable-on-click="1" class="button-screen menu---generic-admin--delete" type="submit" value="{!DELETE}" />
		</p>
	</form>
{+END}
{+START,IF_EMPTY,{TRACKBACKS}}
	<p class="nothing-here">{!NO_ENTRIES}</p>
{+END}
