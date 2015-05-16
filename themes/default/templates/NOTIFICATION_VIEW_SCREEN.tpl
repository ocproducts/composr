{TITLE}

<div class="meta_details" role="note">
	<ul class="meta_details_list">
		<li>{!ADDED_SIMPLE,<time datetime="{$FROM_TIMESTAMP*,Y-m-d\TH:i:s\Z,{DATE_TIMESTAMP}}" itemprop="datePublished">{DATE_WRITTEN_TIME*}</time>}</li>
		<li>
			{!BY_SIMPLE,<a rel="author" href="{FROM_URL*}" itemprop="author">{FROM_USERNAME*}</a>}
			{+START,INCLUDE,MEMBER_TOOLTIP}{+END}
		</li>
	</ul>
</div>

{+START,IF_NON_EMPTY,{FROM_AVATAR_URL}}
	<div class="right spaced">
		<img src="{FROM_AVATAR_URL*}" alt="" />
	</div>
{+END}

{MESSAGE}
