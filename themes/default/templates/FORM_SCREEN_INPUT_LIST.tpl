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

<<<<<<< HEAD
<script type="application/json" data-tpl="formScreenInputList">{+START,PARAMS_JSON,INLINE_LIST,IMAGES,NAME,image_sources}{_/}{+END}</script>
=======
		add_event_listener_abstract(window,'load',function() {
			var element=document.getElementById("{NAME#/}");
			if ((element.options.length>20)/*only for long lists*/ && (!get_inner_html(element.options[1]).match(/^\d+$/)/*not for lists of numbers*/))
			{
				if (typeof $(element).select2!='undefined')
				{
					$(element).select2({
						{+START,IF_PASSED,IMAGES}
							formatResult: format_select_image,
						{+END}
						dropdownAutoWidth: true,
						containerCssClass: 'wide_field'
					});
				}
			}
		});
	//]]></script>
{+END}
>>>>>>> master
