{+START,IF_NON_EMPTY,{$USER_FB_CONNECT,{MEMBER_ID}}}
	<div class="wide_table_wrap">
		<table class="map_table wide_table cns_profile_fields">
			{+START,IF,{$NOT,{$MOBILE}}}
				<colgroup>
					<col class="cns_profile_about_field_name_column" />
					<col class="cns_profile_about_field_value_column" />
				</colgroup>
			{+END}

			<tbody>
				<tr>
					<th class="de_th">Facebook:</th>
					<td>
						<a rel="me" target="_blank" title="{$USERNAME*,{MEMBER_ID},1}'s Facebook {!LINK_NEW_WINDOW}" href="http://www.facebook.com/profile.php?app_scoped_user_id={$USER_FB_CONNECT*,{MEMBER_ID}}"><img alt="Facebook" src="{$IMG*,icons/24x24/links/facebook}" srcset="{$IMG*,icons/48x48/links/facebook} 2x" /></a>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
{+END}
