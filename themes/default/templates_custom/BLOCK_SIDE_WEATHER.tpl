<section class="box box___block_side_weather"><div class="box-inner">
	<h3>{!WEATHER_REPORT}</h3>

	{+START,IF_NON_EMPTY,{IMAGE}}
		<img src="{$ENSURE_PROTOCOL_SUITABILITY*,{$STRIP_HTML,{IMAGE}}}" alt="{!WEATHER_IMAGE}" />
	{+END}

	<p><strong>{TITLE`}</strong></p>

	{+START,IF_NON_EMPTY,{COND}}
		<div>{COND`}</div>
	{+END}

	{+START,IF_NON_EMPTY,{FORECAST}}
		<div>{FORECAST`}</div>
	{+END}
</div></section>
