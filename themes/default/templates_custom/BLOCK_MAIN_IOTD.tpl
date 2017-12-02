<div class="hslice">
	<section class="box box___block_main_iotd"><div class="box_inner">
		<h3><span class="entry-title">{!IOTD}</span></h3>

		<div class="entry-content">
			<div class="media_box">
				<a href="{VIEW_URL*}">{IMAGE}</a>
			</div>

			{+START,IF_NON_EMPTY,{I_TITLE}}
				<div class="associated-details">
					{$PARAGRAPH,{I_TITLE}}
				</div>
			{+END}
		</div>

		<ul class="horizontal_links associated-links-block-group force_margin">
			{+START,IF_NON_EMPTY,{VIEW_URL}}<li><a href="{VIEW_URL*}" title="{!VIEW}: {!IOTD} #{ID*}">{!VIEW}</a>{+START,IF,{$NOT,{$MATCH_KEY_MATCH,forum:topicview}}}{+START,IF_PASSED_AND_TRUE,COMMENT_COUNT} <span class="comment_count">{$COMMENT_COUNT,iotds,{ID}}</span>{+END}{+END}{+END}</li>
			<li><a rel="archives" target="_top" href="{ARCHIVE_URL*}" title="{!VIEW_ARCHIVE}: {!IOTDS}">{!VIEW_ARCHIVE}</a></li>
			{+START,IF_NON_EMPTY,{SUBMIT_URL}}<li><a rel="add" title="{!ADD_IOTD}" target="_top" href="{SUBMIT_URL*}">{!ADD}</a></li>{+END}
		</ul>
	</div></section>
</div>
