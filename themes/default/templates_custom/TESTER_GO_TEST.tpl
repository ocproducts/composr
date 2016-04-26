<tr class="{$CYCLE,results_table_zebra,zebra_0,zebra_1}">
	<th>
		{TEST} {$,Should not be escaped, as may have lists etc taken from inherited section}
	</th>

	<td>
		<label for="test_{ID*}_0"><input type="radio" id="test_{ID*}_0" name="test_{ID*}" value="0" /> {!TEST_INCOMPLETE}</label>
		<label for="test_{ID*}_1"><input type="radio" id="test_{ID*}_1" name="test_{ID*}" value="1" /> {!TEST_SUCCESSFUL}</label>
		<label for="test_{ID*}_2"><input type="radio" id="test_{ID*}_2" name="test_{ID*}" value="2" /> {!TEST_FAILED}</label>
		<script>// <![CDATA[
			document.getElementById('test_{ID;/}_{VALUE;/}').checked=true;
		//]]></script>
	</td>

	<td>
		<span class="associated_link"><a href="{BUG_REPORT_URL*}" target="_blank" title="{!CREATE_BUG_REPORT}: {ID*} {!LINK_NEW_WINDOW}">{!CREATE_BUG_REPORT}</a></span>
	</td>
</tr>

