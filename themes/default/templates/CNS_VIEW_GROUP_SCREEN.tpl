{TITLE}

{LEADER}

{+START,IF_NON_EMPTY,{PROMOTION_INFO}}
	<p>{PROMOTION_INFO}</p>
{+END}

{$SET,bound_catalogue_entry,{$CATALOGUE_ENTRY_FOR,group,{ID}}}
{+START,IF_NON_EMPTY,{$GET,bound_catalogue_entry}}{$CATALOGUE_ENTRY_ALL_FIELD_VALUES,{$GET,bound_catalogue_entry}}{+END}

{+START,IF_NON_EMPTY,{PRIMARY_MEMBERS}}
	{PRIMARY_MEMBERS}
{+END}

{+START,IF_NON_EMPTY,{SECONDARY_MEMBERS}}
	{SECONDARY_MEMBERS}
{+END}

{+START,IF_NON_EMPTY,{PROSPECTIVE_MEMBERS}}
	{PROSPECTIVE_MEMBERS}
{+END}

{+START,IF_EMPTY,{PRIMARY_MEMBERS}{SECONDARY_MEMBERS}{PROSPECTIVE_MEMBERS}}
	<p class="nothing_here">{!NO_MEMBERS}</p>
{+END}

{+START,IF_NON_EMPTY,{ADD_URL}}
	<div class="group_add_member">
		<div class="box box___cns_view_group_screen"><div class="box_inner">
			<h2>{!ADD_MEMBER_TO_GROUP}</h2>

			<form title="{!ADD_MEMBER_TO_GROUP}" onsubmit="if (check_field_for_blankness(this.elements['username'],event)) { disable_button_just_clicked(this); return true; } return false;" action="{ADD_URL*}" method="post" autocomplete="off">
				{$INSERT_SPAMMER_BLACKHOLE}

				<div>
					<label for="vga_username">{!USERNAME}: </label>
					<input{+START,IF,{$MOBILE}} autocorrect="off"{+END} autocomplete="off" maxlength="80" onkeyup="update_ajax_member_list(this,null,false,event);" alt="{!USERNAME}" type="text" id="vga_username" name="username" value="" />
					<input class="button_screen_item menu___generic_admin__add_one" type="submit" value="{!ADD}" />
				</div>
			</form>
		</div></div>
	</div>
{+END}

{+START,IF_NON_EMPTY,{APPLY_URL}}
	<nav>
		<ul class="force_margin actions_list">
			<li><a href="{APPLY_URL*}">{APPLY_TEXT*}</a></li>
		</ul>
	</nav>
{+END}

{$REVIEW_STATUS,group,{ID}}

{+START,INCLUDE,NOTIFICATION_BUTTONS}
	NOTIFICATIONS_TYPE=cns_member_joined_group
	NOTIFICATIONS_ID={ID}
	BREAK=1
	RIGHT=1
{+END}

{+START,IF_PASSED,FORUM}{+START,IF_NON_EMPTY,{FORUM}}
	<h2>{!ACTIVITY}</h2>

	{$BLOCK,block=main_forum_topics,param={FORUM}}

	{+START,IF,{$CONFIG_OPTION,show_screen_actions}}{$BLOCK,failsafe=1,block=main_screen_actions,title={$METADATA,title}}{+END}
{+END}{+END}

{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
{+START,INCLUDE,STAFF_ACTIONS}
	1_URL={EDIT_URL*}
	1_TITLE={!EDIT}
	1_ACCESSKEY=q
	1_REL=edit
	1_ICON=menu/_generic_admin/edit_this
{+END}
