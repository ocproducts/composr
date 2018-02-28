{$REQUIRE_JAVASCRIPT,checking}

{$SET,ajax_block_main_staff_tips_wrapper,ajax-block-main-staff-tips-wrapper-{$RAND%}}
{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL,{BLOCK_PARAMS}}}
<div id="{$GET*,ajax_block_main_staff_tips_wrapper}" class="box-wrapper" data-tpl="blockMainStaffTips" data-tpl-params="{+START,PARAMS_JSON,ajax_block_main_staff_tips_wrapper,block_call_url}{_*}{+END}">
	<section id="tray-{!TIPS|}" class="box box---block-main-staff-tips" data-toggleable-tray="{ save: true }">
		<h3 class="toggleable-tray-title js-tray-header">
			<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!CONTRACT}: {$STRIP_TAGS,{!TIPS}}" title="{!CONTRACT}" width="24" height="24" src="{$IMG*,icons/trays/contract}" /></a>
			<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{!TIPS}</a>
		</h3>

		<div class="toggleable-tray js-tray-content">
			<p>
				{TIP}
			</p>

			<div class="tips-trail">
				{+START,IF_NON_EMPTY,{TIP_CODE}}
					<ul class="horizontal-links associated-links-block-group">
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
