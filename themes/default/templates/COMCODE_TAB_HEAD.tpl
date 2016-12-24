{$REQUIRE_JAVASCRIPT,core_rich_media}
<a data-tpl="comcodeTabHead" data-tpl-params="{+START,PARAMS_JSON,tab_sets,TITLE}{_*}{+END}" aria-controls="g_{$GET|*,tab_sets}_{TITLE|*}" role="tab" href="#!" id="t_{$GET|*,tab_sets}_{TITLE|*}" class="tab{+START,IF,{FIRST}} tab_active tab_first{+END}{+START,IF,{LAST}} tab_last{+END}"><span>{TITLE*}</span></a>
