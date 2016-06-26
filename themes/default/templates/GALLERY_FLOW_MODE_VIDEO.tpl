<div class="float_surrounder" itemscope="itemscope" itemtype="http://schema.org/VideoObject">
	<div class="media_box">
		{VIDEO_PLAYER}
	</div>
	<div class="lined_up_boxes">
		<div class="gallery_entry_details right">
			<section class="box box___gallery_flow_mode_video"><div class="box_inner">
				<h3>{!DETAILS}</h3>

				<table class="map_table results_table">
					{+START,IF,{$NOT,{$MOBILE}}}
						<colgroup>
							<col class="gallery_entry_field_name_column" />
							<col class="gallery_entry_field_value_column" />
						</colgroup>
					{+END}

					<tbody>
						{+START,IF_NON_EMPTY,{_TITLE}}
							<tr>
								<th class="de_th metadata_title">{!TITLE}</th>
								<td>
									{+START,FRACTIONAL_EDITABLE,{_TITLE},title,_SEARCH:cms_galleries:__edit_other:{ID},1,1,{$HAS_EDIT_PERMISSION,mid,{SUBMITTER},{$MEMBER},cms_galleries,galleries,{CAT}}}{_TITLE*}{+END}
								</td>
							</tr>
						{+END}

						<tr>
							<th class="de_th metadata_title">{!ADDED}</th>
							<td>
								<time datetime="{$FROM_TIMESTAMP*,Y-m-d\TH:i:s\Z,{ADD_DATE_RAW}}" itemprop="datePublished">{$DATE_AND_TIME*,1,0,0,{ADD_DATE_RAW}}</time>
							</td>
						</tr>

						<tr>
							<th class="de_th metadata_title">{!BY}</th>
							<td>
								<a rel="author" href="{$MEMBER_PROFILE_URL*,{SUBMITTER}}" itemprop="author">{$USERNAME*,{SUBMITTER},1}</a>

								{+START,INCLUDE,MEMBER_TOOLTIP}{+END}
							</td>
						</tr>

						{+START,IF_NON_EMPTY,{EDIT_DATE_RAW}}
							<tr>
								<th class="de_th metadata_title">{!EDITED}</th>
								<td>{$DATE_AND_TIME*,1,0,0,{EDIT_DATE_RAW}}</td>
							</tr>
						{+END}

						{+START,IF,{$INLINE_STATS}}
							<tr>
								<th class="de_th metadata_title">{!COUNT_VIEWS}</th>
								<td>{VIEWS*}</td>
							</tr>
						{+END}

						{$PREG_REPLACE,</(table|div|tbody|colgroup|col)>,,{$PREG_REPLACE,<(table|div|tbody|colgroup|col)[^>]*>,,{VIDEO_DETAILS}}}
					</tbody>
				</table>

				<ul class="horizontal_links associated_links_block_group">
					<li><img src="{$IMG*,icons/24x24/feedback/comment}" srcset="{$IMG*,icons/48x48/feedback/comment} 2x" alt="" /> <a href="{VIEW_URL*}">{$COMMENT_COUNT,images,{ID}}</a></li>
				</ul>

				{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
				{+START,INCLUDE,STAFF_ACTIONS}
					1_URL={EDIT_URL*}
					1_TITLE={!EDIT_VIDEO}
					1_ICON=menu/_generic_admin/edit_this
				{+END}
			</div></section>
		</div>

		<div class="ratings right">
			{RATING_DETAILS}
		</div>
	</div>
</div>

{+START,IF_PASSED,DESCRIPTION}
	<div itemprop="caption">
		{$PARAGRAPH,{DESCRIPTION}}
	</div>
{+END}
