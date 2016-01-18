{+START,IF,{$NOT,{$MOBILE}}}
<div class="ltNewsRht">
	<h4 class="ltNewsHead">
		Newsletter Sign up
	</h4>
{+END}

	<div class="ltCnt">
		<div class="ltNewsHold">
			<p>{!SUCCESS_NEWSLETTER_AUTO,{PASSWORD*}}</p>
		</div>
	</div>

{+START,IF,{$NOT,{$MOBILE}}}
</div>
{+END}
