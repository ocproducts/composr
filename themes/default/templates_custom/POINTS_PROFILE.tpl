<div class="points-boxes">
	<div class="points-box box">
		{+START,IF,{$HAS_PRIVILEGE,use_points,{MEMBER}}}
			<p class="intro">{!CURRENT_POINTS}:</p>
			<p>{!POINTS_TO_SPEND,<span class="figure">{REMAINING*}</span>}</p>
		{+END}
		{+START,IF,{$NOT,{$HAS_PRIVILEGE,use_points,{MEMBER}}}}
			{!NO_PERMISSION_TO_USE_POINTS}
		{+END}
	</div>

	<div class="points-box box">
		<p class="intro">{!COUNT_GIFT_POINTS_LEFT}:</p>
		<p>{!POINTS_TO_GIVE,<span class="figure">{GIFT_POINTS_AVAILABLE*}</span>}</p>
	</div>
</div>

<div class="points-earned">
	<h2>{!POINTS_EARNED}</h2>

	<p>
		{!VIEWING_POINTS_PROFILE_OF,<a href="{PROFILE_URL*}">{$DISPLAYED_USERNAME*,{USERNAME}}</a>}
	</p>

	<table class="columned-table autosized-table points-summary-table">
		<thead>
			<tr>
				<th>{!ACTIVITY}</th>
				<th>{!AMOUNT}</th>
				<th>{!COUNT_TOTAL}</th>
			</tr>
		</thead>

		<tbody>
			{+START,IF,{$NEQ,{POINTS_JOINING},0}}
				<tr>
					<td>&bull;&nbsp;{!JOINING}:</td>
					<td class="equation">1 &times; {POINTS_JOINING*} {!POINTS_UNIT}</td>
					<td class="answer">= {POINTS_JOINING*} {!POINTS_UNIT}</td>
				</tr>
			{+END}
			{+START,IF,{$NEQ,{POINTS_PER_DAY},0}}
				<tr>
					<td>&bull;&nbsp;{!MEMBERSHIP_LENGTH}</td>
					<td class="equation">{DAYS_JOINED*} &times; {POINTS_PER_DAY*} {!POINTS_UNIT}</td>
					<td class="answer">= {MULT_POINTS_PER_DAY*} {!POINTS_UNIT}</td>
				</tr>
			{+END}
			{+START,IF,{$NEQ,{POINTS_POSTING},0}}{+START,IF,{$HAS_FORUM}}
				<tr>
					<td>&bull;&nbsp;{!COUNT_POSTS}:</td>
					<td class="equation">{POST_COUNT*} &times; {POINTS_POSTING*} {!POINTS_UNIT}</td>
					<td class="answer">= {MULT_POINTS_POSTING*} {!POINTS_UNIT}</td>
				</tr>
			{+END}{+END}
			{+START,IF,{$NEQ,{POINTS_WIKI_POSTING},0}}{+START,IF,{$ADDON_INSTALLED,wiki}}
				<tr>
					<td>&bull;&nbsp;{!wiki:WIKI_POSTS}:</td>
					<td class="equation">{WIKI_POST_COUNT*} &times; {POINTS_WIKI_POSTING*} {!POINTS_UNIT}</td>
					<td class="answer">= {MULT_POINTS_WIKI_POSTING*} {!POINTS_UNIT}</td>
				</tr>
			{+END}{+END}
			{+START,IF,{$NEQ,{POINTS_CHAT_POSTING},0}}{+START,IF,{$ADDON_INSTALLED,chat}}
				<tr>
					<td>&bull;&nbsp;{!chat:COUNT_CHATPOSTS}:</td>
					<td class="equation">{CHAT_POST_COUNT*} &times; {POINTS_CHAT_POSTING*} {!POINTS_UNIT}</td>
					<td class="answer">= {MULT_POINTS_CHAT_POSTING*} {!POINTS_UNIT}</td>
				</tr>
			{+END}{+END}
			{+START,IF,{$NEQ,{POINTS_PER_DAILY_VISIT},0}}
				<tr>
					<td>&bull;&nbsp;{!COUNT_VISITS}:</td>
					<td class="equation">{POINTS_GAINED_VISITING*} &times; {POINTS_PER_DAILY_VISIT*} {!POINTS_UNIT}</td>
					<td class="answer">= {MULT_POINTS_VISITING*} {!POINTS_UNIT}</td>
				</tr>
			{+END}
			{+START,IF,{$NEQ,{POINTS_VOTING},0}}{+START,IF,{$ADDON_INSTALLED,polls}}
				<tr>
					<td>&bull;&nbsp;{!COUNT_VOTINGS}:</td>
					<td class="equation">{POINTS_GAINED_VOTING*} &times; {POINTS_VOTING*} {!POINTS_UNIT}</td>
					<td class="answer">= {MULT_POINTS_VOTING*} {!POINTS_UNIT}</td>
				</tr>
			{+END}{+END}
			{+START,IF,{$NEQ,{POINTS_RATING},0}}
				<tr>
					<td>&bull;&nbsp;{!RATING_CONTENT}:</td>
					<td class="equation">{POINTS_GAINED_RATING*} &times; {POINTS_RATING*} {!POINTS_UNIT}</td>
					<td class="answer">= {MULT_POINTS_RATING*} {!POINTS_UNIT}</td>
				</tr>
			{+END}
			{+START,IF_PASSED,POINTS_GAINED_CREDITS}{+START,IF_PASSED,POINTS_CREDITS}{+START,IF,{$NEQ,{POINTS_CREDITS},0}}{+START,IF,{$ADDON_INSTALLED,composr_homesite_support_credits}}
				<tr>
					<td>&bull;&nbsp;{!SPECIAL_CPF__cms_support_credits}:</td>
					<td class="equation">{POINTS_GAINED_CREDITS*} &times; {POINTS_CREDITS*} {!POINTS_UNIT}</td>
					<td class="answer">= {MULT_POINTS_CREDITS*} {!POINTS_UNIT}</td>
				</tr>
			{+END}{+END}{+END}{+END}
		</tbody>
	</table>
</div>

{+START,IF_NON_EMPTY,{TO}}
	<p>{!POINTS_IN_ADDITION,{$DISPLAYED_USERNAME*,{USERNAME}},{POINTS_GAINED_GIVEN*}}</p>
{+END}

<h2>{!POINTS_RECEIVED}</h2>

{+START,IF_NON_EMPTY,{TO}}
	{$SET,ajax_points_profile_to_wrapper,ajax-points-profile-to-wrapper-{$RAND%}}
	<div id="{$GET*,ajax_points_profile_to_wrapper}">
		{TO}
	</div>
{+END}
{+START,IF_EMPTY,{TO}}
	<p class="nothing-here">{!NONE}</p>
{+END}

{+START,IF_NON_EMPTY,{GIVE}}
	<div class="box box---points-profile"><div class="box-inner">
		{GIVE}
	</div></div>
{+END}

{+START,IF_NON_EMPTY,{FROM}}
	<h2>{!POINTS_GIFTED}</h2>

	<p>{!_POINTS_GIFTED,{$DISPLAYED_USERNAME*,{USERNAME}},{GIFT_POINTS_USED*}}</p>

	{$SET,ajax_points_profile_from_wrapper,ajax-points-profile-from-wrapper-{$RAND%}}
	<div id="{$GET*,ajax_points_profile_from_wrapper}">
		{FROM}
	</div>
{+END}

{+START,IF_NON_EMPTY,{CHARGELOG_DETAILS}}
	<h2>{!POINTS_SPENT}</h2>

	<p>{!_POINTS_SPENT,{$DISPLAYED_USERNAME*,{USERNAME}},{POINTS_USED*}}</p>

	{$SET,ajax_points_profile_chargelog_wrapper,ajax-points-profile-chargelog-wrapper-{$RAND%}}
	<div id="{$GET*,ajax_points_profile_chargelog_wrapper}">
		{CHARGELOG_DETAILS}
	</div>
{+END}
