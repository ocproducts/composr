{TITLE}

<section class="box"><div class="box_inner">
	<h3>{!NAVIGATION}</h3>

	<section class="box box__realm_main"><div class="box_inner">
		<h3>&ldquo;{REALM_NAME*}&rdquo;, &lsquo;{ROOM_NAME*}&rsquo;, <kbd>{REALM*}:{X*}:{Y*}</kbd></h3>

		<div class="ocw_navigation">
			<p class="accessibility_hidden">
				{!W_MOVEMENT_TABLE}
			</p>

			<table class="results_table">
				<thead>
					<tr>
						<th colspan="3" style="text-align: center">
							{!NAVIGATION}
						</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<div style="text-align: center">
								{+START,IF,{HAS_UP_ROOM}}
									<div>
										&uarr;<br />
										<form target="_self" class="inline" method="post" action="{$PAGE_LINK*,_SELF:_SELF}">{$INSERT_SPAMMER_BLACKHOLE}<input type="hidden" name="type" value="up" /><input class="button_hyperlink" type="submit" value="{UP_ROOM}" /></form>
									</div>
								{+END}
								{+START,IF,{$NOT,{HAS_UP_ROOM}}}
									<div class="ocw_fadedtext">
										&uarr;<br />
										<em>{!W_NO_ROOM}</em>
									</div>
								{+END}
							</div>
						</td>
						<td>
							&nbsp;
						</td>
					</tr>
					<tr>
						<td>
							{+START,IF,{HAS_LEFT_ROOM}}
								<div style="text-align: right">
									&larr;&nbsp;<form target="_self" class="inline" method="post" action="{$PAGE_LINK*,_SELF:_SELF}">{$INSERT_SPAMMER_BLACKHOLE}<input type="hidden" name="type" value="left" /><input class="button_hyperlink" type="submit" value="{LEFT_ROOM}" /></form>
								</div>
							{+END}
							{+START,IF,{$NOT,{HAS_LEFT_ROOM}}}
								<div style="text-align: right" class="ocw_fadedtext">
									&larr;&nbsp;<em>{!W_NO_ROOM}</em>
								</div>
							{+END}
						</td>
						<td>
							&nbsp;
						</td>
						<td>
							{+START,IF,{HAS_RIGHT_ROOM}}
								<div style="text-align: left">
									&nbsp;<form target="_self" class="inline" method="post" action="{$PAGE_LINK*,_SELF:_SELF}">{$INSERT_SPAMMER_BLACKHOLE}<input type="hidden" name="type" value="right" /><input class="button_hyperlink" type="submit" value="{RIGHT_ROOM}" /></form>&nbsp;&rarr;
								</div>
							{+END}
							{+START,IF,{$NOT,{HAS_RIGHT_ROOM}}}
								<div style="text-align: left" class="ocw_fadedtext">
									&nbsp;<em>{!W_NO_ROOM}</em>&nbsp;&rarr;
								</div>
							{+END}
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<div style="text-align: center">
								{+START,IF,{HAS_DOWN_ROOM}}
								<div>
									<form target="_self" class="inline" method="post" action="{$PAGE_LINK*,_SELF:_SELF}">{$INSERT_SPAMMER_BLACKHOLE}<input type="hidden" name="type" value="down" /><input class="button_hyperlink" type="submit" value="{DOWN_ROOM}" /></form><br />
									<div class="ocw_arrow">
										&darr;
									</div>
								</div>
								{+END}
								{+START,IF,{$NOT,{HAS_DOWN_ROOM}}}
								<div class="ocw_fadedtext">
									<em>{!W_NO_ROOM}</em><br />
									<div class="ocw_arrow">
										&darr;
									</div>
								</div>
								{+END}
							</div>
						</td>
						<td>
							&nbsp;
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="ocw_room_info">
			<p>
				<em>{ROOM_TEXT}</em>
			</p>
			{+START,IF_NON_EMPTY,{PIC_URL}}
				<img alt="{!W_ROOM_PICTURE}" style="{WIDTH*}" src="{PIC_URL*}" />
			{+END}

			{+START,IF_NON_EMPTY,{PORTALS}}
				<h3>{!W_PORTALS}</h3>

				{PORTALS}
			{+END}
		</div>
	</div></section>
</div></section>

<br />

<section class="box box__room_info"><div class="box_inner">
	<h3>{!W_ROOM_INFORMATION}</h3>

	<div class="float_surrounder">
		<div class="ocw_room_chat results_table">
			<div class="ocw_posttop">{!MESSAGES}</div>
			<div>
				<iframe{$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"} title="{!MESSAGES}" src="{$FIND_SCRIPT*,wmessages}{$KEEP*,1}">{!MESSAGES}</iframe> {EMOTICON_CHOOSER}
			</div>
			<form method="post" id="posting_form" action="{$PAGE_LINK*,_SELF:_SELF}">
				{$INSERT_SPAMMER_BLACKHOLE}

				<div><input id="post" name="post" value="" type="text" /> <input name="type" type="hidden" value="message" /> <select name="tmember" size="1">
					<option value="0">
						{!W_EVERYONE}
					</option>
				</select> <input class="buttons__send button_screen_item" type="submit" value="{!SEND_MESSAGE}" /></div>
			</form>
		</div>

		<div class="ocw_in_room">
			<div class="wide_table_wrap">
				<table class="columned_table wide_table results_table autosized_table">
					<thead>
						<tr>
							<th colspan="3" class="ocw_posttop">
								{!W_MEMBERS_IN_ROOM}
							</th>
						</tr>
						<tr>
							<th>
								{!NAME}
							</th>
							<th>
								{!W_HEALTH}
							</th>
							<th>
								{!W_INVENTORY}
							</th>
						</tr>
					</thead>
					{MEMBERS}
				</table>
			</div>
		</div>
	</div>

	{+START,IF_NON_EMPTY,{ITEMS}{ITEMS_SALE}}
		<div class="float_surrounder">
			{+START,IF_NON_EMPTY,{ITEMS}}
				<br />

				<table class="columned_table ocw_centered_contents wide_table results_table">
					<thead>
						<tr>
							<th colspan="2" class="ocw_posttop">
								{!W_ITEMS_IN_ROOM}
							</th>
						</tr>
						<tr>
							<th>
								{!NAME}
							</th>
							<th>
								{!OPTIONS}
							</th>
						</tr>
					</thead>
					{ITEMS}
				</table>
			{+END}

			{+START,IF_NON_EMPTY,{ITEMS_SALE}}
				<br />

				<table class="columned_table ocw_centered_contents wide_table results_table">
					<thead>
						<tr>
							<th colspan="3" class="ocw_posttop">
								{!W_ITEMS_FOR_SALE_IN_ROOM}
							</th>
						</tr>
						<tr>
							<th>
								{!NAME}
							</th>
							<th>
								{!COST}
							</th>
							<th>
								{!OPTIONS}
							</th>
						</tr>
					</thead>
					{ITEMS_SALE}
				</table>
			{+END}
		</div>
	{+END}
</div></section>

<br />

<div class="ocw_centered_contents">
	<section class="box"><div class="box_inner">
		<h3>{!W_TOOLS}</h3>

		<div class="ocw_icon" style="width: 14%;">
			<a title="{!W_INVENTORY} {!LINK_NEW_WINDOW}" target="_blank" href="{$PAGE_LINK*,_SELF:_SELF:inventory}"><img alt="{!W_INVENTORY}" src="{$IMG*,buildr/inventory}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:inventory}">{!W_INVENTORY}</a>
		</div>
		<div class="ocw_icon" style="width: 14%;">
			<a title="{!W_MAP} {!LINK_NEW_WINDOW}" target="_blank" href="{$FIND_SCRIPT*,map}{$KEEP*,1,1}"><img alt="{!W_MAP}" src="{$IMG*,buildr/map}" /></a><br /><a href="{$FIND_SCRIPT*,map}{$KEEP*,1,1}">{!W_MAP}</a>
		</div>
		<div class="ocw_icon" style="width: 14%;">
			<a href="{$PAGE_LINK*,_SELF:_SELF:realms}"><img alt="{!W_REALMS}" src="{$IMG*,buildr/realms}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:realms}">{!W_REALMS}</a>
		</div>
		<div class="ocw_icon" style="width: 14%;">
			<a href="{$PAGE_LINK*,_SELF:_SELF}"><img alt="{!W_REFRESH}" src="{$IMG*,buildr/refresh}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF}">{!W_REFRESH}</a>
		</div>
		<div class="ocw_icon" style="width: 14%;">
			<a href="{$PAGE_LINK*,_SELF:_SELF:confirm:btype=emergency}"><img alt="{!W_TELEPORT}" src="{$IMG*,buildr/emergencyteleport}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:emergency}">{!W_TELEPORT}</a>
		</div>
		<div class="ocw_icon" style="width: 14%;">
			<a title="{!RULES} {!LINK_NEW_WINDOW}" target="_blank" href="{$PAGE_LINK*,_SELF:rules}"><img alt="{!RULES}" src="{$IMG*,buildr/rules}" /></a><br /><a href="{$PAGE_LINK*,_SELF:rules}">{!RULES}</a>
		</div>
		<div class="ocw_icon" style="width: 14%;">
			<a title="{!HELP} {!LINK_NEW_WINDOW}" target="_blank" href="{$PAGE_LINK*,_SELF:docs}"><img alt="{!HELP}" src="{$IMG*,buildr/help}" /></a><br /><a href="{$PAGE_LINK*,_SELF:docs}">{!HELP}</a>
		</div>
	</div></section>

	<div class="box box___w_main_screen">
		<h2 class="toggleable_tray_title">
			<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode); set_cookie('hideActions',(this.getElementsByTagName('img')[0].getAttribute('src')=='{$IMG;*,1x/trays/contract}')?'0':'1'); return false;">{!W_ENVIRONMENT_ACTIONS}</a>
			{+START,IF,{$JS_ON}}
				<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode); set_cookie('hideActions',(this.getElementsByTagName('img')[0].getAttribute('src')=='{$IMG;*,1x/trays/contract}')?'0':'1'); return false;"><img alt="{!EXPAND}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand2}" srcset="{$IMG*,2x/trays/expand2} 2x" /></a>
			{+END}
		</h2>

		<div class="toggleable_tray" style="{$JS_ON,{HIDE_ACTIONS*},}"{+START,IF,{HIDE_ACTIONS}} aria-expanded="false"{+END}>
			<table class="columned_table results_table wide_table autosized_table">
				<colgroup>
					<col style="width: 20%" />
					<col style="width: 20%" />
					<col style="width: 20%" />
					<col style="width: 20%" />
					<col style="width: 20%" />
				</colgroup>
				<tr class="ocw_posttop">
					<th>
						{!ACTION}
					</th>
					<th>
						{!W_TARGET_PERSON}
					</th>
					<th>
						{!W_ITEM_INVOLVED}
					</th>
					<th>
						{!W_PARAMETER}
					</th>
					<th>
						{!PROCEED}
					</th>
				</tr>
			</table>
			{+START,IF_NON_EMPTY,{ITEMS_HELD}}
				<form method="post" class="inline" action="{$PAGE_LINK*,_SELF:_SELF}">
					{$INSERT_SPAMMER_BLACKHOLE}

					<table class="columned_table results_table wide_table autosized_table">
						<colgroup>
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
						</colgroup>
						<tr>
							<td>
								{!W_DROP}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								{ITEMS_HELD}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								<input type="hidden" name="type" value="drop" />
								<input class="buttons__proceed button_screen_item" type="submit" value="{!PROCEED}" />
							</td>
						</tr>
					</table>
				</form>
				<form method="post" class="inline" action="{$PAGE_LINK*,_SELF:_SELF}">
					{$INSERT_SPAMMER_BLACKHOLE}

					<table class="columned_table results_table wide_table autosized_table">
						<colgroup>
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
						</colgroup>
						<tr>
							<td>
								{!W_GIVE}
							</td>
							<td>
								{PEOPLE}
							</td>
							<td>
								{ITEMS_HELD}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								<input type="hidden" name="type" value="give" />
								<input class="buttons__proceed button_screen_item" type="submit" value="{!PROCEED}" />
							</td>
						</tr>
					</table>
				</form>
				<form method="post" class="inline" action="{$PAGE_LINK*,_SELF:_SELF:confirm}">
					{$INSERT_SPAMMER_BLACKHOLE}

					<table class="columned_table results_table wide_table autosized_table">
						<colgroup>
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
						</colgroup>
						<tr>
							<td>
								{!W_PICKPOCKET}
							</td>
							<td>
								{PEOPLE}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								<input type="hidden" name="btype" value="pickpocket" />
								<input class="buttons__proceed button_screen_item" type="submit" value="{!PROCEED}" />
							</td>
						</tr>
					</table>
				</form>
				<form method="post" class="inline" action="{$PAGE_LINK*,_SELF:_SELF}">
					{$INSERT_SPAMMER_BLACKHOLE}

					<table class="columned_table results_table wide_table autosized_table">
						<colgroup>
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
						</colgroup>
						<tr>
							<td>
								{!W_USE}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								{ITEMS_HELD}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								<input type="hidden" name="type" value="use" />
								<input class="buttons__proceed button_screen_item" type="submit" value="{!PROCEED}" />
							</td>
						</tr>
					</table>
				</form>
				<form method="post" class="inline" action="{$PAGE_LINK*,_SELF:_SELF:confirm}">
					{$INSERT_SPAMMER_BLACKHOLE}

					<table class="columned_table results_table wide_table autosized_table">
						<colgroup>
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
						</colgroup>
						<tr>
							<td>
								{!W_DELETE_MATCHING_MESSAGES}
							</td>
							<td>
								{PEOPLE}
							</td>
							<td>
								&nbsp;
							</td>
							<td>
								<input type="text" size="20" value="" name="param" />
							</td>
							<td>
								<input type="hidden" name="btype" value="delete-message-by-person" />
								<input class="buttons__proceed button_screen_item" type="submit" value="{!PROCEED}" />
							</td>
						</tr>
					</table>
				</form>
			{+END}
			<form method="post" class="inline" action="{$PAGE_LINK*,_SELF:_SELF}">
				{$INSERT_SPAMMER_BLACKHOLE}

				<table class="columned_table results_table wide_table autosized_table">
					<colgroup>
						<col style="width: 20%" />
						<col style="width: 20%" />
						<col style="width: 20%" />
						<col style="width: 20%" />
						<col style="width: 20%" />
					</colgroup>
					<tr>
						<td>
							{!W_FIND_PERSON}
						</td>
						<td>
							{PEOPLE}
						</td>
						<td>
							{!NA}
						</td>
						<td>
							<input type="text" size="20" value="" name="param" />
						</td>
						<td>
							<input type="hidden" name="type" value="findperson" />
							<input class="buttons__proceed button_screen_item" type="submit" value="{!PROCEED}" />
						</td>
					</tr>
				</table>
			</form>
			{+START,IF,{IS_STAFF}}
				<table class="columned_table results_table wide_table">
					<tr>
						<td colspan="5">
							&nbsp;
						</td>
					</tr>
				</table>
				<form method="post" class="inline" action="{$PAGE_LINK*,_SELF:_SELF}">
					{$INSERT_SPAMMER_BLACKHOLE}

					<table class="columned_table results_table wide_table autosized_table">
						<colgroup>
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
						</colgroup>
						<tr>
							<td>
								{!W_TELEPORT_PERSON}
							</td>
							<td>
								{PEOPLE}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								<input type="text" size="20" value="" name="param" />
							</td>
							<td>
								<input type="hidden" name="type" value="teleport-person" />
								<input class="buttons__proceed button_screen_item" type="submit" value="{!PROCEED}" />
							</td>
						</tr>
					</table>
				</form>
				<form method="post" class="inline" action="{$PAGE_LINK*,_SELF:_SELF}">
					{$INSERT_SPAMMER_BLACKHOLE}

					<table class="columned_table results_table wide_table autosized_table">
						<colgroup>
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
						</colgroup>
						<tr>
							<td>
								{!W_IMPRISON_PERSON}
							</td>
							<td>
								{PEOPLE}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								<input type="hidden" name="type" value="imprison-person" />
								<input class="buttons__proceed button_screen_item" type="submit" value="{!PROCEED}" />
							</td>
						</tr>
					</table>
				</form>
				<form method="post" class="inline" action="{$PAGE_LINK*,_SELF:_SELF}">
					{$INSERT_SPAMMER_BLACKHOLE}

					<table class="columned_table results_table wide_table autosized_table">
						<colgroup>
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
						</colgroup>
						<tr>
							<td>
								{!W_HURT_PERSON}
							</td>
							<td>
								{PEOPLE}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								<input type="hidden" name="type" value="hurt-person" />
								<input class="buttons__proceed button_screen_item" type="submit" value="{!PROCEED}" />
							</td>
						</tr>
					</table>
				</form>
				<form method="post" class="inline" action="{$PAGE_LINK*,_SELF:_SELF}">
					{$INSERT_SPAMMER_BLACKHOLE}

					<table class="columned_table results_table wide_table autosized_table">
						<colgroup>
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
						</colgroup>
						<tr>
							<td>
								{!W_HEAL_PERSON}
							</td>
							<td>
								{PEOPLE}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								<input type="hidden" name="type" value="dehurt-person" />
								<input class="buttons__proceed button_screen_item" type="submit" value="{!PROCEED}" />
							</td>
						</tr>
					</table>
				</form>
				<form method="post" class="inline" action="{$PAGE_LINK*,_SELF:_SELF}">
					{$INSERT_SPAMMER_BLACKHOLE}

					<table class="columned_table results_table wide_table autosized_table">
						<colgroup>
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
						</colgroup>
						<tr>
							<td>
								{!W_BAN_PERSON}
							</td>
							<td>
								{PEOPLE}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								<input type="hidden" name="type" value="ban-person" />
								<input class="buttons__proceed button_screen_item" type="submit" value="{!PROCEED}" />
							</td>
						</tr>
					</table>
				</form>
				<form method="post" class="inline" action="{$PAGE_LINK*,_SELF:_SELF}">
					{$INSERT_SPAMMER_BLACKHOLE}

					<table class="columned_table results_table wide_table autosized_table">
						<colgroup>
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
						</colgroup>
						<tr>
							<td>
								{!W_UNBAN_PERSON}
							</td>
							<td>
								{PEOPLE}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								<input type="hidden" name="type" value="unban-person" />
								<input class="buttons__proceed button_screen_item" type="submit" value="{!PROCEED}" />
							</td>
						</tr>
					</table>
				</form>
				<form method="post" class="inline" action="{$PAGE_LINK*,_SELF:_SELF}">
					{$INSERT_SPAMMER_BLACKHOLE}

					<table class="columned_table results_table wide_table autosized_table">
						<colgroup>
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
						</colgroup>
						<tr>
							<td>
								{!W_TAKE_FROM_PERSON}
							</td>
							<td>
								{PEOPLE}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								{!NA}
							</td>
							<td>
								<input type="hidden" name="type" value="take-from-person" />
								<input class="buttons__proceed button_screen_item" type="submit" value="{!PROCEED}" />
							</td>
						</tr>
					</table>
				</form>
			{+END}
		</div>
	</div>

	{+START,IF,{MAY_DO_STUFF}}
		<div class="box box___w_main_screen">
			<h2 class="toggleable_tray_title">
				<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode); set_cookie('hideAdditions',(this.getElementsByTagName('img')[0].getAttribute('src')=='{$IMG;*,1x/trays/contract}')?'0':'1'); return false;">{!W_ENVIRONMENT_ADDITIONS}</a>
				{+START,IF,{$JS_ON}}
					<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode); set_cookie('hideAdditions',(this.getElementsByTagName('img')[0].getAttribute('src')=='{$IMG;*,1x/trays/contract}')?'0':'1'); return false;"><img alt="{!EXPAND}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand2}" srcset="{$IMG*,2x/trays/expand2} 2x" /></a>
				{+END}
			</h2>

			<div class="toggleable_tray" style="{$JS_ON,{HIDE_ADDITIONS*},}"{+START,IF,{HIDE_ADDITIONS}} aria-expanded="false"{+END}>
				<div class="float_surrounder">
					<div class="ocw_icon" style="width: {$?,{MAY_ADD_PORTAL},20%,25%};">
						<a href="{$PAGE_LINK*,_SELF:_SELF:addrealm}"><img alt="{!W_ADD_REALM}" src="{$IMG*,buildr/realms}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:addrealm}">{!W_ADD_REALM}</a>
					</div>
					<div class="ocw_icon" style="width: {$?,{MAY_ADD_PORTAL},20%,25%};">
						<a href="{$PAGE_LINK*,_SELF:_SELF:addroom}"><img alt="{!W_ADD_ADJOINING_ROOM}" src="{$IMG*,buildr/addroom}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:addroom}">{!W_ADD_ADJOINING_ROOM}</a>
					</div>
					{+START,IF,{MAY_ADD_PORTAL}}
					<div class="ocw_icon" style="width: {$?,{MAY_ADD_PORTAL},20%,25%};">
						<a href="{$PAGE_LINK*,_SELF:_SELF:addportal}"><img alt="{!W_ADD_PORTAL}" src="{$IMG*,buildr/addportal}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:addportal}">{!W_ADD_PORTAL}</a>
					</div>
					{+END}
					<div class="ocw_icon" style="width: {$?,{MAY_ADD_PORTAL},20%,25%};">
						<a href="{$PAGE_LINK*,_SELF:_SELF:additem}"><img alt="{!W_ADD_ITEM}" src="{$IMG*,buildr/additem}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:additem}">{!W_ADD_ITEM}</a>
					</div>
					<div class="ocw_icon" style="width: {$?,{MAY_ADD_PORTAL},20%,25%};">
						<a href="{$PAGE_LINK*,_SELF:_SELF:additemcopy}"><img alt="{!W_ADD_ITEM_COPY}" src="{$IMG*,buildr/additemcopy}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:additemcopy}">{!W_ADD_ITEM_COPY}</a>
					</div>
				</div>
			</div>
		</div>
	{+END}

	<div class="box box___w_main_screen">
		<h2 class="toggleable_tray_title">
			<a class="toggleable_tray_button" href="#" onclick="toggleable_tray(this.parentNode.parentNode); set_cookie('hideMod',(this.getElementsByTagName('img')[0].getAttribute('src')=='{$IMG;*,1x/trays/contract}')?'0':'1'); return false;">{!W_ENVIRONMENT_MODIFICATIONS}</a>
			{+START,IF,{$JS_ON}}
				<a class="toggleable_tray_button" href="#" onclick="toggleable_tray(this.parentNode.parentNode); set_cookie('hideMod',(this.getElementsByTagName('img')[0].getAttribute('src')=='{$IMG;*,1x/trays/contract}')?'0':'1'); return false;"><img alt="{!EXPAND}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand2}" srcset="{$IMG*,2x/trays/expand2} 2x" /></a>
			{+END}
		</h2>

		<div class="toggleable_tray" style="{$JS_ON,{HIDE_MODIFICATIONS*},}"{+START,IF,{HIDE_MODIFICATIONS}} aria-expanded="false"{+END}>
			{+START,IF_NON_EMPTY,{ITEMS_OWNED}}
				<form method="post" action="{$PAGE_LINK*,_SELF:_SELF}"><div>
					{$INSERT_SPAMMER_BLACKHOLE}

					<label for="item">{!W_ITEMS}</label>: {ITEMS_OWNED} <input type="hidden" name="type" value="edititem" /> <input class="buttons__edit button_screen_item" type="submit" value="{!W_EDIT_ITEM}" onclick="form.elements['type']='edititem';" /> <input class="menu___generic_admin__delete button_screen_item" type="submit" value="{!W_DELETE_ITEM}" onclick="form.elements['type']='confirm';" />
				</div></form>

				{+START,IF,{IS_STAFF}}
					<form method="post" action="{$PAGE_LINK*,_SELF:_SELF}"><div>
						{$INSERT_SPAMMER_BLACKHOLE}

						<label for="item">{!FROM}</label>: {ITEMS_OWNED} <label for="item2">{!TO}</label>: {ITEMS_OWNED_2} <input type="hidden" name="type" value="mergeitems" /> <input class="menu___generic_admin__merge button_screen_item" type="submit" value="{!W_MERGE_ITEMS}" />
					</div></form>
				{+END}
			{+END}

			{+START,IF,{$OR,{$IS_NON_EMPTY,{IS_ROOM_OWNER}},{$IS_NON_EMPTY,{IS_REALM_OWNER}}}}
				<br />
				<div class="float_surrounder">
					{+START,IF,{IS_ROOM_OWNER}}
						<div class="ocw_icon" style="width: {$?,{IS_REALM_OWNER},25%,50%};">
							<a href="{$PAGE_LINK*,_SELF:_SELF:editroom}"><img alt="{!W_EDIT_ROOM}" src="{$IMG*,buildr/addroom}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:editroom}">{!W_EDIT_ROOM}</a>
						</div>
						<div class="ocw_icon" style="width: {$?,{IS_REALM_OWNER},25%,50%};">
							<a href="{$PAGE_LINK*,_SELF:_SELF:confirm:btype=deleteroom}"><img alt="{!W_DELETE_ROOM}" src="{$IMG*,buildr/delroom}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:deleteroom}">{!W_DELETE_ROOM}</a>
						</div>
					{+END}
					{+START,IF,{IS_REALM_OWNER}}
						<div class="ocw_icon" style="width: {$?,{IS_ROOM_OWNER},25%,50%};">
							<a href="{$PAGE_LINK*,_SELF:_SELF:editrealm}"><img alt="{!W_EDIT_REALM}" src="{$IMG*,buildr/realms}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:editrealm}">{!W_EDIT_REALM}</a>
						</div>
						<div class="ocw_icon" style="width: {$?,{IS_ROOM_OWNER},25%,50%};">
							<a href="{$PAGE_LINK*,_SELF:_SELF:confirm:btype=deleterealm}"><img alt="{!W_DELETE_REALM}" src="{$IMG*,buildr/delrealm}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:deleterealm}">{!W_DELETE_REALM}</a>
						</div>
					{+END}
				</div>
			{+END}
		</div>
	</div>
</div>
