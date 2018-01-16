<div class="box index-screen-fancier-entry"><div class="box-inner">
	{+START,IF_PASSED,IMG}
		{+START,IF_NON_EMPTY,{URL}}<a {+START,IF_PASSED,TARGET} target="{TARGET*}"{+END} href="{URL*}"{+START,IF_NON_EMPTY,{TITLE}} title="{TITLE*}"{+END}>{+END}<img class="right float-separation" alt="" src="{$ENSURE_PROTOCOL_SUITABILITY*,{IMG}}" />{+START,IF_NON_EMPTY,{URL}}</a>{+END}
	{+END}

	<div class="index-screen-fancier-entry-link">{+START,IF_NON_EMPTY,{URL}}<a {+START,IF_PASSED,TARGET} target="{TARGET*}"{+END} href="{URL*}" title="{$STRIP_TAGS,{NAME*}}{+START,IF_NON_EMPTY,{TITLE}}: {$STRIP_TAGS,{TITLE*}}{+END}">{+END}{NAME*}{+START,IF_NON_EMPTY,{URL}}</a>{+END}{+START,IF_PASSED,COUNT} <span class="index-screen-fancier-entry-count">({COUNT*})</span>{+END}</div>

	{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<div class="index-screen-fancier-entry-description">
			{DESCRIPTION}
		</div>
	{+END}

	{+START,IF_PASSED,SUP}
		<div class="index-screen-fancier-entry-sup">
			{SUP}
		</div>
	{+END}
</div></div>
