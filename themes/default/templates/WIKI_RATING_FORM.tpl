{+START,IF_NON_EMPTY,{ERROR}}
	{ERROR}
{+END}

{+START,IF_EMPTY,{ERROR}}
	{+START,LOOP,ALL_RATING_CRITERIA}
		{+START,IF_EMPTY,{TITLE}}<span class="accessibility_hidden">{+END}<label accesskey="r" for="rating__{CONTENT_TYPE*}__{TYPE*}__{ID*}"><strong>{+START,IF_EMPTY,{TITLE}}{!RATING}:{+END}{+START,IF_NON_EMPTY,{TITLE}}{TITLE*}:{+END}</strong></label>{+START,IF_EMPTY,{TITLE}}</span>{+END}
		<select id="rating__{CONTENT_TYPE*}__{TYPE*}__{ID*}" name="rating__{CONTENT_TYPE*}__{TYPE*}__{ID*}">
			<option value="10">5</option>
			<option value="8">4</option>
			<option value="6">3</option>
			<option value="4">2</option>
			<option value="2">1</option>
		</select>
		{+START,IF,{SIMPLISTIC}}
			<input onclick="disable_button_just_clicked(this);" class="button_micro feedback__rate" type="submit" value="{!RATE}" />
		{+END}
	{+END}
	{+START,IF,{$NOT,{SIMPLISTIC}}}
		<div>
			<input onclick="disable_button_just_clicked(this);" class="button_micro feedback__rate" type="submit" value="{!RATE}" />
		</div>
	{+END}
{+END}
