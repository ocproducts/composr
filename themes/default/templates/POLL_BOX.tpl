<section class="box box___poll_box"><div class="box_inner">
	{+START,SET,content_box_title}
		{+START,IF,{GIVE_CONTEXT}}
			{!CONTENT_IS_OF_TYPE,{!POLL},{QUESTION}}
		{+END}

		{+START,IF,{$NOT,{GIVE_CONTEXT}}}
			{+START,FRACTIONAL_EDITABLE,{QUESTION_PLAIN},question,_SEARCH:cms_polls:__edit:{PID},1}{QUESTION}{+END}
		{+END}
	{+END}
	{+START,IF,{$NOT,{$GET,skip_content_box_title}}}
		<h3>{$GET,content_box_title}</h3>
	{+END}

	<a id="poll_jump" rel="dovote"></a>
	<form title="{!VOTE}" target="_self" action="{VOTE_URL*}" method="post" class="poll_form" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div>
			{CONTENT}
		</div>

		{+START,IF_NON_EMPTY,{RESULT_URL}}
			<p>
				<input disabled="disabled" id="poll{PID*}" onclick="disable_button_just_clicked(this);" class="button_screen_item buttons__vote" type="submit" value="{!VOTE}" />
			</p>
		{+END}
	</form>

	<ul class="horizontal_links associated_links_block_group">
		{+START,IF_NON_EMPTY,{FULL_URL}}<li><a target="_top" href="{FULL_URL*}" title="{!VIEW}: {!POLL} #{PID*}">{!VIEW}</a>{+START,IF,{$NOT,{$MATCH_KEY_MATCH,forum:topicview}}}{+START,IF_PASSED_AND_TRUE,COMMENT_COUNT} <span class="comment_count">{$COMMENT_COUNT,polls,{PID}}</span>{+END}{+END}{+END}</li>
		{+START,IF_NON_EMPTY,{ARCHIVE_URL}}<li><a rel="archives" target="_top" href="{ARCHIVE_URL*}" title="{!VIEW_ARCHIVE}: {!POLLS}">{!VIEW_ARCHIVE}</a></li>{+END}
		{+START,IF_NON_EMPTY,{RESULT_URL}}<li><form title="{!POLL_RESULTS}" target="_self" class="inline" action="{VOTE_URL*}" method="post" autocomplete="off">{$INSERT_SPAMMER_BLACKHOLE}<input onclick="var form=this.form; window.fauxmodal_confirm('{!VOTE_FORFEIGHT}'\,function(answer) \{ if (answer) guarded_form_submit(form); \}); return false;" class="button_hyperlink" type="submit" value="{!POLL_RESULTS}" /></form></li>{+END}
		{+START,IF_NON_EMPTY,{SUBMIT_URL}}<li><a rel="add" target="_top" href="{SUBMIT_URL*}">{!ADD}</a></li>{+END}
	</ul>
</div></section>

