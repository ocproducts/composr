{TITLE}

<p>
	{!EXPORT_DO_THIS}
</p>

<form title="{!PRIMARY_PAGE_FORM}" method="post" action="index.php">
	<h2><label for="xml_results">{!_RESULTS}</label></h2>

	<div class="constrain_field">
		<textarea readonly="readonly" name="xml_results" id="xml_results" cols="70" rows="30" class="wide_field textarea_scroll">{XML*}</textarea>
	</div>
</form>
