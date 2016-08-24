{$SET,rand_do_next_item,{$RAND}}

<div id="do_next_item_{$GET,rand_do_next_item}" class="do_next_item" style="width: {$DIV*,100,{$MIN,5,{NUM_SIBLINGS}}}%"
	 data-tpl-core-abstract-interfaces="doNextItem" data-tpl-args="{+START,PARAMS_JSON,AUTO_ADD,rand_do_next_item}{_*}{+END}"
	 onclick="var as=this.getElementsByTagName('a'); var a=as[as.length-1]; click_link(a);"
	 onkeypress="if (enter_pressed(event)) this.onclick(event);"
	 onmouseout="if (typeof window.doc_onmouseout!='undefined') doc_onmouseout();"
	 onmouseover="if (typeof window.doc_onmouseover!='undefined') doc_onmouseover('{$GET,rand_do_next_item}');">

	{+START,IF_NON_EMPTY,{DOC}}<div id="doc_{$GET,rand_do_next_item}" style="display: none">{DOC}</div>{+END}

	<div>
		<div>
			<div>
				<div>
					{+START,IF_EMPTY,{WARNING}}
						<a{+START,IF_PASSED,TARGET} target="{TARGET*}"{+END} onclick="cancel_bubbling(event);" href="{URL*}"><img alt="{$STRIP_TAGS*,{DESCRIPTION}}" src="{$IMG*,icons/48x48/{PICTURE*}}" /></a>
					{+END}
					{+START,IF_NON_EMPTY,{WARNING}}
						<a{+START,IF_PASSED,TARGET} target="{TARGET*}"{+END} onclick="cancel_bubbling(event); var t=this; window.fauxmodal_confirm('{WARNING;*}',function(answer) { if (answer) click_link(t); }); return false;" href="{URL*}"><img alt="{$STRIP_TAGS*,{DESCRIPTION}}" src="{$IMG*,icons/48x48/{PICTURE*}}" /></a>
					{+END}
				</div>

				<div>
					<a{+START,IF_PASSED,TARGET} target="{TARGET*}"{+END} onclick="cancel_bubbling(event);" href="{URL*}">{DESCRIPTION*}</a>
				</div>
			</div>
		</div>
	</div>
</div>

