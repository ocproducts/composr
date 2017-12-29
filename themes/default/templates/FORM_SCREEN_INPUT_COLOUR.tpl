{$REQUIRE_JAVASCRIPT,jquery}
{$REQUIRE_JAVASCRIPT,widget_color}
{$REQUIRE_JAVASCRIPT,theme_colours}
{$REQUIRE_JAVASCRIPT,core_form_interfaces}
{$REQUIRE_CSS,widget_color}

{+START,IF,{RAW_FIELD}}
	<div class="float-surrounder" data-tpl="formScreenInputColour" data-tpl-params="{+START,PARAMS_JSON,RAW_FIELD,NAME,DEFAULT,TABINDEX,PRETTY_NAME,_REQUIRED}{_*}{+END}">
		<div id="colours_go_here_{NAME*}">
			<div aria-busy="true" class="spaced">
				<div class="ajax_loading vertical_alignment">
					<img src="{$IMG*,loading}" title="{!LOADING}" alt="{!LOADING}" />
					<span>{!LOADING}</span>
				</div>
			</div>
		</div>
	</div>
{+END}
{+START,IF,{$NOT,{RAW_FIELD}}}
	<tr class="field-input" data-tpl="formScreenInputColour" data-tpl-params="{+START,PARAMS_JSON,RAW_FIELD,NAME,DEFAULT,TABINDEX,PRETTY_NAME,_REQUIRED}{_*}{+END}">
		<td colspan="2" class="form-table-huge-field-description-is-under form-table-huge-field{+START,IF,{REQUIRED}} required{+END}">
			<div id="colours_go_here_{NAME*}">
				<div aria-busy="true" class="spaced">
					<div class="ajax_loading vertical_alignment">
						<img src="{$IMG*,loading}" title="{!LOADING}" alt="{!LOADING}" />
						<span>{!LOADING}</span>
					</div>
				</div>
			</div>
			{+START,INCLUDE,FORM_SCREEN_FIELD_DESCRIPTION}{+END}
		</td>
	</tr>
{+END}
