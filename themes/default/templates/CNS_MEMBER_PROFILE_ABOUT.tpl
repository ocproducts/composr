{$REQUIRE_JAVASCRIPT,core_cns}

<div class="float-surrounder" data-tpl="cnsMemberProfileAbout">
	<div class="cns-profile-column">
		{+START,IF_NON_EMPTY,{AVATAR_URL}}
			<div class="cns-member-profile-avatar">
				<img src="{$ENSURE_PROTOCOL_SUITABILITY*,{AVATAR_URL}}" alt="{!AVATAR}" />
			</div>
		{+END}

		<h2>{!USERGROUPS}</h2>

		<ul class="compact-list">
			<li><span class="role"{+START,IF_PASSED,ON_PROBATION} style="text-decoration: line-through"{+END}>{PRIMARY_GROUP}</span></li>
			{+START,LOOP,SECONDARY_GROUPS}
				<li {+START,IF_PASSED,ON_PROBATION}{+START,IF,{$NEQ,{$CONFIG_OPTION,probation_usergroup},{_loop_key},{_loop_var}}} style="text-decoration: line-through"{+END}{+END}><a href="{$PAGE_LINK*,_SEARCH:groups:view:{_loop_key}}">{_loop_var*}</a></li>
			{+END}
		</ul>

		<div class="cns-account-links">
			{+START,IF,{VIEW_PROFILES}}
				{+START,LOOP,CUSTOM_FIELDS}
					{$SET,is_messenger_field,{$EQ,{NAME},{!cns_special_cpf:DEFAULT_CPF_im_skype_NAME},{!cns_special_cpf:DEFAULT_CPF_im_jabber_NAME},{!cns_special_cpf:DEFAULT_CPF_sn_twitter_NAME},{!cns_special_cpf:DEFAULT_CPF_sn_facebook_NAME},{!cns_special_cpf:DEFAULT_CPF_sn_google_NAME}}}
					{+START,IF,{$GET,is_messenger_field}}
						{+START,SET,messenger_fields}{+START,IF_NON_EMPTY,{RAW_VALUE}}
							{$GET,messenger_fields}
							{+START,IF,{$EQ,{NAME},{!cns_special_cpf:DEFAULT_CPF_im_skype_NAME}}}<li><img alt="" width="24" height="24" src="{$IMG*,icons/links/skype}" /> <a title="{!PHONE_THEM_UP} {!LINK_NEW_WINDOW}" href="skype:{RAW_VALUE*}?call">{!PHONE_THEM_UP}</a> (Skype)</li>{+END}
							{+START,IF,{$EQ,{NAME},{!cns_special_cpf:DEFAULT_CPF_im_jabber_NAME}}}<li><img alt="" width="24" height="24" src="{$IMG*,icons/links/xmpp}" /> <a title="{!MESSAGE_THEM} {!LINK_NEW_WINDOW}" href="xmpp:{RAW_VALUE*}">{!MESSAGE_THEM}</a> (Jabber/XMPP)</li>{+END}
							{+START,IF,{$EQ,{NAME},{!cns_special_cpf:DEFAULT_CPF_sn_twitter_NAME}}}<li><img alt="" width="24" height="24" src="{$IMG*,icons/links/twitter}" /> <a title="{!MESSAGE_THEM} {!LINK_NEW_WINDOW}" href="http://twitter.com/{RAW_VALUE*}" rel="me">@{RAW_VALUE*}</a> (Twitter)</li>{+END}
							{+START,IF,{$EQ,{NAME},{!cns_special_cpf:DEFAULT_CPF_sn_facebook_NAME}}}<li><img alt="" width="24" height="24" src="{$IMG*,icons/links/facebook}" /> <a title="{!MESSAGE_THEM} {!LINK_NEW_WINDOW}" href="{RAW_VALUE*}" rel="me">Facebook</a></li>{+END}
							{+START,IF,{$EQ,{NAME},{!cns_special_cpf:DEFAULT_CPF_sn_google_NAME}}}<li><img alt="" width="24" height="24" src="{$IMG*,icons/links/google_plus}" /> <a title="{!MESSAGE_THEM} {!LINK_NEW_WINDOW}" href="{RAW_VALUE*}" rel="me">Google+</a></li>{+END}
						{+END}{+END}
					{+END}
				{+END}
			{+END}
			{+START,IF_NON_EMPTY,{ACTIONS_contact}{$GET,messenger_fields}}
				<div data-toggleable-tray="{}">
					<h2 class="js-tray-header">
						<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!CONTRACT}: {!menus:CONTACT}" title="{!CONTRACT}" width="20" height="20" src="{$IMG*,icons/trays/contract}" /></a>
						<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{!menus:CONTACT}</a>
					</h2>

					<nav class="toggleable-tray js-tray-content" style="display: block">
						<ul class="nl">
							{ACTIONS_contact}
							{$GET,messenger_fields}
						</ul>
					</nav>
				</div>
			{+END}

			{+START,IF_NON_EMPTY,{ACTIONS_content}}
				<div data-toggleable-tray="{}">
					<h2 class="js-tray-header">
						<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!EXPAND}: {!CONTENT}" title="{!EXPAND}" width="20" height="20" src="{$IMG*,icons/trays/expand}" /></a>
						<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{!CONTENT}</a>
					</h2>

					<nav class="toggleable-tray js-tray-content" style="display: none" aria-expanded="false">
						<ul class="nl">
							{ACTIONS_content}
						</ul>
					</nav>
				</div>
			{+END}

			{+START,IF_NON_EMPTY,{ACTIONS_views}{ACTIONS_profile}}
				<div data-toggleable-tray="{}">
					<h2 class="js-tray-header">
						<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!EXPAND}: {!ACCOUNT}" title="{!EXPAND}" width="20" height="20" src="{$IMG*,icons/trays/expand}" /></a>
						<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{!ACCOUNT}</a>
					</h2>

					<nav class="toggleable-tray js-tray-content" style="display: none" aria-expanded="false">
						<ul class="nl">
							{ACTIONS_views}
							{ACTIONS_profile}
						</ul>
					</nav>
				</div>
			{+END}

			{+START,IF_NON_EMPTY,{ACTIONS_audit}}
				<div data-toggleable-tray="{}">
					<h2 class="js-tray-header">
						<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!EXPAND}: {!AUDIT}" title="{!EXPAND}" width="20" height="20" src="{$IMG*,icons/trays/expand}" /></a>
						<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{!AUDIT}</a>
					</h2>

					<nav class="toggleable-tray js-tray-content" style="display: none" aria-expanded="false">
						<ul class="nl">
							{ACTIONS_audit}
						</ul>
					</nav>
				</div>
			{+END}
		</div>

		{$REVIEW_STATUS,member,{MEMBER_ID}}
	</div>

	<div class="cns-profile-main">
		{+START,IF,{$NOT,{VIEW_PROFILES}}}
			<p class="red-alert" role="alert">
				{!ACCESS_DENIED}
			</p>
		{+END}

		{+START,IF,{$OR,{$AND,{VIEW_PROFILES},{$IS_NON_EMPTY,{CUSTOM_FIELDS}}},{$IS_NON_EMPTY,{$TRIM,{SIGNATURE}}}}}
			<h2>{!ABOUT}</h2>

			<div class="wide-table-wrap">
				<table class="map-table wide-table cns-profile-fields cns-profile-about-section responsive-blocked-table">
					{+START,IF,{$DESKTOP}}
						<colgroup>
							<col class="cns-profile-about-field-name-column" />
							<col class="cns-profile-about-field-value-column" />
						</colgroup>
					{+END}

					<tbody>
						{+START,IF,{VIEW_PROFILES}}
							{+START,LOOP,CUSTOM_FIELDS}
								{$SET,is_point_field,{$EQ,{NAME},{!SPECIAL_CPF__cms_points_used},{!SPECIAL_CPF__cms_gift_points_used},{!SPECIAL_CPF__cms_points_gained_chat},{!SPECIAL_CPF__cms_points_gained_given},{!SPECIAL_CPF__cms_points_gained_visiting},{!SPECIAL_CPF__cms_points_gained_rating},{!SPECIAL_CPF__cms_points_gained_voting},{!SPECIAL_CPF__cms_points_gained_wiki}}}
								{$SET,is_messenger_field,{$EQ,{NAME},{!cns_special_cpf:DEFAULT_CPF_im_skype_NAME},{!cns_special_cpf:DEFAULT_CPF_im_jabber_NAME},{!cns_special_cpf:DEFAULT_CPF_sn_twitter_NAME},{!cns_special_cpf:DEFAULT_CPF_sn_facebook_NAME},{!cns_special_cpf:DEFAULT_CPF_sn_google_NAME}}}

								{+START,IF,{$NOR,{$GET,is_point_field},{$GET,is_messenger_field}}}
									<tr id="cpf-{NAME|*}" class="cpf-{$REPLACE,_,-,{FIELD_ID|*}}">
										<th class="de-th">
											{NAME*}:
										</th>

										<td>
											<span>
												{+START,IF_EMPTY,{ENCRYPTED_VALUE}}
													{+START,IF_PASSED,EDITABILITY}
														{$SET,edit_type,{EDIT_TYPE}}
														{+START,FRACTIONAL_EDITABLE,{RAW_VALUE},field_{FIELD_ID},_SEARCH:members:view:{MEMBER_ID}:only_tab=edit:only_subtab=settings,{EDITABILITY}}{$SMART_LINK_STRIP,{VALUE},{MEMBER_ID}}{+END}
													{+END}
													{+START,IF_NON_PASSED,EDITABILITY}
														{$SMART_LINK_STRIP,{VALUE},{MEMBER_ID}}
													{+END}
												{+END}
												{+START,IF_NON_EMPTY,{ENCRYPTED_VALUE}}
													{!encryption:DATA_ENCRYPTED} <a href="#!" class="js-click-member-profile-about-decrypt-data" title="{!encryption:DECRYPT_DATA}: {$STRIP_TAGS,{!encryption:DESCRIPTION_DECRYPT_DATA}}">{!encryption:DECRYPT_DATA}</a>
												{+END}
												<!-- {$,Break out of non-terminated comments in CPF} -->
											</span>
										</td>
									</tr>
								{+END}
							{+END}
						{+END}

						{+START,IF,{$IS_NON_EMPTY,{$TRIM,{SIGNATURE}}}}
							<tr>
								<th class="de-th">
									{!SIGNATURE}:
								</th>

								<td>
									{$SMART_LINK_STRIP,{SIGNATURE},{MEMBER_ID}}
								</td>
							</tr>
						{+END}
					</tbody>
				</table>
			</div>
		{+END}

		{+START,IF,{VIEW_PROFILES}}
			{+START,IF_PASSED,CUSTOM_FIELDS_SECTIONS}
				{+START,LOOP,CUSTOM_FIELDS_SECTIONS}
					<h2>{_loop_key*}</h2>

					<div class="wide-table-wrap">
						<table class="map-table wide-table cns-profile-fields cns-profile-about-section responsive-blocked-table">
							{+START,IF,{$DESKTOP}}
								<colgroup>
									<col class="cns-profile-about-field-name-column" />
									<col class="cns-profile-about-field-value-column" />
								</colgroup>
							{+END}

							<tbody>
								{+START,LOOP,CUSTOM_FIELDS_SECTION}
									<tr id="cpf-{NAME|*}">
										<th class="de-th">
											{NAME*}:
										</th>

										<td>
											<span>
												{+START,IF_EMPTY,{ENCRYPTED_VALUE}}
													{+START,IF,{$EQ,{!ADDRESS}: {NAME},{!cns_special_cpf:SPECIAL_CPF__cms_country}}}
														{$COUNTRY_CODE_TO_NAME,{RAW_VALUE}}
													{+END}

													{+START,IF,{$NEQ,{!ADDRESS}: {NAME},{!cns_special_cpf:SPECIAL_CPF__cms_country}}}
														{+START,IF_PASSED,EDITABILITY}
															{$SET,edit_type,{EDIT_TYPE}}
															{+START,FRACTIONAL_EDITABLE,{RAW_VALUE},field_{FIELD_ID},_SEARCH:members:view:{MEMBER_ID}:only_tab=edit:only_subtab=settings,{EDITABILITY}}{$SMART_LINK_STRIP,{VALUE},{MEMBER_ID}}{+END}
														{+END}
														{+START,IF_NON_PASSED,EDITABILITY}
															{$SMART_LINK_STRIP,{VALUE},{MEMBER_ID}}
														{+END}
													{+END}
												{+END}
												{+START,IF_NON_EMPTY,{ENCRYPTED_VALUE}}
													{!encryption:DATA_ENCRYPTED} <a href="#!" class="js-click-member-profile-about-decrypt-data" title="{!encryption:DECRYPT_DATA}: {$STRIP_TAGS,{!encryption:DESCRIPTION_DECRYPT_DATA}}">{!encryption:DECRYPT_DATA}</a>
												{+END}
												<!-- {$,Break out of non-terminated comments in CPF} -->
											</span>
										</td>
									</tr>
								{+END}
							</tbody>
						</table>
					</div>
				{+END}
			{+END}
		{+END}

		{+START,IF,{VIEW_PROFILES}}
			<h2>{!DETAILS}</h2>

			<meta class="fn given-name" itemprop="name" content="{$DISPLAYED_USERNAME*,{USERNAME}}" />

			<div class="wide-table-wrap">
				<table class="map-table wide-table cns-profile-details cns-profile-about-section responsive-blocked-table">
					{+START,IF,{$DESKTOP}}
						<colgroup>
							<col class="cns-profile-about-field-name-column" />
							<col class="cns-profile-about-field-value-column" />
						</colgroup>
					{+END}

					<tbody>
						{+START,IF_NON_EMPTY,{$CONFIG_OPTION,display_name_generator}}
							<tr>
								<th class="de-th">{!USERNAME}:</th>
								<td>{USERNAME*}</td>
							</tr>
						{+END}

						<tr>
							<th class="de-th">{!ONLINE_NOW}:</th>
							<td>{ONLINE_NOW*} <span class="associated-details">({$DATE_TIME*,{LAST_VISIT_TIME_RAW}})</span></td>
						</tr>

						{+START,IF_NON_EMPTY,{JOIN_DATE}}
							<tr>
								<th class="de-th">{!JOIN_DATE}:</th>
								<td>
									<time datetime="{$FROM_TIMESTAMP*,Y-m-d\TH:i:s\Z,{JOIN_DATE_RAW}}" itemprop="datePublished">{JOIN_DATE*}</time>
								</td>
							</tr>
						{+END}

						{+START,IF_PASSED,ON_PROBATION}
							<tr>
								<th class="de-th">{!ON_PROBATION_UNTIL}:</th>
								<td>{$DATE_TIME*,{ON_PROBATION}}</td>
							</tr>
						{+END}

						<tr>
							<th class="de-th">{!TIME_FOR_THEM}:</th>
							<td>{TIME_FOR_THEM*}</td>
						</tr>

						<tr>
							<th class="de-th">{!TIMEZONE}:</th>
							<td>{USERS_TIMEZONE*}</td>
						</tr>

						{+START,IF_NON_EMPTY,{BANNED}}
							<tr>
								<th class="de-th">{!BANNED}:</th>
								<td>{BANNED*}</td>
							</tr>
						{+END}

						{+START,IF_NON_EMPTY,{DOB}}
							<tr>
								<th class="de-th">{DOB_LABEL*}:</th>
								<td><span class="bday">{DOB*}</span></td>
							</tr>
						{+END}

						{+START,IF,{$HAS_PRIVILEGE,member_maintenance}}{+START,IF_NON_EMPTY,{EMAIL_ADDRESS}}
							<tr>
								<th class="de-th">{!EMAIL_ADDRESS}:</th>
								<td><a class="email" href="mailto:{EMAIL_ADDRESS*}">{EMAIL_ADDRESS*}</a></td>
							</tr>
						{+END}{+END}

						{+START,LOOP,EXTRA_INFO_DETAILS}
							<tr>
								<th class="de-th">{_loop_key*}:</th>
								<td><span>{_loop_var*}</span></td>
							</tr>
						{+END}
					</tbody>
				</table>
			</div>

			{+START,IF_NON_EMPTY,{PHOTO_URL}}
				<h2>{!PHOTO}</h2>

				<div class="cns-member-profile-photo">
					<a rel="lightbox" href="{$ENSURE_PROTOCOL_SUITABILITY*,{PHOTO_URL}}"><img src="{PHOTO_THUMB_URL*}" alt="{!PHOTO}" class="photo" itemprop="primaryImageOfPage" /></a>
				</div>
			{+END}
		{+END}

		{+START,LOOP,EXTRA_SECTIONS}
			{_loop_var}
		{+END}

		{+START,IF,{VIEW_PROFILES}}
			<div class="stats-overwrap">
				<h2>{!TRACKING}</h2>

				<div class="wide-table-wrap">
					<table class="map-table wide-table cns-profile-tracking cns-profile-about-section responsive-blocked-table">
						{+START,IF,{$DESKTOP}}
							<colgroup>
								<col class="cns-profile-about-field-name-column" />
								<col class="cns-profile-about-field-value-column" />
							</colgroup>
						{+END}

						<tbody>
							{+START,IF,{$ADDON_INSTALLED,cns_forum}}
								<tr>
									<th class="de-th">{!COUNT_POSTS}:</th>
									<td>{COUNT_POSTS*}</td>
								</tr>
							{+END}

							{+START,IF_NON_EMPTY,{MOST_ACTIVE_FORUM}}
								<tr>
									<th class="de-th">{!MOST_ACTIVE_FORUM}:</th>
									<td>{MOST_ACTIVE_FORUM*}</td>
								</tr>
							{+END}

							{+START,IF_PASSED,SUBMIT_DAYS_AGO}
								<tr>
									<th class="de-th">{!LAST_SUBMIT_TIME}:</th>
									<td>{!DAYS_AGO,{SUBMIT_DAYS_AGO}}</td>
								</tr>
							{+END}

							{+START,IF,{$ADDON_INSTALLED,securitylogging}}
							{+START,IF_PASSED,IP_ADDRESS}{+START,IF_NON_EMPTY,{IP_ADDRESS}}
									<tr>
										<th class="de-th">{!IP_ADDRESS}:</th>
										<td>
											{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,admin_lookup}}
												<a href="{$PAGE_LINK*,_SEARCH:admin_lookup:param={IP_ADDRESS&}}">{$TRUNCATE_SPREAD,{IP_ADDRESS*},40,1,1}</a>
											{+END}
											{+START,IF,{$NOT,{$HAS_ACTUAL_PAGE_ACCESS,admin_lookup}}}
												{$TRUNCATE_SPREAD,{IP_ADDRESS*},40,1,1}
											{+END}
										</td>
									</tr>
								{+END}{+END}
							{+END}

							{+START,IF_PASSED,USER_AGENT}
								<tr>
									<th class="de-th"><abbr title="{!USER_AGENT}">{$PREG_REPLACE*, \([^\(\)]*\),,{!USER_AGENT}}</abbr>:</th>
									<td><abbr title="{USER_AGENT*}">{$PREG_REPLACE*, \([^\(\)]*\),,{$PREG_REPLACE,\.\d+,,{$REPLACE,({OPERATING_SYSTEM}),,{USER_AGENT}}}}</abbr></td>
								</tr>
							{+END}

							{+START,IF_PASSED,OPERATING_SYSTEM}
								<tr>
									<th class="de-th">{!USER_OS}:</th>
									<td>{OPERATING_SYSTEM*}</td>
								</tr>
							{+END}

							{+START,LOOP,EXTRA_TRACKING_DETAILS}
								<tr>
									<th class="de-th">{_loop_key*}:</th>
									<td><span>{_loop_var*}</span></td>
								</tr>
							{+END}
						</tbody>
					</table>
				</div>
			</div>
		{+END}

		{+START,INCLUDE,STAFF_ACTIONS}
			{+START,IF,{$ADDON_INSTALLED,tickets}}
				1_URL={$PAGE_LINK*,_SEARCH:report_content:content_type=member:content_id={MEMBER_ID}:redirect={$SELF_URL&}}
				1_TITLE={!report_content:REPORT_THIS}
				1_ICON=buttons/report
				1_REL=report
			{+END}
		{+END}
	</div>
</div>
