{$, Template uses auto-complete}
{$REQUIRE_JAVASCRIPT,jquery}
{$REQUIRE_JAVASCRIPT,jquery_autocomplete}
{$REQUIRE_JAVASCRIPT,core_form_interfaces}
{$REQUIRE_CSS,autocomplete}

<span data-tpl="formScreenInputLine" data-tpl-params="{+START,PARAMS_JSON,NAME,WYSIWYG}{_*}{+END}">
	<input {+START,IF_PASSED,AUTOCOMPLETE} autocomplete="{AUTOCOMPLETE*}"{+END} size="{SIZE*}"{+START,IF_PASSED,MAXLENGTH} maxlength="{MAXLENGTH*}"{+END}{+START,IF_NON_PASSED,MAXLENGTH} maxlength="255"{+END} tabindex="{TABINDEX*}" class="form-control input-line{REQUIRED*}" type="{+START,IF_NON_PASSED,TYPE}text{+END}{+START,IF_PASSED,TYPE}{TYPE*}{+END}" id="{NAME*}" name="{NAME*}" value="{DEFAULT*}"{+START,IF_PASSED,PLACEHOLDER} placeholder="{PLACEHOLDER*}"{+END}{+START,IF_PASSED,PATTERN} pattern="{PATTERN*}"{+END} />
</span>
