<div class="wide-table-wrap"><table class="columned_table results-table wide-table">
	{+START,IF,{$DESKTOP}}
		<colgroup>
			<col class="gallery-entry-field-name-column" />
			<col class="gallery_entry_field_value_column" />
		</colgroup>
	{+END}

	<tbody>
		<tr>
			<th class="de-th metadata_title">{!RESOLUTION}</th>
			<td class="de-th metadata_title">{WIDTH*} &times; {HEIGHT*}</td>
		</tr>
		<tr>
			<th class="de-th metadata_title">{!VIDEO_LENGTH}</th>
			<td class="de-th metadata_title">{$TIME_PERIOD*,{LENGTH}}</td>
		</tr>
	</tbody>
</table></div>
