{+START,IF_NON_EMPTY,{ALL}}
	<div class="field_multilist">
		{+START,LOOP,ALL}<p>
			{+START,IF,{SHOW_UNSET_VALUES}}
				{+START,IF,{HAS}}
					<span class="multilist_mark yes">&#10003;</span> {$,Checkmark entity}
				{+END}
				{+START,IF,{$NOT,{HAS}}}
					<span class="multilist_mark no">&#10007;</span> {$,Cross entity}
				{+END}
			{+END}

			{OPTION*}

			{+START,IF_PASSED_AND_TRUE,IS_OTHER}
				<span class="associated_details">({!fields:ADDITIONAL_CUSTOM})</span>
			{+END}
		</p>{+END}
	</div>
{+END}
