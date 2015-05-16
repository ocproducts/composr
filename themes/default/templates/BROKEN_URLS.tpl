{+START,IF_ARRAY_NON_EMPTY,FOUND}
	<section class="box box___broken_urls"><div class="box_inner">
		<h3>{!BROKEN_URLS} {!BROKEN_URLS_FILES}</h3>

		{+START,LOOP,FOUND}
			<p>{URL*} <span class="associated_details">({TABLE*}:{FIELD*}:{ID*})</span></p>
		{+END}
	</div></section>
{+END}
{+START,IF_ARRAY_NON_EMPTY,FOUND_404}
	<section class="box box___broken_urls"><div class="box_inner">
		<h3>{!BROKEN_URLS} {!BROKEN_URLS_404}</h3>

		{+START,LOOP,FOUND_404}
			<p><a href="{URL*}">{URL*}</a>{+START,IF_NON_EMPTY,{SPOT}} <span class="associated_details">({!ADVANCED}&hellip; {SPOT*})</span>{+END}</p>
		{+END}
	</div></section>
{+END}

