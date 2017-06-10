<section class="box box___block_main_join"><div class="box_inner">
	<h3>{!_JOIN}</h3>

	{FORM}

	{+START,IF_PASSED,JAVASCRIPT}
		<script>// <![CDATA[
			{JAVASCRIPT/}
		//]]></script>
	{+END}

	<ul class="horizontal_links associated_links_block_group force_margin">
		<li><a rel="lightbox" target="_blank" title="{!RULES} {!LINK_NEW_WINDOW}" href="{$PAGE_LINK*,:login:redirect={$SELF_URL&*,1}}">{!_LOGIN}</a></li>
		<li><a rel="lightbox" target="_blank" title="{!RULES} {!LINK_NEW_WINDOW}" href="{$PAGE_LINK*,:rules}">{!RULES}</a></li>
	</ul>
</div></section>
