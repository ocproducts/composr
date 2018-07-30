{+START,IF,{$IS_GUEST}}
	{$GENERATE_CAPTCHA}

	<input type="hidden" name="_security" value="1" />

	{+START,INCLUDE,COMMENTS_POSTING_FORM_CAPTCHA}{+END}
{+END}
