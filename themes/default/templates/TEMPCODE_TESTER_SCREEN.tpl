{$REQUIRE_JAVASCRIPT,core_themeing}
{TITLE}

<p>{!TEMPCODE_TESTER_HELP}</p>

<form title="{!PRIMARY_PAGE_FORM}" method="post" action="#!" autocomplete="off" data-tpl-core-themeing="tempcodeTesterScreen">
	{$INSERT_SPAMMER_BLACKHOLE}

	<h2><label for="tempcode">Tempcode</label></h2>
	<div class="constrain_field">
		<textarea id="tempcode" name="tempcode" cols="70" rows="17" class="wide_field" wrap="off"></textarea>
	</div>

	<h2>{!PARAMETERS}</h2>

	{+START,LOOP,1\,2\,3\,4\,5\,6\,7\,8\,9\,10}
		<div class="vertical_alignment">
			<label class="accessibility_hidden" for="key_{_loop_var*}">{!TEMPCODE_PARAMETER} #{_loop_var*}</label>
			<label class="accessibility_hidden" for="val_{_loop_var*}">{!TEMPCODE_VALUE} #{_loop_var*}</label>
			<input type="text" id="key_{_loop_var*}" name="key_{_loop_var*}" size="10" value="" />
			&rarr;
			<input type="text" id="val_{_loop_var*}" name="val_{_loop_var*}" size="60" value="" />
		</div>
	{+END}

	<p class="proceed_button">
		<input accesskey="p" class="button_screen tabs__preview js-btn-do-preview" type="submit" value="{!PREVIEW}" />
	</p>
</form>

<h2>{!PREVIEW}</h2>

<div class="comcode_code_wrap">
	<div class="comcode_code">
		<h4>{!RAW_PREVIEW}</h4>

		<div class="webstandards_checker_off"><div class="comcode_code_inner" id="preview_raw">
			<p class="nothing_here">{!UNSET}</p>
		</div></div>
	</div>
</div>

<div class="comcode_code_wrap">
	<div class="comcode_code">
		<h4>{!HTML_PREVIEW}</h4>

		<div class="webstandards_checker_off"><div class="comcode_code_inner" id="preview_html">
			<p class="nothing_here">{!UNSET}</p>
		</div></div>
	</div>
</div>

<div class="comcode_code_wrap">
	<div class="comcode_code">
		<h4>{!COMCODE_PREVIEW}</h4>

		<div class="webstandards_checker_off"><div class="comcode_code_inner" id="preview_comcode">
			<p class="nothing_here">{!UNSET}</p>
		</div></div>
	</div>
</div>
