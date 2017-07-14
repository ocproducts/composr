{+START,IF,{$NOT,{$MOBILE}}}
<div class="ltNewsRht">
	<h2 class="ltNewsHead">
		Newsletter Sign up
	</h2>
{+END}

	<div class="ltCnt">
		<div class="ltNewsHold">
			<p>Get the latest news and updates with the Composr CMS e-mail newsletter. We'll keep you posted on the latest featured topics, research studies, videos, tools and upcoming web events.</p>

			{+START,IF_PASSED,MSG}
				<p>
					{MSG}
				</p>
			{+END}

			<form class="inpEmail" title="{!NEWSLETTER}" onsubmit="if ((check_field_for_blankness(this.elements['address{NID*}'],event)) &amp;&amp; (this.elements['address{NID*}'].value.match(/^[a-zA-Z0-9\._\-\+]+@[a-zA-Z0-9\._\-]+$/))) { disable_button_just_clicked(this); return true; } window.fauxmodal_alert('{!javascript:NOT_A_EMAIL;=*}'); return false;" action="{URL*}" method="post">
				{$INSERT_SPAMMER_BLACKHOLE}

				<label for="bfirstname" class="accessibility_hidden">Please enter your name</label>
				<input id="bfirstname" name="firstname{NID*}" class="user" type="text" placeholder="Please enter your name" />

				<label for="baddress" class="accessibility_hidden">E-mail address</label>
				<input id="baddress" name="address{NID*}" class="email" type="text" placeholder="E-mail address" />

				<input class="emailBtn" name="Submit" type="submit" value="Submit" />
			</form>
		</div>
	</div>

{+START,IF,{$NOT,{$MOBILE}}}
</div>
{+END}
