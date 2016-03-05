{$SET,wrapper_id,ajax_block_wrapper_{$RAND%}}
<div id="{$GET*,wrapper_id}" class="box_wrapper">
	<section id="tray_{!TIPS|}" class="box box___block_main_staff_tips">
		<h3 class="toggleable_tray_title">
			<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode,false,'{!TIPS|}');"><img alt="{!CONTRACT}: {$STRIP_TAGS,{!TIPS}}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract2}" srcset="{$IMG*,2x/trays/contract2} 2x" /></a>

			<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode,false,'{!TIPS|}');">{!TIPS}</a>
		</h3>

		<div class="toggleable_tray">
			<p>
				{TIP}
			</p>

			<div class="tips_trail">
				{+START,IF_NON_EMPTY,{TIP_CODE}}
					<ul class="horizontal_links associated_links_block_group">
						<li><a target="_self" href="{$PAGE_LINK*,adminzone:start:staff_tips_dismiss={TIP_CODE}}">{!DISMISS_TIP}</a></li>
						{+START,IF,{$NEQ,{TIP_CODE},0a}}
							<li><a target="_self" accesskey="k" href="{$PAGE_LINK*,adminzone:start:rand={$RAND}}">{!ANOTHER_TIP}</a></li>
						{+END}
					</ul>
				{+END}
			</div>
		</div>
	</section>

	{+START,IF,{$JS_ON}}
		<script>// <![CDATA[
			handle_tray_cookie_setting('{!TIPS|}');
		//]]></script>
	{+END}

	{$REQUIRE_JAVASCRIPT,ajax}
	{$REQUIRE_JAVASCRIPT,checking}

	<script>// <![CDATA[
		add_event_listener_abstract(window,'load',function() {
			internalise_ajax_block_wrapper_links('{$FACILITATE_AJAX_BLOCK_CALL;,{BLOCK_PARAMS}}',document.getElementById('{$GET;,wrapper_id}'),['staff_tips_dismiss','rand'/*cache breaker*/],{ },false,true,false);
		});
	//]]></script>
</div>
