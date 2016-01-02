{+START,IF_EMPTY,{BANNERS}}
	<p class="nothing_here">{!NO_ENTRIES}</p>
{+END}

{+START,IF_NON_EMPTY,{BANNERS}}
	<div class="wide_table_wrap"><table class="columned_table wide_table results_table spaced_table autosized_table">
		<thead>
			<tr>
				<th>
					{!SITE}
				</th>
				<th>
					{!BANNER_HITSFROM}
				</th>
				<th>
					{!BANNER_HITSTO}
				</th>
			</tr>
		</thead>

		<tbody>
			{+START,LOOP,BANNERS}
				<tr{+START,IF,{$LT,{_loop_key},5}} class="highlighted_table_cell"{+END}>
					<td>
						{+START,IF,{$LT,{_loop_key},20}}{BANNER}{+END}

						{+START,IF,{$NOT,{$LT,{_loop_key},20}}}
							{+START,IF_NON_EMPTY,{DESCRIPTION}}
								<p><a target="_blank" title="{$STRIP_TAGS,{DESCRIPTION}}: {!NEW_WINDOW}" href="{URL*}">{DESCRIPTION}</a></p>
							{+END}
							{+START,IF_EMPTY,{DESCRIPTION}}
								<p><a target="_blank" title="{NAME*}: {!NEW_WINDOW}" href="{URL*}">{NAME*}</a></p>
							{+END}
						{+END}
					</td>

					<td>
						{$NUMBER_FORMAT*,{HITSFROM}}
					</td>

					<td>
						{$NUMBER_FORMAT*,{HITSTO}}
					</td>
				</tr>
			{+END}
		</tbody>
	</table></div>
{+END}

{+START,IF_NON_EMPTY,{SUBMIT_URL}}
	<p class="proceed_button"><a class="menu___generic_admin__add_one button_screen" href="{SUBMIT_URL*}"><span>{!ADD_BANNER}</span></a></p>
{+END}
