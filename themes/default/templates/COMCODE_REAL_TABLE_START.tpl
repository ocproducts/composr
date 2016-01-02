{+START,IF_NON_EMPTY,{SUMMARY}}
	<p class="accessibility_hidden">
		{SUMMARY*}
	</p>
{+END}
<div{+START,IF,{WIDE}} class="wide_table_wrap"{+END}><table class="comcode_table results_table{+START,IF,{COLUMNED_TABLE}} columned_table{+END}{+START,IF,{WIDE}} wide_table{+END}">
{+START,IF_NON_EMPTY,{COLUMN_SIZES}}
	<colgroup>
		{+START,LOOP,COLUMN_SIZES}
			<col style="width: {_loop_var*}" />
		{+END}
	</colgroup>
{+END}
