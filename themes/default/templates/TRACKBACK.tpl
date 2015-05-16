<div class="box box___trackback"><div class="box_inner">
	<h4>{TITLE*} &ndash; {TIME*} <a class="associated_link horiz_field_sep" href="{URL*}">{NAME*}</a></h4>

	{+START,IF_NON_EMPTY,{EXCERPT}}
		<p>{EXCERPT}</p>
	{+END}

	{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,_SEARCH:admin_trackbacks}}
		<fieldset class="innocuous_fieldset">
			<legend class="accessibility_hidden">{!ACTION}</legend>

			<label for="trackback_{ID*}_0"><input checked="checked" type="radio" id="trackback_{ID*}_0" name="trackback_{ID*}" value="0" /> {!LEAVE_TRACKBACK}</label>
			<label for="trackback_{ID*}_1"><input type="radio" id="trackback_{ID*}_1" name="trackback_{ID*}" value="1" /> {!DELETE_TRACKBACK}</label>
			{+START,IF,{$ADDON_INSTALLED,securitylogging}}
				<label for="trackback_{ID*}_2"><input type="radio" id="trackback_{ID*}_2" name="trackback_{ID*}" value="2" /> {!DELETE_BAN_TRACKBACK}</label>
			{+END}
		</fieldset>
	{+END}
</div></div>
