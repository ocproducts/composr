{TITLE}

{+START,INCLUDE,HANDLE_CONFLICT_RESOLUTION}{+END}
{+START,IF_PASSED,WARNING_DETAILS}
	{WARNING_DETAILS}
{+END}

<p>{CATEGORY_DESCRIPTION*}</p>

<h2>{!CONTENTS}</h2>

<ul>
	{+START,LOOP,_GROUPS}
		<li><a href="#group_{_loop_key*}">{_loop_var}</a></li>
	{+END}
</ul>

<h2>{!OPTION_GROUPS}</h2>

<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div>
		{GROUPS}
	</div>

	{+START,INCLUDE,FORM_STANDARD_END}{+END}
</form>

