{+START,IF_NON_EMPTY,{_EDIT_URL}}
	<form onsubmit="return confirm_delete(this);" class="delete_cross_button" title="{!DELETE} #{ID*}" action="{_EDIT_URL*}" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div>
			<input type="hidden" name="delete" value="2" />
			<input type="image" alt="{!DELETE}" src="{$IMG*,icons/14x14/delete}" />
		</div>
	</form>
{+END}
