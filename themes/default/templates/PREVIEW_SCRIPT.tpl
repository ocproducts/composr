{+START,IF_NON_EMPTY,{SPELLING}}
	<div class="box box___preview_script"><div class="box_inner">
		<h2>{!SPELLCHECK}</h2>

		<div>
			{SPELLING}
		</div>
	</div></div>
{+END}
{+START,IF_NON_EMPTY,{KEYWORD_DENSITY}}
	<div class="box box___preview_script"><div class="box_inner">
		<h2>{!KEYWORDCHECK}</h2>

		<div>
			{KEYWORD_DENSITY}
		</div>
	</div></div>
{+END}
{+START,IF_NON_EMPTY,{WEBSTANDARDS}}
	<div class="box box___preview_script"><div class="box_inner">
		<h2>{!WEBSTANDARDS}</h2>

		<div>
			{WEBSTANDARDS}
		</div>
	</div></div>
{+END}
{+START,IF_EMPTY,{WEBSTANDARDS}}
	<section class="box box___preview_script global_middle_faux"><div class="box_inner">
		<h2>{!PREVIEW}</h2>

		<div class="preview_box{+START,IF,{$AND,{$NOT,{$MOBILE,1}},{$MOBILE}}} mobile{+END}">
			<div id="preview_box_inner" class="preview_box_inner">
				{$TRIM,{OUTPUT}}
			</div>
		</div>

		{+START,IF,{$NOT,{$MOBILE,1}}}
			{+START,IF,{$MOBILE}}
				<script>// <![CDATA[
					var inner=document.getElementById('preview_box_inner');
					add_event_listener_abstract(inner,browser_matches('gecko')?'DOMMouseScroll':'mousewheel',function(event) { inner.scrollTop-=event.wheelDelta?event.wheelDelta:event.detail; cancel_bubbling(event); if (typeof event.preventDefault!='undefined') event.preventDefault(); return false; });
				//]]></script>
			{+END}
		{+END}

		{+START,IF,{$JS_ON}}
			<hr class="spaced_rule" />

			<form target="_self" action="{$SELF_URL*,0,0,keep_mobile={$MOBILE}}" method="post" autocomplete="off">
				{$INSERT_SPAMMER_BLACKHOLE}

				{HIDDEN}

				{+START,IF,{$NOT,{$MOBILE,1}}}
					{+START,IF,{$CONFIG_OPTION,mobile_support}}
						<p>
							<label for="mobile_version">{!MOBILE_VERSION}: <input{+START,IF,{$MOBILE}} checked="checked"{+END} onclick="return preview_mobile_button(this,event);" type="checkbox" id="mobile_version" name="_mobile_version" /></label>
							{+START,IF,{$MOBILE}}
								&ndash; <em>{!USE_MOUSE_WHEEL_SCROLL}</em>
							{+END}
						</p>
					{+END}
				{+END}
			</form>
		{+END}
	</div></section>
{+END}
