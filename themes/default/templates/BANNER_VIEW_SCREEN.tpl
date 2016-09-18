{TITLE}

<h2>{!DETAILS}</h2>

{MAP_TABLE}

<h2>{!VIEW}</h2>

<p>
	{!BANNER_LOOKS}
</p>

{$PARAGRAPH,{BANNER}}

{+START,IF_NON_EMPTY,{RESULTS_TABLE}}
	<h2>{!_STATISTICS}</h2>

	{RESULTS_TABLE}
{+END}

{+START,IF_NON_EMPTY,{RESET_URL}}
	<form title="{!RESET_BANNER_STATS}" action="{RESET_URL*}" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<input type="hidden" name="confirm" value="1" />
		<input class="button_screen menu___generic_admin__delete" type="submit" value="{!RESET_BANNER_STATS}" onclick="var _form=this.form; fauxmodal_confirm('{!WARNING_RESET_BANNER_STATS;}',function(result) { if (result) _form.submit(); }); return false;" />
	</form>
{+END}

{$REVIEW_STATUS,banner,{NAME}}

{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
{+START,INCLUDE,STAFF_ACTIONS}
	1_URL={EDIT_URL*}
	1_TITLE={!EDIT}
	1_ACCESSKEY=q
	1_REL=edit
	1_ICON=menu/_generic_admin/edit_this
{+END}
