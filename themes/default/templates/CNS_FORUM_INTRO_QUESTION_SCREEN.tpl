{TITLE}

{$REQUIRE_CSS,messages}

<p class="red-alert" role="alert">{$?,{$IS_NON_EMPTY,{ANSWER}},{!FORUM_INTRO_QUESTION_TEXT},{!FORUM_INTRO_QUESTION_TEXT_ALT}}</p>

<div class="box box___cns_forum_intro_question_screen"><div class="box-inner">
	{+START,IF_NON_EMPTY,{ANSWER}}
		<h2>{!QUESTION}</h2>
	{+END}
	{+START,IF_EMPTY,{ANSWER}}
		<h2>{!MESSAGE}</h2>
	{+END}

	{QUESTION}
</div></div>

<form title="{!PROCEED}" action="{URL*}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	{+START,IF_NON_EMPTY,{ANSWER}}
		<div class="cns-intro-question-answer-box"><label for="answer">{!ANSWER}</label>: <input maxlength="255" id="answer" type="text" name="answer" /> <input accesskey="u" data-disable-on-click="1" class="button_screen buttons--proceed" type="submit" value="{!PROCEED}" /></div>
	{+END}
	{+START,IF_EMPTY,{ANSWER}}
		<div>
			<input type="hidden" name="answer" value="" />

			<p class="proceed_button">
				<input accesskey="u" data-disable-on-click="1" class="button_screen buttons--proceed" type="submit" value="{!PROCEED}" />
			</p>
		</div>
	{+END}
</form>
