{$REQUIRE_JAVASCRIPT,core_form_interfaces}
<div data-tpl-core-form-interfaces="previewScript">
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

		<div class="preview_box">
			<div id="preview_box_inner" class="preview_box_inner {+START,IF,{HAS_DEVICE_PREVIEW_MODES}}{+START,IF,{$AND,{$NOT,{$MOBILE,1}},{$MOBILE}}}js-preview-box-scroll{+END}{+END}">
				{$TRIM,{OUTPUT}}
			</div>
		</div>

		{+START,IF,{HAS_DEVICE_PREVIEW_MODES}}
			{+START,IF,{$JS_ON}}
				<hr class="spaced_rule" />

				<form target="_self" action="{$SELF_URL*,0,0,keep_mobile={$MOBILE}}" method="post" autocomplete="off">
					{$INSERT_SPAMMER_BLACKHOLE}

					{HIDDEN}

					{+START,IF,{$NOT,{$MOBILE,1}}}
						{+START,IF,{$CONFIG_OPTION,mobile_support}}
							<p>
								<label for="mobile_version">{!MOBILE_VERSION}: <input type="checkbox" id="mobile_version" name="_mobile_version" data-cms-js class="js-click-preview-mobile-button" {+START,IF,{$MOBILE}} checked="checked"{+END} /></label>
								{+START,IF,{$MOBILE}}
									&ndash; <em>{!USE_MOUSE_WHEEL_SCROLL}</em>
								{+END}
							</p>
						{+END}
					{+END}
				</form>
			{+END}
		{+END}
	</div></section>
{+END}
</div>