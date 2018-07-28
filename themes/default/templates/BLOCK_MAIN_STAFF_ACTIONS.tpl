{+START,IF,{$NEQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	<section id="tray_actionlog" class="box box___block_main_staff_actions">
		<h3 class="toggleable_tray_title">
			<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode,false,'actionlog');"><img alt="{!CONTRACT}: {$STRIP_TAGS,{!MODULE_TRANS_NAME_admin_actionlog}}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract2}" srcset="{$IMG*,2x/trays/contract2} 2x" /></a>

			<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode,false,'actionlog');">{!MODULE_TRANS_NAME_admin_actionlog}</a>
		</h3>

		<div class="toggleable_tray">
{+END}

			{$SET,ajax_block_main_staff_actions_wrapper,ajax_block_main_staff_actions_wrapper_{$RAND%}}
			<div id="{$GET*,ajax_block_main_staff_actions_wrapper}">
				<form class="action_log_filters" action="{$URL_FOR_GET_FORM*,{$SELF_URL}}#tray_actionlog" method="get" target="_self">
					{$HIDDENS_FOR_GET_FORM,{$SELF_URL,0,0,0,filter_by_member=<null>,include_duplicates=<null>,include_user_activities=<null>}}

					<div class="action_log_filter_part">
						<label for="filter_by_member">{!SHOW_ACTIONS_FOR}</label>:
						<select onchange="/*guarded*/if (!this.form.onsubmit || this.form.onsubmit()) this.form.submit();" name="filter_by_member" id="filter_by_member">
							<option value="0"{+START,IF,{$NOT,{FILTER_BY_MEMBER}}} selected="selected"{+END}>All users</option>
							<option value="1"{+START,IF,{FILTER_BY_MEMBER}} selected="selected"{+END}>Me only</option>
						</select>
					</div>

					<div class="action_log_filter_part">
						<label for="include_duplicates">{!INCLUDE_DUPLICATES}</label>:
						<input onchange="/*guarded*/if (!this.form.onsubmit || this.form.onsubmit()) this.form.submit();" type="checkbox" name="include_duplicates" id="include_duplicates" value="1"{+START,IF,{INCLUDE_DUPLICATES}} checked="checked"{+END} />
					</div>

					<div class="action_log_filter_part">
						<label for="include_user_activities">{!INCLUDE_USER_ACTIVITIES}</label>:
						<input onchange="/*guarded*/if (!this.form.onsubmit || this.form.onsubmit()) this.form.submit();" type="checkbox" name="include_user_activities" id="include_user_activities" value="1"{+START,IF,{INCLUDE_USER_ACTIVITIES}} checked="checked"{+END} />
					</div>

					<input type="submit" class="accessibility_hidden button_micro buttons__filter" value="{!FILTER}" />
				</form>

				{CONTENT}

				{$REQUIRE_JAVASCRIPT,ajax}
				{$REQUIRE_JAVASCRIPT,checking}

				<script>// <![CDATA[
					add_event_listener_abstract(window,'load',function() {
						internalise_ajax_block_wrapper_links('{$FACILITATE_AJAX_BLOCK_CALL;,{BLOCK_PARAMS},raw=.*\,cache=.*}',document.getElementById('{$GET;,ajax_block_main_staff_actions_wrapper}'),['.*'],{ 'raw': 1,'cache': 0 },false,true);
					});
				//]]></script>
			</div>

{+START,IF,{$NEQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
		</div>
	</section>

	{+START,IF,{$JS_ON}}
		<script>// <![CDATA[
			handle_tray_cookie_setting('actionlog');
		//]]></script>
	{+END}
{+END}
