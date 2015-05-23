{$REQUIRE_JAVASCRIPT,jquery}
{$REQUIRE_JAVASCRIPT,widget_color}
{$REQUIRE_JAVASCRIPT,theme_colours}
{$REQUIRE_CSS,widget_color}

{+START,IF,{RAW_FIELD}}
	<div class="float_surrounder">
		<div id="colours_go_here_{NAME*}">
			<div aria-busy="true" class="spaced">
				<div class="ajax_loading vertical_alignment">
					<img id="loading_image" src="{$IMG*,loading}" title="{!LOADING}" alt="{!LOADING}" />
					<span>{!LOADING}</span>
				</div>
			</div>
		</div>
		<script>// <![CDATA[
			add_event_listener_abstract(window,'load',function() {
				make_colour_chooser('{NAME;/}','{DEFAULT;/}','',{TABINDEX%},' ','input_colour{_REQUIRED;/}');
				do_color_chooser();
			});
		//]]></script>
	</div>
{+END}
{+START,IF,{$NOT,{RAW_FIELD}}}
	<tr class="field_input">
		<td{+START,IF,{$NOT,{$MOBILE}}} colspan="2"{+END} class="form_table_huge_field_description_is_under form_table_huge_field{+START,IF,{REQUIRED}} required{+END}">
			<div id="colours_go_here_{NAME*}">
				<div aria-busy="true" class="spaced">
					<div class="ajax_loading vertical_alignment">
						<img id="loading_image" src="{$IMG*,loading}" title="{!LOADING}" alt="{!LOADING}" />
						<span>{!LOADING}</span>
					</div>
				</div>
			</div>
			<script>// <![CDATA[
				add_event_listener_abstract(window,'load',function() {
					make_colour_chooser('{NAME;/}','{DEFAULT;/}','',{TABINDEX%},'{PRETTY_NAME;/}','input_colour{_REQUIRED;/}');
					do_color_chooser();
				});
			//]]></script>

			{+START,INCLUDE,FORM_SCREEN_FIELD_DESCRIPTION}{+END}
		</td>
	</tr>
{+END}
