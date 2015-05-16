{TITLE}

<div class="float_surrounder" itemprop="significantLinks">
	{+START,SET,commented_out}
		<div class="chicklets">
			{+START,INCLUDE,NEWS_CHICKLETS}RSS_URL={$FIND_SCRIPT*,backend}{+END}
		</div>
	{+END}

	{$,<div class="chicklets_spacer">}
		{CONTENT}
	{$,</div>}
</div>

{+START,IF_PASSED,CAT}
	{$REVIEW_STATUS,news_category,{CAT}}

	{+START,INCLUDE,NOTIFICATION_BUTTONS}
		NOTIFICATIONS_TYPE=news_entry
		NOTIFICATIONS_ID={CAT}
		BREAK=1
		RIGHT=1
	{+END}
{+END}

{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
{+START,INCLUDE,STAFF_ACTIONS}
	1_URL={SUBMIT_URL*}
	1_TITLE={$?,{BLOG},{!ADD_NEWS_BLOG},{!ADD_NEWS}}
	1_REL=add
	1_ICON=menu/_generic_admin/add_one
{+END}
