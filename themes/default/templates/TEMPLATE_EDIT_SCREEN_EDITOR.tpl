<div id="template_editing_{I*}" style="display: {DISPLAY*}">
	{+START,IF,{$NEQ,{$GET,COUNT},1}}
	<div class="box box___template_edit_screen_editor"><div class="box_inner">
	{+END}
		<div> {$,Extra div needed so the h2 is not a box title}
			{+START,IF,{$NEQ,{$GET,COUNT},1}}
				<h2>{!EDITING,<kbd>{FILE_SAVE_TARGET*}</kbd>}</h2>
			{+END}

			<input type="hidden" name="f{I*}file" value="{FILE*}" />
			<input type="hidden" name="{CODENAME*}" value="f{I*}" />

			<div>
				<h3>
					<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray('f{I*}sdp');"><img alt="{!EXPAND}: {!SYMBOLS_AND_DIRECTIVES}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand}" srcset="{$IMG*,2x/trays/expand} 2x" /></a>
					<a class="non_link" href="#" onclick="return toggleable_tray('f{I*}sdp');">{!SYMBOLS_AND_DIRECTIVES}</a>
				</h3>
				<div class="toggleable_tray" style="display: {$JS_ON,none,block}" id="f{I*}sdp" aria-expanded="false">
					{PARAMETERS}
					{DIRECTIVES}
					{SYMBOLS}
					{PROGRAMMATIC_SYMBOLS}
					{ABSTRACTION_SYMBOLS}
					{ARITHMETICAL_SYMBOLS}
					{FORMATTING_SYMBOLS}
					{LOGICAL_SYMBOLS}

					{+START,IF_NON_EMPTY,{GUID}}
						<div class="float_surrounder {$CYCLE,tep,tpl_dropdown_row_a,tpl_dropdown_row_b}">
							<div class="right">
								<input class="button_micro menu___generic_admin__add_one" onclick="window.fauxmodal_confirm('{$STRIP_TAGS,{!HELP_INSERT_DISTINGUISHING_TEMPCODE;}}',function(result) { if (result) { insert_textbox(document.getElementById('f{I*}_new'),'{'+'+START,IF,{'+'$EQ,{'+'_GUID},{GUID*}}}\n{'+'+END}'); } }); return false;" type="button" value="{$STRIP_TAGS,{!INSERT_DISTINGUISHING_TEMPCODE}}" />
							</div>
						</div>
					{+END}
				</div>
			</div>

			<h3><label for="f{I*}_new">{!TEMPLATE}</label></h3>
			<div class="constrain_field">
				<textarea onkeydown="if (key_pressed(event,9)) { insert_textbox(this,'	'); return false; }" id="f{I*}_new" name="f{I*}_new" cols="70" rows="22" class="wide_field textarea_scroll">{CONTENTS*}</textarea>
			</div>

			<div class="original_template">
				<h3>
					<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);"><img alt="{!EXPAND}: {!ORIGINAL}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand}" srcset="{$IMG*,2x/trays/expand} 2x" /></a>
					<a class="non_link" href="#" onclick="event.returnValue=false; toggleable_tray(this.parentNode.parentNode); return false;">{!ORIGINAL}</a>:
				</h3>
				<div class="toggleable_tray" style="display: {$JS_ON,none,block}" aria-expanded="false">
					<div class="constrain_field">
						<div class="whitespace_visible code">{OLD_CONTENTS*}</div>
					</div>
				</div>
			</div>

			{+START,IF_NON_EMPTY,{GUIDS}}
				<div>
					<h3>
						<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);"><img alt="{!EXPAND}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand}" srcset="{$IMG*,2x/trays/expand} 2x" /></a>
						<a class="non_link" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);">GUIDs</a>
					</h3>
					<div class="toggleable_tray" style="display: {$JS_ON,none,block}" aria-expanded="false">
						<div class="wide_table_wrap"><table class="columned_table autosized_table revision_box results_table wide_table">
							<thead>
								<tr>
									<th>{!FILENAME}</th>
									<th>{!LINE}</th>
									<th>GUID</th>
								</tr>
							</thead>
							<tbody>
								{+START,LOOP,GUIDS}
									<tr class="{$CYCLE,results_table_zebra,zebra_0,zebra_1}">
										<td>
											<kbd>{FILENAME*}</kbd>
										</td>
										<td>
											{+START,IF,{$ADDON_INSTALLED,code_editor}}
												<a target="_blank" title="{LINE*} {!LINK_NEW_WINDOW}" href="{$BASE_URL*}/code_editor.php?path={FILENAME*}&amp;line={LINE*}">{LINE*}</a>
											{+END}
											{+START,IF,{$NOT,{$ADDON_INSTALLED,code_editor}}}
												{LINE*}
											{+END}
										</td>
										<td>
											<a onclick="insert_textbox(document.getElementById('f{I*}_new'),'{'+'+START,IF,{'+'$EQ,{'+'_GUID},{THIS_GUID}}}\n{'+'+END}'); return false;" href="#">{THIS_GUID*}</a>
										</td>
									</tr>
								{+END}
							</tbody>
						</table></div>
					</div>
				</div>
			{+END}

			{REVISIONS}

			{+START,SET,button}
				{+START,IF_NON_EMPTY,{PREVIEW_URL}}
					<div class="right">
						<input onclick="this.form.target='_blank'; this.form.action='{PREVIEW_URL;*}';" accesskey="p" class="tabs__preview {$?,{$EQ,{$GET,COUNT},1},button_screen,button_screen_item}" type="submit" value="{!PREVIEW}" />
					</div>
				{+END}
			{+END}

			{+START,IF,{$NEQ,{$GET,COUNT},1}}
				{$GET,button}
			{+END}
		</div>
	{+START,IF,{$NEQ,{$GET,COUNT},1}}
	</div></div>
	{+END}
</div>
