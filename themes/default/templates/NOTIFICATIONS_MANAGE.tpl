<p>
	{$?,{$MATCH_KEY_MATCH,_SEARCH:admin_notifications},{!NOTIFICATIONS_DEFINE_LOCKDOWN},{!NOTIFICATIONS_INTRO}}
</p>

<div class="wide_table_wrap"><table class="columned_table wide_table results_table notifications_form">
	<colgroup>
		<col class="notifications_field_name_column" />
		{+START,IF_PASSED_AND_TRUE,SHOW_PRIVILEGES}
			<col class="notifications_privileges_column" />
		{+END}
		{+START,LOOP,NOTIFICATION_TYPES_TITLES}
			<col class="notifications_tick_column" />
		{+END}
		<col class="notifications_advanced_column" />
	</colgroup>

	<thead>
		<tr>
			<th></th>
			{+START,IF_PASSED_AND_TRUE,SHOW_PRIVILEGES}
				<th>
					{$SET,url,{$BASE_URL}/data/gd_text.php?trans_color={COLOR}&text={$ESCAPE,{!NOTIFICATION_PRIVILEGED},UL_ESCAPED}{$KEEP}}
					<img class="gd_text" src="{$GET*,url}" title="{!NOTIFICATION_PRIVILEGED}" alt="{!NOTIFICATION_PRIVILEGED}" />
				</th>
			{+END}
			{+START,LOOP,NOTIFICATION_TYPES_TITLES}
				<th>
					{$SET,url,{$BASE_URL}/data/gd_text.php?trans_color={COLOR}&text={$ESCAPE,{LABEL},UL_ESCAPED}{$KEEP}}
					<img class="gd_text" src="{$GET*,url}" title="" alt="{LABEL*}" />
				</th>
			{+END}
			<th></th>
		</tr>
	</thead>

	<tbody>
		{+START,LOOP,NOTIFICATION_SECTIONS}
			<tr class="form_table_field_spacer">
				<th class="table_heading_cell" colspan="{+START,IF_PASSED_AND_TRUE,SHOW_PRIVILEGES}{$ADD*,{NOTIFICATION_TYPES_TITLES},3}{+END}{+START,IF_NON_PASSED_OR_FALSE,SHOW_PRIVILEGES}{$ADD*,{NOTIFICATION_TYPES_TITLES},2}{+END}">
					<span class="faux_h2">{NOTIFICATION_SECTION*}</span>
				</th>
			</tr>

			{+START,LOOP,NOTIFICATION_CODES}
				<tr class="notification_code {$CYCLE*,zebra,zebra_0,zebra_1}">
					<th class="de_th">{NOTIFICATION_LABEL*}</th>

					{+START,IF_PASSED,PRIVILEGED}
						<td>{$?,{PRIVILEGED},{!YES},{!NO}}</td>
					{+END}

					{+START,INCLUDE,NOTIFICATION_TYPES}{+END}

					<td class="associated_details">
						{+START,IF,{SUPPORTS_CATEGORIES}}
							<span class="associated_link"><a onclick="return open_link_as_overlay(this,null,null,'_self');" href="{$PAGE_LINK*,_SEARCH:notifications:advanced:notification_code={NOTIFICATION_CODE}{$?,{$NEQ,{MEMBER_ID},{$MEMBER}},:keep_su={$USERNAME&,{MEMBER_ID}}}}">{$?,{$MOBILE},{!MORE},{!ADVANCED}}</a></span>
						{+END}
					</td>
				</tr>
			{+END}
		{+END}
	</tbody>
</table></div>

{+START,IF_PASSED,AUTO_NOTIFICATION_CONTRIB_CONTENT}
	<h2>{!cns:AUTO_NOTIFICATION_CONTRIB_CONTENT}</h2>

	<p class="simple_neat_checkbox">
		<input{+START,IF,{AUTO_NOTIFICATION_CONTRIB_CONTENT}} checked="checked"{+END} type="checkbox" id="auto_monitor_contrib_content" name="auto_monitor_contrib_content" value="1" />
		<label for="auto_monitor_contrib_content"><span>{!cns:DESCRIPTION_AUTO_NOTIFICATION_CONTRIB_CONTENT}</span></label>
	</p>
{+END}

{+START,IF_PASSED,SMART_TOPIC_NOTIFICATION_CONTENT}
	<h2>{!cns:SMART_TOPIC_NOTIFICATION}</h2>

	<p class="simple_neat_checkbox">
		<input{+START,IF,{SMART_TOPIC_NOTIFICATION_CONTENT}} checked="checked"{+END} type="checkbox" id="smart_topic_notification_content" name="smart_topic_notification_content" value="1" />
		<label for="smart_topic_notification_content"><span>{!cns:DESCRIPTION_SMART_TOPIC_NOTIFICATION}</span></label>
	</p>
{+END}
