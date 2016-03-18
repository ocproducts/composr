{+START,IF,{GIVE_CONTEXT}}
<div class="box"><div class="box_inner">
{+END}
{+START,IF,{$NOT,{GIVE_CONTEXT}}}
<div class="cns_member_box">
{+END}
	{+START,IF,{GIVE_CONTEXT}}
		<h3>{!CONTENT_IS_OF_TYPE,{!MEMBER},{$USERNAME*,{MEMBER_ID},1}}</h3>
	{+END}

	<div class="inline_lined_up">
		{+START,IF,{$NOT,{$MOBILE}}}
			{+START,IF_NON_EMPTY,{AVATAR_URL}}
				<img class="cns_member_box_avatar" src="{$ENSURE_PROTOCOL_SUITABILITY*,{AVATAR_URL}}" alt="{!SPECIFIC_AVATAR,{$USERNAME*,{MEMBER_ID}}}" title="{!SPECIFIC_AVATAR,{$USERNAME*,{MEMBER_ID}}}" />
			{+END}
		{+END}

		<div>{$,div will be set as inline block}<table class="map_table tooltip_fields autosized_table">
			<tbody>
				<tr><th class="de_th">{!USERNAME}:</th><td><a href="{$MEMBER_PROFILE_URL*,{MEMBER_ID}}">{$USERNAME*,{MEMBER_ID}}</a></td></tr>
				<tr><th class="de_th">{!cns:SPECIFIC_FORUM_POSTS}:</th><td>{POSTS*}</td></tr>
				{+START,IF_NON_EMPTY,{POINTS}}
					<tr><th class="de_th"><abbr title="{!LIFETIME_POINTS,{$NUMBER_FORMAT*,{$AVAILABLE_POINTS,{MEMBER_ID}}}}">{!POINTS}</abbr>:</th><td>{POINTS*}</td></tr>
				{+END}
				<tr><th class="de_th">{!JOINED}:</th><td>{JOIN_DATE*}</td></tr>
				{+START,IF,{$NOT,{$MATCH_KEY_MATCH,_WILD:galleries}}}
					{+START,IF_PASSED,IP_ADDRESS}
						<tr><th class="de_th">{!IP_ADDRESS}:</th><td>{$TRUNCATE_LEFT,{IP_ADDRESS},15,1}</td></tr>
					{+END}
					{+START,IF_PASSED,WARNINGS}
						<tr><th class="de_th">{!MODULE_TRANS_NAME_warnings}:</th><td>{WARNINGS*}</td></tr>
					{+END}
					{+START,IF_PASSED,GALLERIES}
						<tr><th class="de_th">{!galleries:GALLERIES}:</th><td>{GALLERIES*}</td></tr>
					{+END}
					{+START,IF_PASSED,DATE_OF_BIRTH}
						<tr><th class="de_th">{!DATE_OF_BIRTH}:</th><td>{DATE_OF_BIRTH*}</td></tr>
					{+END}
				{+END}
				<tr>
					<th class="de_th">{!USERGROUPS}:</th>
					<td>{+START,LOOP,OTHER_USERGROUPS}{+START,IF,{$NEQ,{_loop_key},0}}, {+END}{_loop_var*}{+END}</td>
				</tr>
				<tr><th class="de_th">{!ONLINE_NOW}:</th><td>{$?*,{ONLINE},{!YES},{!NO}}</td></tr>
				{CUSTOM_FIELDS}
			</tbody>
		</table></div>
	</div>
{+START,IF,{$NOT,{GIVE_CONTEXT}}}
</div>
{+END}
{+START,IF,{GIVE_CONTEXT}}
</div></div>
{+END}
