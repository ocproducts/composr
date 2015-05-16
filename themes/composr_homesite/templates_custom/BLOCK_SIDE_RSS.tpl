<div class="ltNewsRht">
	<h3 class="ltNewsHead">
		{TITLE}
	</h3

	<div class="ltCnt">
		<div class="ltNewsHold">
			{+START,IF_EMPTY,{CONTENT}}
				<p class="nothing_here">{!NO_NEWS}</p>
			{+END}
			{+START,IF_NON_EMPTY,{CONTENT}}
				<div class="webstandards_checker_off">
					{CONTENT}
				</div>
			{+END}
		</div>
	</div>
</div>
