{$REQUIRE_JAVASCRIPT,ajax}
{$REQUIRE_JAVASCRIPT,checking}

{$SET,wrapper_id,ajax_block_wrapper_{$RAND%}}
{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL,{BLOCK_PARAMS}}}
<div id="{$GET*,wrapper_id}" class="box_wrapper" data-tpl-core-adminzone-dashboard="blockMainStaffTips" data-tpl-args="{+START,PARAMS_JSON,wrapper_id,block_call_url}{_*}{+END}">
	<section id="tray_{!TIPS|}" class="box box___block_main_staff_tips"{+START,IF,{$JS_ON}} data-cms-call="handle_tray_cookie_setting"{+END}>
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
						<li><a target="_self" href="{$PAGE_LINK*,adminzone:staff_tips_dismiss={TIP_CODE}}">{!DISMISS_TIP}</a></li>
						{+START,IF,{$NEQ,{TIP_CODE},0a}}
							<li><a target="_self" accesskey="k" href="{$PAGE_LINK*,adminzone:rand={$RAND}}">{!ANOTHER_TIP}</a></li>
						{+END}
					</ul>
				{+END}
			</div>
		</div>
	</section>
</div>
