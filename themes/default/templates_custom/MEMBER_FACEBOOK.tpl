{+START,IF_NON_EMPTY,{$USER_FB_CONNECT,{MEMBER_ID}}}
	<div class="wide-table-wrap">
		<table class="map-table wide-table cns-profile-fields">
			{+START,IF,{$DESKTOP}}
				<colgroup>
					<col class="cns-profile-about-field-name-column" />
					<col class="cns-profile-about-field-value-column" />
				</colgroup>
			{+END}

			<tbody>
				<tr>
					<th class="de-th">Facebook:</th>
					<td>
						<a rel="me" target="_blank" title="{$USERNAME*,{MEMBER_ID},1}'s Facebook {!LINK_NEW_WINDOW}" href="https://www.facebook.com/app_scoped_user_id/{$USER_FB_CONNECT*,{MEMBER_ID}}"><img alt="Facebook" src="{$IMG*,icons/24x24/links/facebook}" srcset="{$IMG*,icons/48x48/links/facebook} 2x" /></a>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
{+END}
