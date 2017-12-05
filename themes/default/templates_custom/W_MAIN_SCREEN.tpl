{$REQUIRE_JAVASCRIPT,buildr}

<div data-require-javascript="buildr" data-tpl="wMainScreen">
	{TITLE}

	<section class="box box___realm_main"><div class="box_inner">
		<h2>&ldquo;{REALM_NAME*}&rdquo;, &lsquo;{ROOM_NAME*}&rsquo;, <kbd>{REALM*}:{X*}:{Y*}</kbd></h2>

		<div class="buildr_navigation">
			<p class="accessibility_hidden">
				{!W_MOVEMENT_TABLE}
			</p>

			<table class="results_table columned_table">
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
							<div class="head">
								{+START,IF,{HAS_UP_ROOM}}
									<div>
										&uarr;<br />
										<form target="_self" class="inline" method="post" action="{$PAGE_LINK*,_SELF:_SELF}" autocomplete="off">{$INSERT_SPAMMER_BLACKHOLE}<input type="hidden" name="type" value="up" /><input class="button_hyperlink" type="submit" value="{UP_ROOM*}" /></form>
									</div>
								{+END}
								{+START,IF,{$NOT,{HAS_UP_ROOM}}}
									<div class="buildr_fadedtext">
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
									&larr;&nbsp;<form target="_self" class="inline" method="post" action="{$PAGE_LINK*,_SELF:_SELF}" autocomplete="off">{$INSERT_SPAMMER_BLACKHOLE}<input type="hidden" name="type" value="left" /><input class="button_hyperlink" type="submit" value="{LEFT_ROOM*}" /></form>
								</div>
							{+END}
							{+START,IF,{$NOT,{HAS_LEFT_ROOM}}}
								<div style="text-align: right" class="buildr_fadedtext">
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
									&nbsp;<form target="_self" class="inline" method="post" action="{$PAGE_LINK*,_SELF:_SELF}" autocomplete="off">{$INSERT_SPAMMER_BLACKHOLE}<input type="hidden" name="type" value="right" /><input class="button_hyperlink" type="submit" value="{RIGHT_ROOM*}" /></form>&nbsp;&rarr;
								</div>
							{+END}
							{+START,IF,{$NOT,{HAS_RIGHT_ROOM}}}
								<div style="text-align: left" class="buildr_fadedtext">
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
										<form target="_self" class="inline" method="post" action="{$PAGE_LINK*,_SELF:_SELF}" autocomplete="off">{$INSERT_SPAMMER_BLACKHOLE}<input type="hidden" name="type" value="down" /><input class="button_hyperlink" type="submit" value="{DOWN_ROOM*}" /></form><br />
										<div class="buildr_arrow">
											&darr;
										</div>
									</div>
								{+END}
								{+START,IF,{$NOT,{HAS_DOWN_ROOM}}}
									<div class="buildr_fadedtext">
										<em>{!W_NO_ROOM}</em><br />
										<div class="buildr_arrow">
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

		<div class="buildr_room_info">
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

	<br />

	<section class="box box___room_info"><div class="box_inner">
		<h3>{!W_ROOM_INFORMATION}</h3>

		<div class="float-surrounder">
			<div class="buildr_room_chat results_table">
				<h4 class="buildr_posttop">{!MESSAGES}</h4>
				<div>
					<iframe {$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"} title="{!MESSAGES}" src="{$FIND_SCRIPT*,wmessages}{$KEEP*,1}">{!MESSAGES}</iframe> {EMOTICON_CHOOSER}
				</div>
				<form method="post" id="posting_form" action="{$PAGE_LINK*,_SELF:_SELF}" autocomplete="off">
					{$INSERT_SPAMMER_BLACKHOLE}

					<div><input id="post" name="post" type="text" /> <input name="type" type="hidden" value="message" /> <select name="tmember" size="1">
						<option value="0">
							{!W_EVERYONE}
						</option>
					</select> <input class="button_screen_item buttons--send" type="submit" value="{!SEND_MESSAGE}" /></div>
				</form>
			</div>

			<div class="buildr_in_room">
				<h4>{!W_MEMBERS_IN_ROOM}</h4>

				<div class="wide_table_wrap">
					<table class="columned_table wide_table results_table autosized_table responsive-table">
						<thead>
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
			<div class="float-surrounder">
				{+START,IF_NON_EMPTY,{ITEMS}}
					<h4>{!W_ITEMS_IN_ROOM}</h4>

					<table class="columned_table buildr_centered_contents wide_table results_table responsive-table">
						<thead>
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

					<table class="columned_table buildr_centered_contents wide_table results_table responsive-table">
						<thead>
							<tr>
								<th colspan="3" class="buildr_posttop">
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

	<div class="buildr_centered_contents">
		<section class="box"><div class="box_inner buildr_icons_wrap">
			<h3>{!W_TOOLS}</h3>

			<div class="buildr_icon">
				<a title="{!W_INVENTORY} {!LINK_NEW_WINDOW}" target="_blank" href="{$PAGE_LINK*,_SELF:_SELF:inventory}"><img alt="{!W_INVENTORY}" src="{$IMG*,buildr/inventory}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:inventory}">{!W_INVENTORY}</a>
			</div>
			<div class="buildr_icon">
				<a title="{!W_MAP} {!LINK_NEW_WINDOW}" target="_blank" href="{$FIND_SCRIPT*,map}{$KEEP*,1,1}"><img alt="{!W_MAP}" src="{$IMG*,buildr/map}" /></a><br /><a href="{$FIND_SCRIPT*,map}{$KEEP*,1,1}">{!W_MAP}</a>
			</div>
			<div class="buildr_icon">
				<a href="{$PAGE_LINK*,_SELF:_SELF:realms}"><img alt="{!W_REALMS}" src="{$IMG*,buildr/realms}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:realms}">{!W_REALMS}</a>
			</div>
			<div class="buildr_icon">
				<a href="{$PAGE_LINK*,_SELF:_SELF}"><img alt="{!W_REFRESH}" src="{$IMG*,buildr/refresh}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF}">{!W_REFRESH}</a>
			</div>
			<div class="buildr_icon">
				<a href="{$PAGE_LINK*,_SELF:_SELF:confirm:btype=emergency}"><img alt="{!W_TELEPORT}" src="{$IMG*,buildr/emergencyteleport}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:emergency}">{!W_TELEPORT}</a>
			</div>
			<div class="buildr_icon">
				<a title="{!RULES} {!LINK_NEW_WINDOW}" target="_blank" href="{$PAGE_LINK*,_SELF:rules}"><img alt="{!RULES}" src="{$IMG*,buildr/rules}" /></a><br /><a href="{$PAGE_LINK*,_SELF:rules}">{!RULES}</a>
			</div>
			<div class="buildr_icon">
				<a title="{!HELP} {!LINK_NEW_WINDOW}" target="_blank" href="{$PAGE_LINK*,_SELF:docs}"><img alt="{!HELP}" src="{$IMG*,buildr/help}" /></a><br /><a href="{$PAGE_LINK*,_SELF:docs}">{!HELP}</a>
			</div>
		</div></section>

		<div class="box box___w_main_screen" data-toggleable-tray="{}">
			<h2 class="toggleable_tray_title js-tray-header">
				<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{!W_ENVIRONMENT_ACTIONS}</a>
				<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!EXPAND}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand2}" /></a>
			</h2>

			<div class="toggleable_tray js-tray-content" style="{HIDE_ACTIONS*}"{+START,IF,{HIDE_ACTIONS}} aria-expanded="false"{+END}>
				<form method="post" class="inline" action="{$PAGE_LINK*,_SELF:_SELF}" autocomplete="off">
					{$INSERT_SPAMMER_BLACKHOLE}

					<table class="columned_table results_table wide_table autosized_table">
						<colgroup>
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
							<col style="width: 20%" />
						</colgroup>
						<thead>
							<tr class="buildr_posttop">
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
						</thead>
						{+START,IF_NON_EMPTY,{ITEMS_HELD}}
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
									<input class="button_screen_item buttons--proceed" type="submit" value="{!PROCEED}" />
								</td>
							</tr>

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
									<input class="button_screen_item buttons--proceed" type="submit" value="{!PROCEED}" />
								</td>
							</tr>

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
									<input class="button_screen_item buttons--proceed" type="submit" value="{!PROCEED}" />
								</td>
							</tr>

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
									<input class="button_screen_item buttons--proceed" type="submit" value="{!PROCEED}" />
								</td>
							</tr>

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
									<input type="text" size="20" name="param" />
								</td>
								<td>
									<input type="hidden" name="btype" value="delete-message-by-person" />
									<input class="button_screen_item buttons--proceed" type="submit" value="{!PROCEED}" />
								</td>
							</tr>
						{+END}

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
								<input type="text" size="20" name="param" />
							</td>
							<td>
								<input type="hidden" name="type" value="findperson" />
								<input class="button_screen_item buttons--proceed" type="submit" value="{!PROCEED}" />
							</td>
						</tr>

						{+START,IF,{IS_STAFF}}
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
									<input type="text" size="20" name="param" />
								</td>
								<td>
									<input type="hidden" name="type" value="teleport-person" />
									<input class="button_screen_item buttons--proceed" type="submit" value="{!PROCEED}" />
								</td>
							</tr>

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
									<input class="button_screen_item buttons--proceed" type="submit" value="{!PROCEED}" />
								</td>
							</tr>

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
									<input class="button_screen_item buttons--proceed" type="submit" value="{!PROCEED}" />
								</td>
							</tr>

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
									<input class="button_screen_item buttons--proceed" type="submit" value="{!PROCEED}" />
								</td>
							</tr>

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
									<input class="button_screen_item buttons--proceed" type="submit" value="{!PROCEED}" />
								</td>
							</tr>

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
									<input class="button_screen_item buttons--proceed" type="submit" value="{!PROCEED}" />
								</td>
							</tr>

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
									<input class="button_screen_item buttons--proceed" type="submit" value="{!PROCEED}" />
								</td>
							</tr>
						{+END}
					</table>
				</form>
			</div>
		</div>

		{+START,IF,{MAY_DO_STUFF}}
			<div class="box box___w_main_screen" data-toggleable-tray="{}">
				<h2 class="toggleable_tray_title js-tray-header">
					<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{!W_ENVIRONMENT_ADDITIONS}</a>
					<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!EXPAND}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand2}" /></a>
				</h2>

				<div class="toggleable_tray js-tray-content" style="{HIDE_ADDITIONS*}"{+START,IF,{HIDE_ADDITIONS}} aria-expanded="false"{+END}>
					<div class="float-surrounder buildr_icons_wrap">
						<div class="buildr_icon" style="width: {$?,{MAY_ADD_PORTAL},20%,25%};">
							<a href="{$PAGE_LINK*,_SELF:_SELF:addrealm}"><img alt="{!W_ADD_REALM}" src="{$IMG*,buildr/realms}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:addrealm}">{!W_ADD_REALM}</a>
						</div>
						<div class="buildr_icon" style="width: {$?,{MAY_ADD_PORTAL},20%,25%};">
							<a href="{$PAGE_LINK*,_SELF:_SELF:addroom}"><img alt="{!W_ADD_ADJOINING_ROOM}" src="{$IMG*,buildr/addroom}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:addroom}">{!W_ADD_ADJOINING_ROOM}</a>
						</div>
						{+START,IF,{MAY_ADD_PORTAL}}
							<div class="buildr_icon" style="width: {$?,{MAY_ADD_PORTAL},20%,25%};">
								<a href="{$PAGE_LINK*,_SELF:_SELF:addportal}"><img alt="{!W_ADD_PORTAL}" src="{$IMG*,buildr/addportal}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:addportal}">{!W_ADD_PORTAL}</a>
							</div>
						{+END}
						<div class="buildr_icon" style="width: {$?,{MAY_ADD_PORTAL},20%,25%};">
							<a href="{$PAGE_LINK*,_SELF:_SELF:additem}"><img alt="{!W_ADD_ITEM}" src="{$IMG*,buildr/additem}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:additem}">{!W_ADD_ITEM}</a>
						</div>
						<div class="buildr_icon" style="width: {$?,{MAY_ADD_PORTAL},20%,25%};">
							<a href="{$PAGE_LINK*,_SELF:_SELF:additemcopy}"><img alt="{!W_ADD_ITEM_COPY}" src="{$IMG*,buildr/additemcopy}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:additemcopy}">{!W_ADD_ITEM_COPY}</a>
						</div>
					</div>
				</div>
			</div>
		{+END}

		<div class="box box___w_main_screen" data-toggleable-tray="{}">
			<h2 class="toggleable_tray_title js-tray-header">
				<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{!W_ENVIRONMENT_MODIFICATIONS}</a>
				<a class="js-click-set-hidemod-cookie toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!EXPAND}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand2}" /></a>
			</h2>

			<div class="toggleable_tray js-tray-content" style="{HIDE_MODIFICATIONS*}"{+START,IF,{HIDE_MODIFICATIONS}} aria-expanded="false"{+END}>
				{+START,IF_NON_EMPTY,{ITEMS_OWNED}}
					<form method="post" action="{$PAGE_LINK*,_SELF:_SELF}" autocomplete="off"><div>
						{$INSERT_SPAMMER_BLACKHOLE}

						<label for="item">{!W_ITEMS}</label>: {ITEMS_OWNED} <input type="hidden" name="type" value="edititem" />
						<input class="js-click-set-type-edititem button_screen_item buttons--edit" type="submit" value="{!W_EDIT_ITEM}" />
						<input class="js-click-set-type-confirm button_screen_item menu___generic_admin__delete" type="submit" value="{!W_DELETE_ITEM}" />
					</div></form>

					{+START,IF,{IS_STAFF}}
						<form method="post" action="{$PAGE_LINK*,_SELF:_SELF}" autocomplete="off"><div>
							{$INSERT_SPAMMER_BLACKHOLE}

							<label for="item">{!FROM}</label>: {ITEMS_OWNED} <label for="item2">{!TO}</label>: {ITEMS_OWNED_2} <input type="hidden" name="type" value="mergeitems" /> <input class="button_screen_item menu___generic_admin__merge" type="submit" value="{!W_MERGE_ITEMS}" />
						</div></form>
					{+END}
				{+END}

				{+START,IF,{$OR,{$IS_NON_EMPTY,{IS_ROOM_OWNER}},{$IS_NON_EMPTY,{IS_REALM_OWNER}}}}
					<br />
					<div class="float-surrounder buildr_icons_wrap">
						{+START,IF,{IS_ROOM_OWNER}}
							<div class="buildr_icon" style="width: {$?,{IS_REALM_OWNER},25%,50%};">
								<a href="{$PAGE_LINK*,_SELF:_SELF:editroom}"><img alt="{!W_EDIT_ROOM}" src="{$IMG*,buildr/addroom}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:editroom}">{!W_EDIT_ROOM}</a>
							</div>
							<div class="buildr_icon" style="width: {$?,{IS_REALM_OWNER},25%,50%};">
								<a href="{$PAGE_LINK*,_SELF:_SELF:confirm:btype=deleteroom}"><img alt="{!W_DELETE_ROOM}" src="{$IMG*,buildr/delroom}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:deleteroom}">{!W_DELETE_ROOM}</a>
							</div>
						{+END}
						{+START,IF,{IS_REALM_OWNER}}
							<div class="buildr_icon" style="width: {$?,{IS_ROOM_OWNER},25%,50%};">
								<a href="{$PAGE_LINK*,_SELF:_SELF:editrealm}"><img alt="{!W_EDIT_REALM}" src="{$IMG*,buildr/realms}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:editrealm}">{!W_EDIT_REALM}</a>
							</div>
							<div class="buildr_icon" style="width: {$?,{IS_ROOM_OWNER},25%,50%};">
								<a href="{$PAGE_LINK*,_SELF:_SELF:confirm:btype=deleterealm}"><img alt="{!W_DELETE_REALM}" src="{$IMG*,buildr/delrealm}" /></a><br /><a href="{$PAGE_LINK*,_SELF:_SELF:deleterealm}">{!W_DELETE_REALM}</a>
							</div>
						{+END}
					</div>
				{+END}
			</div>
		</div>
	</div>
</div>
