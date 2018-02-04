{$REQUIRE_JAVASCRIPT,core_rich_media}

<a data-tpl="comcodeTabHead" data-tpl-params="{+START,PARAMS_JSON,tab_sets,TITLE}{_*}{+END}" aria-controls="g-{$GET|*,tab_sets}-{TITLE|*}" role="tab" href="#!" id="t-{$GET|*,tab_sets}-{TITLE|*}" class="tab{+START,IF,{FIRST}} tab-active tab-first{+END}{+START,IF,{LAST}} tab-last{+END}"><span>{TITLE*}</span></a>
