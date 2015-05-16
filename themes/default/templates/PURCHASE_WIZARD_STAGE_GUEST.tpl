<p>
	{TEXT}
</p>

{!ALREADY_MEMBER_LOGIN,{$PAGE_LINK*,:login:redirect={$SELF_URL&}},{HIDDEN}}

<hr />

<p>
	{!ENTER_PROFILE_DETAILS}
</p>

{FORM}

{+START,IF_PASSED,JAVASCRIPT}
	<script>// <![CDATA[
		{JAVASCRIPT/}
	//]]></script>
{+END}
