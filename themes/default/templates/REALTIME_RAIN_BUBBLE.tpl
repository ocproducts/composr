<div class="webstandards_checker_off">
	{$SET,RAND_ID,bubble_id_{$RAND}}

	<div id="{$GET,RAND_ID}" class="bubble_wrap attitude_{TYPE%}{$?,{IS_POSITIVE},_positive,}{$?,{IS_NEGATIVE},_negative,}">
		<div id="{$GET,RAND_ID}_main" class="bubble bubble_{TYPE%}">
			<div class="float_surrounder">
				<div class="email_icon">
					{+START,IF_PASSED,SPECIAL_ICON}
						<img src="{$IMG*,realtime_rain/{SPECIAL_ICON}}" alt="{SPECIAL_TOOLTIP*}" title="{SPECIAL_TOOLTIP*}" />
					{+END}
				</div>

				<div class="avatar_icon">
					{+START,IF_NON_EMPTY,{IMAGE}}
						<img src="{$ENSURE_PROTOCOL_SUITABILITY*,{IMAGE}}" alt="" />
					{+END}
				</div>
			</div>

			<h1>{TITLE*}</h1>

			<div class="linkage">
				{+START,IF_PASSED,URL}
					<a href="{URL*}">{!VIEW}</a>
				{+END}
			</div>
		</div>

		<script>// <![CDATA[
			window.pending_eval_function=function(ob) { // In webkit you can't get a node until it's been closed, so we need to set our code into a function and THEN run it
				{+START,IF_PASSED,TICKER_TEXT}
					window.setTimeout( function() {
						set_inner_html(document.getElementById('news_go_here'),'{TICKER_TEXT;^/}');
					} , {RELATIVE_TIMESTAMP%}*1000 );
				{+END}

				// Set up extra attributes
				ob.time_offset={RELATIVE_TIMESTAMP%};
				ob.lines_for=[];
				/*	We'll only do the group's, not the member lines, for performance
				{+START,IF_PASSED,FROM_ID}
					ob.lines_for.push('{FROM_ID;^/}');
				{+END}
				{+START,IF_PASSED,TO_ID}
					ob.lines_for.push('{TO_ID;^/}');
				{+END}
				*/
				{+START,IF_PASSED,GROUP_ID}
					ob.lines_for.push('{GROUP_ID;^/}');
				{+END}
				{+START,IF_PASSED,SPECIAL_ICON}
					{+START,IF,{$EQ,{SPECIAL_ICON},email-icon}}
						ob.icon_multiplicity={MULTIPLICITY%};
					{+END}
				{+END}
			};
		//]]></script>
	</div>
</div>
