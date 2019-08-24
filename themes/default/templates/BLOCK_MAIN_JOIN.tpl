<section class="box box---block-main-join" data-ajaxify="{ callUrl: '{$FACILITATE_AJAX_BLOCK_CALL;*,{BLOCK_PARAMS}}', callParamsFromTarget: ['.*'], targetsSelector: '.form-join' }"><div class="box-inner">
	<h3>{!_JOIN}</h3>

	<div>
		{FORM}
	</div>

	<ul class="horizontal-links associated-links-block-group force-margin">
		<li><a rel="lightbox" target="_blank" title="{!RULES} {!LINK_NEW_WINDOW}" href="{$PAGE_LINK*,:login:redirect={$SELF_URL&*,1}}">{!_LOGIN}</a></li>
		<li><a rel="lightbox" target="_blank" title="{!RULES} {!LINK_NEW_WINDOW}" href="{$PAGE_LINK*,:rules}">{!RULES}</a></li>
	</ul>
</div></section>
