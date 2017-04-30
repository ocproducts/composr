{$REQUIRE_JAVASCRIPT,data_mappr}
{+START,IF_NON_EMPTY,{TITLE}}
<section class="box box___block_main_google_map inline_block"><div class="box_inner">
	<h3>{TITLE*}</h3>
{+END}
	{$SET,google_map_key,{$CONFIG_OPTION,google_map_key}}

	<div data-require-javascript="data_mappr" data-tpl="blockMainGoogleMap"
		 data-tpl-params="{+START,PARAMS_JSON,CLUSTER,google_map_key,LATITUDE,LONGITUDE,DIV_ID,ZOOM,CENTER,DATA,MIN_LATITUDE,MAX_LATITUDE,MIN_LONGITUDE,MAX_LONGITUDE,REGION}{_*}{+END}"
         style="width:{WIDTH}; height:{HEIGHT}" id="{DIV_ID*}"></div>
{+START,IF_NON_EMPTY,{TITLE}}
</div></section>
{+END}

