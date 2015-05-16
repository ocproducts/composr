{$REQUIRE_JAVASCRIPT,dyn_comcode}
{$REQUIRE_CSS,carousels}

{$SET,carousel_id,{$RAND}}

<div class="xhtml_substr_no_break">
	<div id="carousel_{$GET*,carousel_id}" class="carousel" style="display: none">
		<div class="move_left" onkeypress="this.onmousedown(event);" onmousedown="carousel_move({$GET*,carousel_id},-50); return false;"></div>
		<div class="move_right" onkeypress="this.onmousedown(event);" onmousedown="carousel_move({$GET*,carousel_id},+50); return false;"></div>

		<div class="main">
		</div>
	</div>

	<div class="carousel_temp" id="carousel_ns_{$GET*,carousel_id}">
		{+START,LOOP,TUTORIALS}
			<div style="display: inline-block">
				{+START,SET,TOOLTIP}
					<h3 style="margin-top: 0">{TITLE*}</h3>

					<div class="meta_details" role="note" style="width: auto">
						<dl class="meta_details_list">
							{+START,IF_NON_EMPTY,{AUTHOR}}
								<dt class="field_name">{!BY}:</dt> <dd>{AUTHOR*}</dd>
							{+END}

							<dt class="field_name">{!ADDED}:</dt> <dd>{ADD_DATE*}</dd>

							{+START,IF,{$NEQ,{ADD_DATE},{EDIT_DATE}}}
								<dt class="field_name">{!EDITED}:</dt> <dd>{EDIT_DATE*}</dd>
							{+END}

							{+START,IF,{$NEQ,{MEDIA_TYPE},document}}
								<dt class="field_name">Media type:</dt> <dd>{$UCASE*,{MEDIA_TYPE},1}</dd>
							{+END}

							<dt class="field_name">Difficulty:</dt> <dd>{$UCASE*,{DIFFICULTY_LEVEL},1}</dd>

							<dt class="field_name">Tutorial type:</dt> <dd>{$?,{CORE},Core documentation,Auxillary}</dd>

							<dt class="field_name">Tags:</dt>
							<dd>
								<ul class="horizontal_meta_details" style="width: auto">
									{+START,LOOP,TAGS}
										<li><a href="{$PAGE_LINK*,_SEARCH:tutorials:{_loop_var}}">{_loop_var*}</a></li>
									{+END}
								</ul>
							</dd>
						</dl>
					</div>

					<p style="margin-bottom: 0">{SUMMARY*}</p>
				{+END}

				<a onmouseover="if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,'{$GET;^*,TOOLTIP}','550px');" href="{URL*}" style="position: relative"><img src="{ICON*}" alt="" /><span style="position: absolute; bottom: 0; left: 0; padding: 0.3em 0.4em; color: white; background: black; background: rgba(0,0,0,0.6); font-size: 0.9em">{TITLE*}</span></a>
			</div>
		{+END}
	</div>

	<script>// <![CDATA[
		add_event_listener_abstract(window,'load',function() {
			initialise_carousel({$GET,carousel_id});
		});
	//]]></script>
</div>
