<section id="tray_{!VERSION_ABOUT|,{VERSION}}" class="box box___block_main_staff_new_version">
	<h3 class="toggleable_tray_title">
		<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode,false,'{!VERSION_ABOUT|,{VERSION}}');"><img alt="{!CONTRACT}: {$STRIP_TAGS,{!VERSION_ABOUT,{VERSION*}}}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract2}" srcset="{$IMG*,2x/trays/contract2} 2x" /></a>

		<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode,false,'{!VERSION_ABOUT|,{VERSION}}');">{!VERSION_ABOUT,{VERSION*}}</a>
	</h3>

	<div class="toggleable_tray">
		<div class="staff_new_versions">
			{VERSION_TABLE}

			{+START,IF,{HAS_UPDATED_ADDONS}}
				<p class="red_alert">
					{!addons:SOME_ADDONS_UPDATED,{$PAGE_LINK*,_SEARCH:admin_addons}}
				</p>
			{+END}

			<div class="img_wrap">
				<img src="{$IMG*,product_logo}" alt="" />
			</div>
		</div>
	</div>
</section>

{+START,IF,{$JS_ON}}
	<script>// <![CDATA[
		handle_tray_cookie_setting('{!VERSION_ABOUT|,{VERSION}}');
	//]]></script>
{+END}
