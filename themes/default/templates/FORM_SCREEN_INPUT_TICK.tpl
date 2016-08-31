{+START,IF,{$JS_ON}}{+START,IF,{$EQ,{NAME},validated}}<span class="validated_checkbox{+START,IF,{CHECKED}} checked{+END}"></span>{+END}{+END}
<input class="input_tick" type="checkbox" id="{NAME*}" name="{NAME*}" data-tpl-core-form-interfaces="formScreenInputTick" data-tpl-args="{+START,PARAMS_JSON,NAME}{_*}{+END}" tabindex="{TABINDEX*}" value="{+START,IF_PASSED,VALUE}{VALUE*}{+END}{+START,IF_NON_PASSED,VALUE}1{+END}"{+START,IF,{CHECKED}} checked="checked"{+END} />
<input name="tick_on_form__{NAME*}" value="0" type="hidden" />
