<div class="box"><div class="box-inner">
	<div class="global-message" role="alert">
		{+START,INCLUDE,ICON}
			NAME=status/notice
			SIZE=24
		{+END}
		{!EVENT_CONFLICT_DETECTED,<a href="{URL*}" title="{TITLE*}: #{ID*}">{TITLE*}</a>}
	</div>
</div></div>
