{+START,IF_NON_EMPTY,{SUMMARY}}
	<p class="accessibility-hidden">
		{SUMMARY*}
	</p>
{+END}
<div {+START,IF,{WIDE}} class="wide-table-wrap"{+END}><table class="comcode_table results-table{+START,IF,{COLUMNED_TABLE}} columned-table responsive-table{+END}{+START,IF,{WIDE}} wide-table{+END}">
{+START,IF_NON_EMPTY,{COLUMN_SIZES}}
	<colgroup>
		{+START,LOOP,COLUMN_SIZES}
			<col style="width: {_loop_var*}" />
		{+END}
	</colgroup>
{+END}
