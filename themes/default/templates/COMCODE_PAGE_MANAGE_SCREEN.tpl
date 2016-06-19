{TITLE}

{$PARAGRAPH,{TEXT}}

<form title="{!PRIMARY_PAGE_FORM}"{+START,IF_NON_PASSED_OR_FALSE,GET} method="post"{+END}{+START,IF_PASSED_AND_TRUE,GET} method="get"{+END} action="{POST_URL*}" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	{TABLE}

	{+START,IF_PASSED,HIDDEN}
		<div>
			{HIDDEN}
		</div>
	{+END}
</form>

{+START,IF_PASSED,EXTRA}
	{+START,IF_PASSED,SUB_TITLE}<h2 class="force_margin">{SUB_TITLE*}</h2>{+END}

	{EXTRA}
{+END}

{+START,IF_NON_EMPTY,{LINKS}}
	<h2>{!ADVANCED}</h2>

	<ul class="actions_list">
		{+START,LOOP,LINKS}
			<li style="background-image: url('{LINK_IMAGE;*}'); background-size: 18px 18px; background-position: 0 0; padding-left: 20px"><a href="{LINK_URL*}">{LINK_TEXT*}</a></li>
		{+END}
	</ul>
{+END}
