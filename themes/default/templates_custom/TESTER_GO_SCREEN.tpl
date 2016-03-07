{TITLE}

<p>
	{!TEST_ADVICE}
</p>

<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" id="test_form">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div class="testing_sections">
		{SECTIONS}
	</div>

	<div>
		<p>
			<label for="show_for_all">{!SHOW_FOR_ALL}: <input type="checkbox" id="show_for_all" name="show_for_all" value="1" /></label>
		</p>
		<p>
			<label for="show_successful">{!SHOW_SUCCESSFUL}: <input type="checkbox" id="show_successful" name="show_successful" value="1" /></label>
		</p>
	</div>

	<script>// <![CDATA[
		document.getElementById('test_form').elements['show_for_all'].checked={SHOW_FOR_ALL%};
		document.getElementById('test_form').elements['show_successful'].checked={SHOW_SUCCESSFUL%};

		function mark_all_undone()
		{
			var form=document.getElementById('test_form');
			var i;
			for (i=0;i<form.elements.length;i++)
			{
				if (form.elements[i].type=='radio')
				{
					form.elements[i].checked=form.elements[i].value=='0';
				}
			}
		}
	//]]></script>

	<p class="buttons_group">
		<input accesskey="u" onclick="disable_button_just_clicked(this);" class="button_screen buttons__proceed" type="submit" value="{!PROCEED}" />
		<input class="button_screen buttons__yes" type="button" value="{!MARK_ALL_UNDONE}" onclick="window.fauxmodal_confirm('{!MARK_ALL_UNDONE_SURE}',function(answer) { if (answer) mark_all_undone(); });" />
	</p>
</form>

{+START,IF_NON_EMPTY,{ADD_TEST_SECTION_URL}}
	<ul class="actions_list">
		<li><a rel="add" href="{ADD_TEST_SECTION_URL*}">{!ADD_TEST_SECTION}</a></li>
	</ul>
{+END}

