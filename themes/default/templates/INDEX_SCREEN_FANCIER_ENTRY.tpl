<div class="box index_screen_fancier_entry"><div class="box_inner">
	{+START,IF_PASSED,IMG}
		{+START,IF_NON_EMPTY,{URL}}<a{+START,IF_PASSED,TARGET} target="{TARGET*}"{+END} href="{URL*}"{+START,IF_NON_EMPTY,{TITLE}} title="{TITLE*}"{+END}>{+END}<img class="right float_separation" alt="" src="{$ENSURE_PROTOCOL_SUITABILITY*,{IMG}}" />{+START,IF_NON_EMPTY,{URL}}</a>{+END}
	{+END}

	<div class="index_screen_fancier_entry_link">{+START,IF_NON_EMPTY,{URL}}<a{+START,IF_PASSED,TARGET} target="{TARGET*}"{+END} href="{URL*}" title="{$STRIP_TAGS,{NAME*}}{+START,IF_NON_EMPTY,{TITLE}}: {$STRIP_TAGS,{TITLE*}}{+END}">{+END}{NAME*}{+START,IF_NON_EMPTY,{URL}}</a>{+END}{+START,IF_PASSED,COUNT} <span class="index_screen_fancier_entry_count">({COUNT*})</span>{+END}</div>

	{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<div class="index_screen_fancier_entry_description">
			{DESCRIPTION}
		</div>
	{+END}

	{+START,IF_PASSED,SUP}
		<div class="index_screen_fancier_entry_sup">
			{SUP}
		</div>
	{+END}
</div></div>
