{TITLE}

<p class="lonely-label">{!SPONSORS_LABEL}</p>
<ul>
	{+START,LOOP,SPONSORS}
		<li>
			{_loop_key*}:
			<ul>
				{+START,LOOP,AREAS}
					<li>{_loop_var*}</li>
				{+END}
			</ul>
		</li>
	{+END}
</ul>

{+START,IF_NON_EMPTY,{PATREON_PATRONS}}
	<p class="lonely-label">{!PATREON_PATRONS_LABEL}</p>
	<ul>
		{+START,LOOP,PATREON_PATRONS}
			<li>{NAME*}</li>
		{+END}
	</ul>
{+END}
