{$REQUIRE_CSS,cns}

<div class="forum-points-stuff-box">
	<h2 class="forum-points-stuff-box-head">
		Point leader-board
	</h2>

	<p>The top {$CONFIG_OPTION*,leader_board_size} point holders for this week are&hellip;</p>

	<table class="gift-table">
		{ROWS}
	</table>

	<p>
		Get 350 when a member joins using a <a href="{$PAGE_LINK*,:recommend}">recommended address</a>.<br />
	</p>

	<div class="forum-points-stuff-box-button">
		{+START,IF,{$NOT,{$MOBILE}}}
			<a rel="archives" href="{URL*}" title="{!MORE}: {!POINT_LEADER_BOARD}">Archive</a>
		{+END}
		<a href="{$PAGE_LINK*,site:stars}">Community stars</a>
		<a href="{$PAGE_LINK*,site:pointstore}">Point Store</a>
	</div>
</div>
