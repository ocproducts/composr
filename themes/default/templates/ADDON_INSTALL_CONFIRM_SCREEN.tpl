<div data-view="AddonInstallConfirmScreen">
{TITLE}

{WARNINGS}

<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div class="box box___addon_install_confirm_screen"><div class="box-inner">
		<h2>{!ADDON_FILES}</h2>

		<div class="not-too-tall">
			<ul class="tick_list">
				{FILES}
			</ul>
		</div>
	</div></div>

	<p class="proceed_button">
		<input class="button_screen buttons--back" data-cms-btn-go-back="1" type="button" value="{!GO_BACK}" />

		<input data-disable-on-click="1" class="button_screen buttons--proceed" type="submit" value="{!PROCEED}" />
	</p>

	<h2>{!DETAILS}</h2>

	<div class="wide-table-wrap"><table class="map_table results-table wide-table autosized-table responsive-table">
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
					<td><div class="whitespace-visible">{COPYRIGHT_ATTRIBUTION*}</div></td>
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
</div>
