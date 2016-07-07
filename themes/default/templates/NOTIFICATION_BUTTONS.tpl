{+START,IF_PASSED,NOTIFICATIONS_TYPE}
	{$SET,NOTIFICATIONS_TYPE,{NOTIFICATIONS_TYPE}}
{+END}
{+START,IF_NON_PASSED,NOTIFICATIONS_TYPE}
	{$SET,NOTIFICATIONS_TYPE,{$PAGE}}
{+END}

{+START,IF_PASSED,NOTIFICATIONS_PAGE_LINK}
	{$SET,NOTIFICATIONS_PAGE_LINK,{NOTIFICATIONS_PAGE_LINK}}
{+END}
{+START,IF_NON_PASSED,NOTIFICATIONS_PAGE_LINK}
	{$SET,NOTIFICATIONS_PAGE_LINK,_SEARCH:notifications:advanced:{NOTIFICATIONS_ID}:notification_code={$GET,NOTIFICATIONS_TYPE}}
{+END}

{+START,IF_PASSED,BUTTON_TYPE}
	{$SET,button_type,{BUTTON_TYPE}}
{+END}
{+START,IF_NON_PASSED,BUTTON_TYPE}
	{$SET,button_type,button_screen}
{+END}

{+START,IF_PASSED,BUTTON_LABEL_ENABLE}
	{$SET,button_label_enable,{BUTTON_LABEL_ENABLE}}
{+END}
{+START,IF_NON_PASSED,BUTTON_LABEL_ENABLE}
	{$SET,button_label_enable,{!ENABLE_NOTIFICATIONS}}
{+END}

{+START,IF_PASSED,BUTTON_LABEL_DISABLE}
	{$SET,button_label_disable,{BUTTON_LABEL_DISABLE}}
{+END}
{+START,IF_NON_PASSED,BUTTON_LABEL_DISABLE}
	{$SET,button_label_disable,{!DISABLE_NOTIFICATIONS}}
{+END}

{+START,IF,{$NOT,{$IS_GUEST}}}{+START,IF,{$NOTIFICATIONS_AVAILABLE,{$GET,NOTIFICATIONS_TYPE}}}
	{+START,IF_PASSED_AND_TRUE,RIGHT}<div class="float_surrounder"><div class="right force_margin">{+END}

	{$INC,notification_id}
	<form id="nenable_{$GET*,notification_id}" title="{!notifications:NOTIFICATIONS}"{+START,IF,{$NOTIFICATIONS_ENABLED,{NOTIFICATIONS_ID},{$GET,NOTIFICATIONS_TYPE}}} style="display: none" aria-hidden="true"{+END} onsubmit="set_display_with_aria(this,'none'); set_display_with_aria(document.getElementById('ndisable_{$GET;*,notification_id}'),'inline'); return open_link_as_overlay(this);" class="inline" rel="enable-notifications" method="post" action="{$PAGE_LINK*,{$GET,NOTIFICATIONS_PAGE_LINK}:redirect={$SELF_URL&*,1,0,0,wide_high=<null>}}" autocomplete="off">{$INSERT_SPAMMER_BLACKHOLE,1}<input type="submit" class="buttons__enable_notifications {$GET*,button_type}" value="{$GET,button_label_enable}" /></form>
	<form id="ndisable_{$GET*,notification_id}" title="{!notifications:NOTIFICATIONS}"{+START,IF,{$NOT,{$NOTIFICATIONS_ENABLED,{NOTIFICATIONS_ID},{$GET,NOTIFICATIONS_TYPE}}}} style="display: none" aria-hidden="true"{+END} onsubmit="set_display_with_aria(this,'none'); set_display_with_aria(document.getElementById('nenable_{$GET;*,notification_id}'),'inline'); return open_link_as_overlay(this);" class="inline" rel="disable-notifications" method="post" action="{$PAGE_LINK*,{$GET,NOTIFICATIONS_PAGE_LINK}:redirect={$SELF_URL&*,1,0,0,wide_high=<null>}}" autocomplete="off">{$INSERT_SPAMMER_BLACKHOLE,1}<input type="submit" class="buttons__disable_notifications {$GET*,button_type}" value="{$GET,button_label_disable}" /></form>

	{+START,IF_PASSED_AND_TRUE,RIGHT}</div></div>{+END}
{+END}{+END}
