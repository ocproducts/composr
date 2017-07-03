{TITLE}

{+START,IF_PASSED,PRICE}
	<p>
		{!COST}: <strong>{PRICE}</strong>
	</p>
{+END}
{+START,IF_PASSED,TEXT}
	{$PARAGRAPH,{TEXT}}
{+END}

<form method="post" enctype="multipart/form-data" action="{$PAGE_LINK*,_SELF:_SELF:uploading=1}" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div class="wide_table_wrap"><table class="map_table autosized_table results_table wide_table responsive_blocked_table"><tbody>
		<tr>
			<th>{!NAME}</th>
			<td><label class="accessibility_hidden" for="name">{!NAME}</label><input type="text" size="20" name="name" id="name" value="{NAME*}" /></td>
			<td>{!W_EG_REALM_NAME}</td>
		</tr>
		<tr>
			<th>{!W_REALM_TROLL_NAME}</th>
			<td><label class="accessibility_hidden" for="troll_name">{!W_REALM_TROLL_NAME}</label><input type="text" size="20" name="troll_name" id="troll_name" value="{TROLL_NAME*}" /></td>
			<td>{!W_EG_REALM_TROLL_NAME}</td>
		</tr>
		<tr>
			<th>{!W_PRIVATE_REALM}</th>
			<td>
				<label class="accessibility_hidden" for="private">{!W_PRIVATE_REALM}</label>
				{+START,IF,{PRIVATE}}
					<input type="checkbox" value="1" id="private" name="private" checked="checked" />
				{+END}
				{+START,IF,{$NOT,{PRIVATE}}}
					<input type="checkbox" value="1" id="private" name="private" />
				{+END}
			</td>
			<td>{!W_EG_PRIVATE_REALM}</td>
		</tr>
		{+START,IF_NON_PASSED,OWNER}
			<tr>
				<th>{!W_REALM_JAIL_NAME}</th>
				<td><label class="accessibility_hidden" for="jail_name">{!W_REALM_JAIL_NAME}</label><input type="text" size="20" name="jail_name" id="jail_name" /></td>
				<td>{!W_EG_REALM_JAIL_NAME}</td>
			</tr>
			<tr>
				<th>{!W_REALM_JAIL_TEXT}</th>
				<td><label class="accessibility_hidden" for="jail_text">{!W_REALM_JAIL_TEXT}</label><input type="text" size="20" name="jail_text" id="jail_text" /></td>
				<td>{!W_EG_REALM_JAIL_TEXT}</td>
			</tr>
			<tr>
				<th>{!W_REALM_JAIL_PIC}</th>
				<td><label class="accessibility_hidden" for="jail_pic">{!W_REALM_JAIL_PIC}</label><input type="file" size="20" name="jail_pic" id="jail_pic" /></td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<th>{!ALT_FIELD,{!URL}}</th>
				<td><label class="accessibility_hidden" for="jail_pic_url">{!ALT_FIELD,{!URL}}</label><input type="text" size="20" name="jail_pic_url" id="jail_pic_url" /></td>
				<td>{!DESCRIPTION_ALTERNATE_URL}</td>
			</tr>
			<tr>
				<th>{!W_REALM_JAILHOUSE_NAME}</th>
				<td><label class="accessibility_hidden" for="jail_house_name">{!W_REALM_JAILHOUSE_NAME}</label><input type="text" size="20" name="jail_house_name" id="jail_house_name" /></td>
				<td>{!W_EG_REALM_JAILHOUSE_NAME}</td>
			</tr>
			<tr>
				<th>{!W_REALM_JAILHOUSE_TEXT}</th>
				<td><label class="accessibility_hidden" for="jail_house_text">{!W_REALM_JAILHOUSE_TEXT}</label><input type="text" size="20" name="jail_house_text" id="jail_house_text" /></td>
				<td>{!W_EG_REALM_JAILHOUSE_TEXT}</td>
			</tr>
			<tr>
				<th>{!W_REALM_JAILHOUSE_PIC}</th>
				<td><label class="accessibility_hidden" for="jail_house_pic">{!W_REALM_JAILHOUSE_PIC}</label><input type="file" size="20" name="jail_house_pic" id="jail_house_pic" /></td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<th>{!ALT_FIELD,{!URL}}</th>
				<td><label class="accessibility_hidden" for="jail_house_pic_url">{!ALT_FIELD,{!URL}}</label><input type="text" size="20" name="jail_house_pic_url" id="jail_house_pic_url" /></td>
				<td>{!DESCRIPTION_ALTERNATE_URL}</td>
			</tr>
			<tr>
				<th>{!W_REALM_LOBBY_NAME}</th>
				<td><label class="accessibility_hidden" for="lobby_name">{!W_REALM_LOBBY_NAME}</label><input type="text" size="20" name="lobby_name" id="lobby_name" /></td>
				<td>{!W_EG_REALM_LOBBY_NAME}</td>
			</tr>
			<tr>
				<th>{!W_REALM_LOBBY_TEXT}</th>
				<td><label class="accessibility_hidden" for="lobby_text">{!W_REALM_LOBBY_TEXT}</label><input type="text" size="20" name="lobby_text" id="lobby_text" /></td>
				<td>{!W_EG_REALM_LOBBY_TEXT}</td>
			</tr>
			<tr>
				<th>{!W_REALM_LOBBY_PIC}</th>
				<td><label class="accessibility_hidden" for="lobby_pic">{!W_REALM_LOBBY_PIC}</label><input type="file" size="20" name="lobby_pic" id="lobby_pic" /></td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<th>{!ALT_FIELD,{!URL}}</th>
				<td><label class="accessibility_hidden" for="lobby_pic_url">{!ALT_FIELD,{!URL}}</label><input type="text" size="20" name="lobby_pic_url" id="lobby_pic_url" /></td>
				<td>{!DESCRIPTION_ALTERNATE_URL}</td>
			</tr>
		{+END}
		{+START,IF_PASSED,OWNER}
			<tr>
				<th>{!OWNER}</th>
				<td><label class="accessibility_hidden" for="new_owner">{!OWNER}</label><input type="text" size="20" name="new_owner" id="new_owner" value="{OWNER*}" /></td>
				<td>{!W_EG_OWNER}</td>
			</tr>
		{+END}
	</tbody></table></div>

	<p>{!W_TROLL_QUESTIONS}</p>

	{QA}

	<input type="hidden" name="type" value="{PAGE_TYPE*}" />

	<p class="proceed_button">
		<input class="button_screen buttons__proceed" type="submit" value="{!PROCEED}" />
	</p>
</form>
