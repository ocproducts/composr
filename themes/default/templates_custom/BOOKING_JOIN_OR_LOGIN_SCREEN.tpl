{TITLE}

{+START,IF,{$CONFIG_OPTION,member_booking_only}}
	<p>
		{!ALREADY_MEMBER_LOGIN,{$PAGE_LINK*,:login:redirect={$SELF_URL&}},{HIDDEN}}
	</p>

	<hr />

	<p>
		{!ENTER_PROFILE_DETAILS}
	</p>
{+END}

{FORM}

{+START,IF_PASSED,JAVASCRIPT}
	<script>// <![CDATA[
		{JAVASCRIPT/}
	//]]></script>
{+END}
