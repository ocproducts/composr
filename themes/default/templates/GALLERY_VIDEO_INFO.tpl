<div class="wide_table_wrap"><table class="columned_table results_table wide_table">
	{+START,IF,{$NOT,{$MOBILE}}}
		<colgroup>
			<col class="gallery_entry_field_name_column" />
			<col class="gallery_entry_field_value_column" />
		</colgroup>
	{+END}

	<tbody>
		<tr>
			<th class="de_th meta_data_title">{!RESOLUTION}</th>
			<td class="de_th meta_data_title">{WIDTH*} &times; {HEIGHT*}</td>
		</tr>
		<tr>
			<th class="de_th meta_data_title">{!VIDEO_LENGTH}</th>
			<td class="de_th meta_data_title">{$TIME_PERIOD*,{LENGTH}}</td>
		</tr>
	</tbody>
</table></div>
