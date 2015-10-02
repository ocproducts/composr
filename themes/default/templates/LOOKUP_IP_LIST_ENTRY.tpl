{$SET,rndx,{$RAND}}

<li>
	<label for="banned_{$GET*,rndx}"><a href="{LOOKUP_URL*}">{IP*}</a> <span class="associated_details">({DATE*})</span>
	{+START,IF,{$ADDON_INSTALLED,securitylogging}}
		<span class="horiz_field_sep"><em>{!BANNED}: <input type="checkbox" id="banned_{$GET*,rndx}" name="banned[]" value="{IP*}"{+START,IF,{BANNED}} checked="checked"{+END} /></em></span>
	{+END}
	</label>
</li>
