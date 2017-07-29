{$SET,rand_do_next_item,{$RAND}}

<div id="do_next_item_{$GET,rand_do_next_item}" class="do_next_item" style="width: {$DIV*,100,{$MIN,5,{NUM_SIBLINGS}}}%" data-tpl="doNextItem" data-tpl-params="{+START,PARAMS_JSON,URL,TARGET,WARNING,AUTO_ADD,rand_do_next_item}{_*}{+END}">

	{+START,IF_NON_EMPTY,{DOC}}<div id="doc_{$GET,rand_do_next_item}" style="display: none">{DOC}</div>{+END}

	<div class="do_next_item_icon">
		<a href="{URL*}" class="js-click-confirm-warning"{+START,IF_PASSED,TARGET} target="{TARGET*}"{+END}><img alt="{$STRIP_TAGS*,{DESCRIPTION}}" src="{$IMG*,icons/48x48/{PICTURE*}}" /></a>
	</div>

	<div class="do_next_item_label">
		<a href="{URL*}"{+START,IF_PASSED,TARGET} target="{TARGET*}"{+END}>{DESCRIPTION*}</a>
	</div>
</div>
