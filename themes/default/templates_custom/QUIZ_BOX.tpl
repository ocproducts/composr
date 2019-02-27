<section class="box box---quiz-box"><div class="box-inner">
	{+START,SET,content_box_title}
		{NAME*}
	{+END}
	{+START,IF,{$NOT,{$GET,skip_content_box_title}}}
		<h3>{$GET,content_box_title}</h3>
	{+END}

	<div class="meta-details" role="note">
		<dl class="meta-details-list">
			{+START,IF_NON_EMPTY,{TIMEOUT}}
				<dt class="field-name">{!TIMEOUT}:</dt> <dd>{TIMEOUT*}</dd>
			{+END}
			{+START,IF_NON_EMPTY,{REDO_TIME}}
				<dt class="field-name">{!REDO_TIME}:</dt> <dd>{REDO_TIME*}</dd>
			{+END}
			<dt class="field-name">{!ADDED}:</dt> <dd>{DATE*}</dd>
		</dl>
	</div>

	{+START,IF_NON_EMPTY,{START_TEXT}}
		<p>
			{START_TEXT}
		</p>
	{+END}

	<div class="shunted-button">
		<form title="{!START} {!QUIZ}: {NAME*}" method="post" action="{URL*}">
			<button class="btn btn-primary btn-scri buttons--more" type="submit">{+START,INCLUDE,ICON}NAME=buttons/more{+END} {!START}</button>
		</form>
	</div>

	{+START,IF,{$EQ,{_TYPE},TEST}}{+START,IF,{$NEQ,{POINTS},0}}{+START,IF,{$ADDON_INSTALLED,points}}
		<p>You will win <strong>{$NUMBER_FORMAT*,{POINTS}}</strong> points if you pass this test. You will spend <strong>{$NUMBER_FORMAT*,{$DIV,{POINTS},2}}</strong> points to enter this test.<br />Put your points on the line and your knowledge to the test!</p>
	{+END}{+END}{+END}
</div></section>
