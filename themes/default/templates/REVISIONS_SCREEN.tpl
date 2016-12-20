{TITLE}

{+START,IF,{INCLUDE_FILTER_FORM}}
	<p>
		{!ABOUT_REVISIONS}
	</p>

	<div class="box_revisions_screen box"><div class="box_inner">
		<form title="{!PRIMARY_PAGE_FORM}" action="{$URL_FOR_GET_FORM*,{$SELF_URL,0,1}}" method="get" autocomplete="off">
			{$HIDDENS_FOR_GET_FORM,{$SELF_URL,0,0,0,resource_types=<null>,resource_id=<null>,category_id=<null>,username=<null>}}

			{$REQUIRE_CSS,widget_select2}
			{$REQUIRE_JAVASCRIPT,jquery}
			{$REQUIRE_JAVASCRIPT,select2}
			<div class="revisions_filter_item">
				<label class="lonely_label" for="resource_types">{!TYPE}:</label>
				<select multiple="multiple" name="resource_types" id="resource_types">
					{+START,LOOP,RESOURCE_TYPES}
						<option value="{_loop_key*}"{+START,IF_IN_ARRAY,{_loop_key},{$_GET*,resource_types}} selected="selected"{+END}>{_loop_var*}</option>
					{+END}
				</select>
			</div>
			<script>// <![CDATA[
				add_event_listener_abstract(window,'load',function() {
					if (typeof $("#resource_types").select2!='undefined') {
						$("#resource_types").select2({
							dropdownAutoWidth: true
						});
					}
				});
			//]]></script>

			{$REQUIRE_JAVASCRIPT,ajax_people_lists}
			<div class="revisions_filter_item">
				<label class="lonely_label" for="username">{!USERNAME}:</label>
				<input onfocus="if (this.value=='') update_ajax_member_list(this,null,true,event);" onkeyup="update_ajax_member_list(this,null,false,event);" type="text" name="username" id="username" value="{$_GET*,username}" />
			</div>

			<div class="revisions_filter_item">
				<label class="lonely_label" for="resource_id">{!IDENTIFIER} <span class="associated_details">({!ADVANCED})</span>:</label>
				<input type="text" name="resource_id" id="resource_id" value="{$_GET*,resource_id}" />
			</div>

			<div class="revisions_filter_item">
				<label class="lonely_label" for="category_id">{!CATEGORY} <span class="associated_details">({!ADVANCED})</span>:</label>
				<input type="text" name="category_id" id="category_id" value="{$_GET*,category_id}" />
			</div>

			<div class="revisions_filter_item_button">
				<input onclick="disable_button_just_clicked(this);" accesskey="u" class="button_screen_item buttons__filter" type="submit" value="{!FILTER}" />
			</div>
		</form>
	</div></div>
{+END}

{RESULTS}
