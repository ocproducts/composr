{TITLE}

{WARNINGS}

<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div class="box box___addon_install_confirm_screen"><div class="box_inner">
		<h2>{!ADDON_FILES}</h2>

		<div class="not_too_tall">
			<ul class="tick_list">
				{FILES}
			</ul>
		</div>
	</div></div>

	<p class="proceed_button">
		{+START,IF,{$JS_ON}}
			<input class="button_screen buttons__back" type="button" onclick="history.back(); return false;" value="{!GO_BACK}" />
		{+END}

		<input onclick="disable_button_just_clicked(this);" class="button_screen buttons__proceed" type="submit" value="{!PROCEED}" />
	</p>

	<h2>{!DETAILS}</h2>

	<div class="wide_table_wrap"><table class="map_table results_table wide_table autosized_table">
		<tbody>
			<tr>
				<th>{!NAME}</th>
				<td>{NAME*}</td>
			</tr>
			<tr>
				<th>{!AUTHOR}</th>
				<td>{AUTHOR*}</td>
			</tr>
			<tr>
				<th>{!ORGANISATION}</th>
				<td>{ORGANISATION*}</td>
			</tr>
			{+START,IF_NON_EMPTY,{COPYRIGHT_ATTRIBUTION}}
				<tr>
					<th>{!COPYRIGHT_ATTRIBUTION}</th>
					<td><div class="whitespace_visible">{COPYRIGHT_ATTRIBUTION*}</div></td>
				</tr>
			{+END}
			<tr>
				<th>{!LICENCE}</th>
				<td>{LICENCE*}</td>
			</tr>
			<tr>
				<th>{!VERSION}</th>
				<td>{VERSION*}</td>
			</tr>
			<tr>
				<th>{!DESCRIPTION}</th>
				<td>{DESCRIPTION}</td>
			</tr>
			<tr>
				<th>{!CATEGORY}</th>
				<td>{CATEGORY*}</td>
			</tr>
		</tbody>
	</table></div>

	<input type="hidden" name="file" value="{FILE*}" />
</form>
