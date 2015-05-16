<div>
	<label for="{CLASS*}">
		<input {EXTRA} {+START,IF,{$EQ,{CLASS},{REC}}}checked="checked" {+END}type="radio" name="forum" id="{CLASS*}" value="{CLASS*}" onclick="do_forum_choose(this,'{VERSIONS;~*}');" />
		{TEXT*}
	</label>
</div>
