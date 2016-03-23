<div class="accessibility_hidden"><label for="post_template">{!POST_TEMPLATE}</label></div>
<select{+START,IF_PASSED,TABINDEX} tabindex="{TABINDEX*}"{+END} id="post_template" name="post_template">
	{LIST}
</select>
<input class="button_screen_item buttons__proceed" type="submit" value="{!USE}" onclick="var element=form.elements['post']; {+START,IF_PASSED_AND_TRUE,RESETS}set_textbox(element,''); {+END}var ins=form.elements['post_template'].value; insert_textbox(form.elements['post'],ins.replace(/\\n/g,'\n'),null,true,escape_html(ins).replace(/\\n/g,'&lt;br /&gt;')); return false;" />

