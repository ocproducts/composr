{TITLE}

{+START,IF_PASSED,PRICE}
	<p>
		{!COST}: <strong>{PRICE}</strong>
	</p>
{+END}
{+START,IF_PASSED,TEXT}
	{$PARAGRAPH,{TEXT}}
{+END}

<form method="post" enctype="multipart/form-data" action="{$PAGE_LINK*,_SELF:_SELF:uploading=1}">
	{$INSERT_SPAMMER_BLACKHOLE}

	 <div class="wide_table_wrap"><table class="map_table autosized_table results_table wide_table"><tbody>
		  <tr>
				<th>{!NAME}</th>
				<td><label class="accessibility_hidden" for="name">{!NAME}</label><input type="text" size="20" name="name" id="name" value="{+START,IF_PASSED,ITEM}{ITEM*}{+END}" /></td>
				<td>{!W_EG_ITEM_NAME}</td>
		  </tr>
		  <tr>
				<th>{!DESCRIPTION}</th>
				<td><label class="accessibility_hidden" for="description">{!DESCRIPTION}</label><input type="text" size="20" name="description" id="description" value="{DESCRIPTION*}" /></td>
				<td>{!W_EG_ITEM_DESCRIPTION}</td>
		  </tr>
		  <tr>
				<th>{!W_BRIBABLE}</th>
				<td>
					<label class="accessibility_hidden" for="bribable">{!W_BRIBABLE}</label>
					{+START,IF,{BRIBABLE}}
						<input type="checkbox" name="bribable" id="bribable" value="1" checked="checked" />
					{+END}
					{+START,IF,{$NOT,{BRIBABLE}}}
						<input type="checkbox" name="bribable" id="bribable" value="1" />
					{+END}
				</td>
				<td>{!W_EG_BRIBABLE}</td>
		  </tr>
		  <tr>
				<th>{!W_HEALTHY}</th>
				<td>
					<label class="accessibility_hidden" for="healthy">{!W_HEALTHY}</label>
					{+START,IF,{HEALTHY}}
						<input type="checkbox" name="healthy" id="healthy" value="1" checked="checked" />
					{+END}
					{+START,IF,{$NOT,{HEALTHY}}}
						<input type="checkbox" name="healthy" id="healthy" value="1" />
					{+END}
				</td>
				<td>{!W_EG_HEALTHY}</td>
		  </tr>
		  <tr>
				<th>{!W_PICTURE}</th>
				<td><label class="accessibility_hidden" for="pic">{!W_PICTURE}</label><input type="file" size="20" name="pic" id="pic" /></td>
				<td>{!W_EG_ROOM_PICTURE}</td>
		  </tr>
		  <tr>
				<th>{!URL}</th>
				<td><label class="accessibility_hidden" for="url">{!URL}</label><input type="text" size="20" name="url" id="url" value="{PICTURE_URL*}" /></td>
				<td>{!DESCRIPTION_ALTERNATE_URL}</td>
		  </tr>
		  {+START,IF_PASSED,OWNER}
			  <tr>
					<th>{!OWNER}</th>
					<td><label class="accessibility_hidden" for="new_owner">{!OWNER}</label><input type="text" size="20" name="new_owner" id="new_owner" value="{OWNER*}" /></td>
					<td>{!W_EG_OWNER}</td>
			  </tr>
		  {+END}
		  <tr>
				<th>{!W_MAXIMUM_PER_PLAYER}</th>
				<td><label class="accessibility_hidden" for="max_per_player">{!W_MAXIMUM_PER_PLAYER}</label><input type="text" size="20" name="max_per_player" id="max_per_player" value="{MAX_PER_PLAYER*}" /></td>
				<td>{!W_EG_MAXIMUM_PER_PLAYER}</td>
		  </tr>
		  <tr>
				<th>{!W_REPLICATEABLE}</th>
				<td>
					<label class="accessibility_hidden" for="replicateable">{!W_REPLICATEABLE}</label>
					{+START,IF,{REPLICATEABLE}}
						<input type="checkbox" name="replicateable" id="replicateable" value="1" checked="checked" />
					{+END}
					{+START,IF,{$NOT,{REPLICATEABLE}}}
						<input type="checkbox" name="replicateable" id="replicateable" value="1" />
					{+END}
				</td>
				<td>{!W_EG_REPLICATEABLE}</td>
		  </tr>
	 </tbody></table></div>

	 <input type="hidden" name="type" value="{PAGE_TYPE*}" />
	 {+START,IF_PASSED,ITEM}
		 <input type="hidden" name="item" value="{ITEM*}" />
	 {+END}

	 <p class="proceed_button">
		 <input class="button_screen buttons__proceed" type="submit" value="{!PROCEED}" />
	 </p>
</form>

