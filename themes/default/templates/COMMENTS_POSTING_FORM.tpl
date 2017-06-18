{$REQUIRE_JAVASCRIPT,core_feedback_features}
{$, Template uses auto-complete}
{$REQUIRE_JAVASCRIPT,jquery}
{$REQUIRE_JAVASCRIPT,jquery_autocomplete}
{$REQUIRE_CSS,autocomplete}

{+START,SET,CAPTCHA}
	{+START,IF_PASSED_AND_TRUE,USE_CAPTCHA}
		<div class="comments_captcha">
			<div class="box box___comments_posting_form__captcha"><div class="box_inner">
				{+START,IF,{$CONFIG_OPTION,audio_captcha}}
					<p>{+START,IF,{$NOT,{$CONFIG_OPTION,js_captcha}}}<label for="captcha">{+END}{!DESCRIPTION_CAPTCHA_2,<a class="js-click-play-self-audio-link" title="{!AUDIO_VERSION}" href="{$FIND_SCRIPT*,captcha,1}?mode=audio{$KEEP*,0,1}&amp;cache_break={$RAND}">{!AUDIO_VERSION}</a>}{+START,IF,{$NOT,{$CONFIG_OPTION,js_captcha}}}</label>{+END}</p>
				{+END}
				{+START,IF,{$NOT,{$CONFIG_OPTION,audio_captcha}}}
					<p>{+START,IF,{$NOT,{$CONFIG_OPTION,js_captcha}}}<label for="captcha">{+END}{!DESCRIPTION_CAPTCHA_3}{+START,IF,{$NOT,{$CONFIG_OPTION,js_captcha}}}</label>{+END}</p>
				{+END}
				{+START,IF,{$CONFIG_OPTION,css_captcha}}
					<iframe {$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"} id="captcha_frame" class="captcha_frame" title="{!CONTACT_STAFF_TO_JOIN_IF_IMPAIRED}" src="{$FIND_SCRIPT*,captcha}{$KEEP*,1,1}&amp;cache_break={$RAND}">{!CONTACT_STAFF_TO_JOIN_IF_IMPAIRED}</iframe>
				{+END}
				{+START,IF,{$NOT,{$CONFIG_OPTION,css_captcha}}}
					<img id="captcha_image" title="{!CONTACT_STAFF_TO_JOIN_IF_IMPAIRED}" alt="{!CONTACT_STAFF_TO_JOIN_IF_IMPAIRED}" src="{$FIND_SCRIPT*,captcha}{$KEEP*,1,1}&amp;cache_break={$RAND}" />
				{+END}
				<input maxlength="6" size="8" class="input_text_required" value="" type="text" id="captcha" name="captcha" />
			</div></div>
		</div>
	{+END}
{+END}

<div data-view="CommentsPostingForm" data-view-params="{+START,PARAMS_JSON,MORE_URL,GET_EMAIL,EMAIL_OPTIONAL,WYSIWYG,CAPTCHA}{_*}{+END}">
	{+START,IF_NON_EMPTY,{COMMENT_URL}}
	<form role="form" title="{TITLE*}" class="comments_form js-form-comments" id="comments_form" action="{COMMENT_URL*}{+START,IF_NON_EMPTY,{$GET,current_anchor}}#{$GET,current_anchor}{+END}{+START,IF_EMPTY,{$GET,current_anchor}}{+START,IF_PASSED_AND_TRUE,COMMENTS}#last_comment{+END}{+END}" method="post" enctype="multipart/form-data" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}
		<input type="hidden" name="_comment_form_post" value="1" />
	{+END}

		{+START,IF_PASSED,HIDDEN}{HIDDEN}{+END}
		<input type="hidden" name="_validated" value="1" />
		<input type="hidden" name="comcode__post" value="1" />
		<input type="hidden" name="stub" value="" />

		<div class="box box___comments_posting_form" {+START,IF_PASSED,EXPAND_TYPE} data-view="ToggleableTray" {+END}>
			{+START,IF_NON_EMPTY,{TITLE}}
				<h3 class="toggleable_tray_title js-tray-header">
					{+START,IF_NON_PASSED,EXPAND_TYPE}
						{TITLE*}
					{+END}
					{+START,IF_PASSED,EXPAND_TYPE}
						<a class="toggleable_tray_button js-btn-tray-toggle" href="#!"><img alt="{$?,{$EQ,{EXPAND_TYPE},contract},{!CONTRACT},{!EXPAND}}" title="{$?,{$EQ,{EXPAND_TYPE},contract},{!CONTRACT},{!EXPAND}}" src="{$IMG*,1x/trays/{EXPAND_TYPE}2}" srcset="{$IMG*,2x/trays/{EXPAND_TYPE}2} 2x" /></a>
						<a class="toggleable_tray_button js-btn-tray-toggle" href="#!">{TITLE*}</a>
					{+END}
				</h3>
			{+END}
			<div class="comments_posting_form_outer {+START,IF_PASSED,EXPAND_TYPE} toggleable_tray js-tray-content{+END}"{+START,IF_PASSED,EXPAND_TYPE} aria-expanded="false"{+END} id="comments_posting_form_outer" style="display: {DISPLAY*}">
				<div class="comments_posting_form_inner">
					<div class="wide_table_wrap"><table class="map_table wide_table">
						{+START,IF,{$NOT,{$MOBILE}}}
							<colgroup>
								<col class="comments_field_name_column" />
								<col class="comments_field_input_column" />
							</colgroup>
						{+END}

						<tbody>
							{$GET,EXTRA_COMMENTS_FIELDS_1}

							{+START,IF,{$AND,{$IS_GUEST},{$CNS}}}
								<tr>
									<th class="de_th vertical_alignment">
										<label for="poster_name_if_guest">{!cns:GUEST_NAME}:</label>
									</th>

									<td>
										<input maxlength="255" size="{$?,{$MOBILE},16,24}" value="" type="text" tabindex="1" id="poster_name_if_guest" name="poster_name_if_guest" />
										{+START,IF_PASSED,JOIN_BITS}{+START,IF_NON_EMPTY,{JOIN_BITS}}
											<span class="horiz_field_sep">{JOIN_BITS}</span>
										{+END}{+END}
									</td>
								</tr>
							{+END}

							{$SET,GET_TITLE,0}
							{+START,IF_PASSED_AND_TRUE,GET_TITLE}
								{$SET,GET_TITLE,1}
							{+END}
							{+START,IF_NON_PASSED,GET_TITLE}
								{$SET,GET_TITLE,{$CONFIG_OPTION,comment_topic_subject}}
							{+END}

							{+START,IF,{$GET,GET_TITLE}}
								<tr>
									<th class="de_th vertical_alignment">
										<label for="title">{!SUBJECT}:</label>
									</th>

									<td>
										<div class="constrain_field">
											<input maxlength="255" class="wide_field" value="" type="text" tabindex="2" id="title" name="title" />
										</div>

										<div id="error_title" style="display: none" class="input_error_here"></div>
									</td>
								</tr>
							{+END}

							{+START,IF,{GET_EMAIL}}
								<tr>
									<th class="de_th vertical_alignment">
										<label for="email">{!EMAIL_ADDRESS}:</label>{+START,IF,{EMAIL_OPTIONAL}} <span class="associated_details">({!OPTIONAL})</span>{+END}
									</th>

									<td>
										<div class="constrain_field">
											<input maxlength="255" class="wide_field{+START,IF,{$NOT,{EMAIL_OPTIONAL}}} input_text_required{+END}" id="email" type="text" tabindex="3" value="{$MEMBER_EMAIL*}" name="email" />
										</div>

										<div id="error_email" style="display: none" class="input_error_here"></div>
									</td>
								</tr>
							{+END}

							{+START,IF_PASSED,REVIEW_RATING_CRITERIA}{+START,IF_PASSED,TYPE}{+START,IF_PASSED,ID}
								{+START,LOOP,REVIEW_RATING_CRITERIA}
									<tr class="js-container-review-rating">
										<th class="de_th vertical_alignment">
											{+START,IF_EMPTY,{REVIEW_TITLE}}{!RATING}:{+END}{+START,IF_NON_EMPTY,{REVIEW_TITLE}}{REVIEW_TITLE*}:{+END}
										</th>

										<td>
											<img id="review_bar_1__{TYPE|*}__{REVIEW_TITLE|*}__{ID|*}" class="rating_star js-img-review-bar" data-vw-rating="2" alt="" src="{$IMG*,icons/14x14/rating}" srcset="{$IMG*,icons/28x28/rating} 2x" />
											<img id="review_bar_2__{TYPE|*}__{REVIEW_TITLE|*}__{ID|*}" class="rating_star js-img-review-bar" data-vw-rating="4" alt="" src="{$IMG*,icons/14x14/rating}" srcset="{$IMG*,icons/28x28/rating} 2x" />
											<img id="review_bar_3__{TYPE|*}__{REVIEW_TITLE|*}__{ID|*}" class="rating_star js-img-review-bar" data-vw-rating="6" alt="" src="{$IMG*,icons/14x14/rating}" srcset="{$IMG*,icons/28x28/rating} 2x" />
											<img id="review_bar_4__{TYPE|*}__{REVIEW_TITLE|*}__{ID|*}" class="rating_star js-img-review-bar" data-vw-rating="8" alt="" src="{$IMG*,icons/14x14/rating}" srcset="{$IMG*,icons/28x28/rating} 2x" />
											<img id="review_bar_5__{TYPE|*}__{REVIEW_TITLE|*}__{ID|*}" class="rating_star js-img-review-bar" data-vw-rating="10" alt="" src="{$IMG*,icons/14x14/rating}" srcset="{$IMG*,icons/28x28/rating} 2x" />
											<input id="review_rating__{TYPE|*}__{REVIEW_TITLE|*}__{ID|*}" class="js-inp-review-rating" type="hidden" name="review_rating__{REVIEW_TITLE|*}" value="" />
										</td>
									</tr>
								{+END}
							{+END}{+END}{+END}

							<tr>
								<th class="de_th">
									{+START,IF,{$NOT,{$GET,GET_TITLE}}}
										<input type="hidden" name="title" value="" />
									{+END}

									{$SET,needs_msg_label,{$OR,{$GET,GET_TITLE},{GET_EMAIL},{$AND,{$IS_GUEST},{$CNS}}}}
									{+START,IF,{$GET,needs_msg_label}}
										<div class="vertical_alignment">
											<a data-open-as-overlay="1" class="link_exempt" title="{!COMCODE_MESSAGE,Comcode} {!LINK_NEW_WINDOW}" target="_blank" href="{$PAGE_LINK*,_SEARCH:userguide_comcode}"><img alt="" src="{$IMG*,icons/16x16/editor/comcode}" srcset="{$IMG*,icons/32x32/editor/comcode} 2x" /></a>
											<label for="post">{!POST_COMMENT}:</label>
										</div>
									{+END}

									{+START,IF_NON_EMPTY,{FIRST_POST}{COMMENT_TEXT}}
										<ul class="associated_links_block_group">
											{+START,IF_NON_EMPTY,{FIRST_POST}}
												<li><a class="non_link" title="{!cns:FIRST_POST} {!LINK_NEW_WINDOW}" target="_blank" href="{FIRST_POST_URL*}" data-blur-deactivate-tooltip="" data-focus-activate-tooltip="['{FIRST_POST*~;^}','320px',null,null,false,true]" data-mouseover-activate-tooltip="['{FIRST_POST*~;^}','320px',null,null,false,true]">{!cns:FIRST_POST}</a></li>
											{+END}

											{+START,IF_NON_EMPTY,{COMMENT_TEXT}}
												<li><a class="non_link" href="{$PAGE_LINK*,:rules}" data-blur-deactivate-tooltip="" data-focus-activate-tooltip="['{$TRUNCATE_LEFT,{COMMENT_TEXT*~;^},1000,0,1}','320px',null,null,false,true]" data-mouseover-activate-tooltip="['{$TRUNCATE_LEFT,{COMMENT_TEXT*~;^},1000,0,1}','320px',null,null,false,true]">{!HOVER_MOUSE_IMPORTANT}</a></li>
											{+END}
										</ul>
									{+END}

									{+START,IF,{$NOT,{$GET,needs_msg_label}}}
										<div>
											<a data-open-as-overlay="1" class="link_exempt" title="{!COMCODE_MESSAGE,Comcode} {!LINK_NEW_WINDOW}" target="_blank" href="{$PAGE_LINK*,_SEARCH:userguide_comcode}"><img alt="" src="{$IMG*,icons/16x16/editor/comcode}" srcset="{$IMG*,icons/32x32/editor/comcode} 2x" class="vertical_alignment" /></a>
											<label for="post" class="vertical_alignment">{!POST_COMMENT}:</label>
										</div>
									{+END}

									{+START,IF,{$NOT,{$MOBILE}}}
										{+START,IF_NON_EMPTY,{EM}}
											<div class="comments_posting_form_emoticons">
												<div class="box box___comments_posting_form"><div class="box_inner">
													{EM}

													{+START,IF,{$CNS}}
														<p class="associated_link associated_links_block_group"><a rel="nofollow" tabindex="5" href="#!" class="js-click-open-site-emoticon-chooser-window">{!EMOTICONS_POPUP}</a></p>
													{+END}
												</div>
											</div></div>
										{+END}
									{+END}
								</th>

								<td>
									<div class="constrain_field">
										<textarea name="post" id="post" data-textarea-auto-height="" accesskey="x" class="wide_field js-focus-textarea-post" cols="42" rows="{$?,{$IS_NON_EMPTY,{$GET,COMMENT_POSTING_ROWS}},{$GET,COMMENT_POSTING_ROWS},11}">{POST_WARNING*}{+START,IF_PASSED,DEFAULT_TEXT}{DEFAULT_TEXT*}{+END}</textarea>
									</div>

									<div id="error_post" style="display: none" class="input_error_here"></div>

									{+START,IF_PASSED,ATTACHMENTS}
										<div class="attachments">
											{+START,IF_PASSED,ATTACH_SIZE_FIELD}
												{ATTACH_SIZE_FIELD}
											{+END}
											<input type="hidden" name="posting_ref_id" value="{$RAND%}" />
											{ATTACHMENTS}
										</div>
									{+END}

									{+START,IF,{$MOBILE}}
										{+START,IF,{$CONFIG_OPTION,js_captcha}}
											{+START,IF_NON_EMPTY,{$TRIM,{$GET,CAPTCHA}}}
												<div id="captcha_spot"></div>
											{+END}
										{+END}
										{+START,IF,{$NOT,{$CONFIG_OPTION,js_captcha}}}
											{$GET,CAPTCHA}
										{+END}
									{+END}
								</td>
							</tr>

							{$GET,EXTRA_COMMENTS_FIELDS_2}
						</tbody>
					</table></div>

					<div class="comments_posting_form_end">
						{+START,IF,{$NOT,{$MOBILE}}}
							{+START,IF,{$CONFIG_OPTION,js_captcha}}
								{+START,IF_NON_EMPTY,{$TRIM,{$GET,CAPTCHA}}}
									<div id="captcha_spot"></div>
								{+END}
							{+END}
							{+START,IF,{$NOT,{$CONFIG_OPTION,js_captcha}}}
								{$GET,CAPTCHA}
							{+END}
						{+END}

						<div class="proceed_button buttons_group">
							{+START,IF,{$NOT,{$MOBILE}}}
								{+START,IF,{$CONFIG_OPTION,enable_previews}}
									<input id="preview_button" accesskey="p" tabindex="250" class="tabs__preview js-click-do-form-preview {$?,{$IS_EMPTY,{COMMENT_URL}},button_screen,button_screen_item}" type="button" value="{!PREVIEW}" />
								{+END}
							{+END}

							{+START,IF_PASSED,MORE_URL}
								<input tabindex="6" accesskey="y" class="buttons__new_post_full {$?,{$IS_EMPTY,{COMMENT_URL}},button_screen,button_screen_item} js-btn-full-editor" type="button" value="{$?,{$MOBILE},{!MORE},{!FULL_EDITOR}}" />
							{+END}

							{+START,IF_PASSED,ATTACHMENTS}
								{+START,IF,{$BROWSER_MATCHES,simplified_attachments_ui}}
									<input tabindex="7" id="attachment_upload_button" class="for_field_post buttons__thumbnail {$?,{$IS_EMPTY,{COMMENT_URL}},button_screen,button_screen_item}" type="button" value="{!comcode:ADD_IMAGES}" />
								{+END}
							{+END}

							{+START,SET,button_title}{+START,IF_PASSED,SUBMIT_NAME}{SUBMIT_NAME*}{+END}{+START,IF_NON_PASSED,SUBMIT_NAME}{+START,IF_NON_EMPTY,{TITLE}}{TITLE*}{+END}{+START,IF_EMPTY,{TITLE}}{!SEND}{+END}{+END}{+END}
							<input tabindex="8" accesskey="u" id="submit_button" class="{+START,IF_NON_PASSED,MORE_URL}buttons__new_comment{+END}{+START,IF_PASSED,MORE_URL}buttons__new_reply{+END} {$?,{$IS_EMPTY,{COMMENT_URL}},button_screen,button_screen_item} js-btn-submit-comments" type="button" value="{$?,{$MOBILE},{$REPLACE,{!cns:REPLY},{!_REPLY},{$GET,button_title}},{$GET,button_title}}" />
						</div>
					</div>
				</div>
			</div>
		</div>

	{+START,IF_NON_EMPTY,{COMMENT_URL}}
	</form>
	{+END}

	{+START,IF,{$CONFIG_OPTION,enable_previews}}
		<iframe{$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"} title="{!PREVIEW}" name="preview_iframe" id="preview_iframe" src="{$BASE_URL*}/uploads/index.html" class="hidden_preview_frame">{!PREVIEW}</iframe>
	{+END}
</div>
