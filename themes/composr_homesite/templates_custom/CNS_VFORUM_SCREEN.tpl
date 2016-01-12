{TITLE}

{CONTENT}

<br />

{+START,BOX}
	Also <em>{$MANTIS_WEEK_ACTIVITY*}</em> issues on the <a href="{$BASE_URL*}/tracker/">tracker</a> have been modified in the last 7 days, and <em>{$MANTIS_SPONSOR_WEEK_ACTIVITY*}</em> sponsorships added.
{+END}

{+START,IF,{$NOT,{$WIDE_HIGH}}}
	{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
	{+START,IF,{$AND,{$SHOW_DOCS},{$HAS_PRIVILEGE,see_software_docs}}}
		{+START,INCLUDE,STAFF_ACTIONS}
			STAFF_ACTIONS_TITLE={!STAFF_ACTIONS}
			1_URL={$TUTORIAL_URL*,tut_forum_tracking}
			1_TITLE={!HELP}
			1_REL=help
			1_ICON=menu/pages/help
		{+END}
	{+END}
{+END}
