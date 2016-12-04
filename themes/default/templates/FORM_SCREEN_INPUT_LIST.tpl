{$REQUIRE_JAVASCRIPT,core_form_interfaces}
{+START,IF,{INLINE_LIST}}
<select size="{SIZE*}" tabindex="{TABINDEX*}" class="input_list{REQUIRED*} wide_field" id="{NAME*}" name="{NAME*}">
{+END}
{+START,IF,{$NOT,{INLINE_LIST}}}
<select tabindex="{TABINDEX*}" class="input_list{REQUIRED*}" id="{NAME*}" name="{NAME*}">
{+END}
	{CONTENT}
</select>

{$SET,delimiter,}
{$SET,image_sources,\{{+START,IF_PASSED,IMAGES}{+START,LOOP,IMAGES}{$GET,delimiter}"{_loop_var#/}" : "{$IMG#/,{_loop_var}}"{$SET,delimiter,\,}{+END}{+END}\}}

<script type="application/json" data-tpl="formScreenInputList">{+START,PARAMS_JSON,INLINE_LIST,IMAGES,NAME,image_sources}{_/}{+END}</script>
