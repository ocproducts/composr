<li>
	{+START,IF_PASSED,URL}
		{!WEBSTANDARDS_ERROR_AT,{ERROR},<a href="{URL*}#errorloc-{I*}">{LINE}</a>,{POS}}
	{+END}
	{+START,IF_NON_PASSED,URL}
		{!WEBSTANDARDS_ERROR_AT,{ERROR},<a href="#errorloc-{I*}">{LINE}</a>,{POS}}
	{+END}
</li>
