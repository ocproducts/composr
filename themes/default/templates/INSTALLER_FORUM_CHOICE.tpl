<div data-tpl="installerForumChoice">
	<label for="{CLASS*}">
		<input {EXTRA}{+START,IF,{$EQ,{CLASS},{REC}}} checked="checked"{+END} type="radio" name="forum" id="{CLASS*}" value="{CLASS*} js-click-do-forum-choose" />
		<span>{TEXT*}</span>
	</label>
</div>
