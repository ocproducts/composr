{$SET,rand_donextitem,{$RAND}}

<div id="donext_item_{$GET,rand_donextitem}" class="do_next_item" style="width: {$DIV*,100,{$MIN,5,{NUM_SIBLINGS}}}%" onclick="var as=this.getElementsByTagName('a'); var a=as[as.length-1]; click_link(a);" onkeypress="if (enter_pressed(event)) this.onclick(event);" onmouseout="if (typeof window.doc_onmouseout!='undefined') doc_onmouseout();" onmouseover="if (typeof window.doc_onmouseover!='undefined') doc_onmouseover('{$GET,rand_donextitem}');">
	{+START,IF_NON_EMPTY,{DOC}}<div id="doc_{$GET,rand_donextitem}" style="display: none">{DOC}</div>{+END}

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

	{+START,IF_PASSED,AUTO_ADD}
		<script>// <![CDATA[
			add_event_listener_abstract(window,'load',function() {
				var as=document.getElementById('donext_item_{$GET,rand_donextitem}').getElementsByTagName('a');
				for (var i=0;i<as.length;i++)
				{
					as[i].onclick=function(_this) {
						return function(event) {
							if (typeof event.preventDefault!='undefined') event.preventDefault();
							cancel_bubbling(event);
							window.fauxmodal_confirm(
								'{!KEEP_ADDING_QUESTION;}',
								function(test)
								{
									if (test)
									{
										_this.href+=(_this.href.indexOf('?')!=-1)?'&':'?';
										_this.href+='{AUTO_ADD;/}=1';
									}
									click_link(_this);
								}
							);
							return false;
						};
					} (as[i]);
				}
			});
		//]]></script>
	{+END}
</div>
