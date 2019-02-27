{TITLE}

<p>
	{!SSL_PAGE_SELECT}
</p>

<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div class="clearfix">
		{+START,LOOP,ENTRIES}
			<div class="clearfix vertical-alignment">
				<label for="ssl_{ZONE*}__{PAGE*}">
					<input type="checkbox" value="1" id="ssl_{ZONE*}__{PAGE*}" name="ssl_{ZONE*}__{PAGE*}"{+START,IF,{TICKED}} checked="checked"{+END} />
					<kbd>{ZONE*}:{PAGE*}</kbd>
				</label>
			</div>
		{+END}
	</div>

	<p class="proceed-button">
		<button accesskey="u" data-disable-on-click="1" class="btn btn-primary btn-scr buttons--save" type="submit">{+START,INCLUDE,ICON}NAME=buttons/save{+END} {!SAVE}</button>
	</p>
</form>
