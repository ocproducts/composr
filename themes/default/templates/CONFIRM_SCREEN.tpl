{$REQUIRE_JAVASCRIPT,core_abstract_interfaces}

<div data-require-javascript="core_abstract_interfaces" data-tpl="confirmScreen" data-tpl-params="{+START,PARAMS_JSON,JAVASCRIPT}{_*}{+END}">
	{TITLE}

	{+START,IF_NON_PASSED,TEXT}
		<p>
			{!CONFIRM_TEXT}
		</p>

		{+START,IF,{$IN_STR,{PREVIEW},class="box"}}
			<div class="box box___confirm_screen"><div class="box_inner">
				{PREVIEW}
			</div></div>
		{+END}

		{+START,IF,{$NOT,{$IN_STR,{PREVIEW},class="box"}}}
			{PREVIEW}
		{+END}
	{+END}

	{+START,IF_PASSED,TEXT}
		{TEXT}
	{+END}

	<form title="{!PRIMARY_PAGE_FORM}"{+START,IF_NON_PASSED_OR_FALSE,GET} method="post" action="{URL*}"{+END}{+START,IF_PASSED_AND_TRUE,GET} method="get" action="{$URL_FOR_GET_FORM*,{URL}}"{+END} autocomplete="off">
		{+START,IF_NON_PASSED_OR_FALSE,GET}{$INSERT_SPAMMER_BLACKHOLE}{+END}

		{+START,IF_PASSED_AND_TRUE,GET}{$HIDDENS_FOR_GET_FORM,{URL}}{+END}

		{+START,IF_PASSED,HIDDEN}{HIDDEN}{+END}

		<div>
			{FIELDS}

			<p class="proceed_button">
				{+START,IF_NON_PASSED,BACK_URL}
					<input class="button_screen buttons__back" type="button" data-cms-btn-go-back="1" value="{!GO_BACK}" />
				{+END}

				<input data-disable-on-click="1" accesskey="u" class="button_screen buttons__proceed" type="submit" value="{!PROCEED}" />
			</p>
		</div>
	</form>

	{+START,IF_PASSED,BACK_URL}
		<form class="back_button" title="{!NEXT_ITEM_BACK}" action="{BACK_URL*}" method="post" autocomplete="off">
			<div>
				{FIELDS}
				<button class="button_icon" type="submit"><img title="{!NEXT_ITEM_BACK}" alt="{!NEXT_ITEM_BACK}" src="{$IMG*,icons/48x48/menu/_generic_admin/back}" /></button>
			</div>
		</form>
	{+END}
</div>
