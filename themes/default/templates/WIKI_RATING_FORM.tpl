{+START,IF_NON_EMPTY,{ERROR}}
	{ERROR}
{+END}

{+START,IF_EMPTY,{ERROR}}
	{+START,LOOP,ALL_RATING_CRITERIA}
		{+START,IF_EMPTY,{TITLE}}<span class="accessibility-hidden">{+END}<label accesskey="r" for="rating__{CONTENT_TYPE*}__{TYPE*}__{ID*}"><strong>{+START,IF_EMPTY,{TITLE}}{!RATING}:{+END}{+START,IF_NON_EMPTY,{TITLE}}{TITLE*}:{+END}</strong></label>{+START,IF_EMPTY,{TITLE}}</span>{+END}
		<select id="rating__{CONTENT_TYPE*}__{TYPE*}__{ID*}" name="rating__{CONTENT_TYPE*}__{TYPE*}__{ID*}">
			<option value="10">5</option>
			<option value="8">4</option>
			<option value="6">3</option>
			<option value="4">2</option>
			<option value="2">1</option>
		</select>
		{+START,IF,{SIMPLISTIC}}
			<button data-disable-on-click="1" class="button-micro feedback--rate" type="submit">{!RATE}</button>
		{+END}
	{+END}
	{+START,IF,{$NOT,{SIMPLISTIC}}}
		<div>
			<button data-disable-on-click="1" class="button-micro feedback--rate" type="submit">{!RATE}</button>
		</div>
	{+END}
{+END}
