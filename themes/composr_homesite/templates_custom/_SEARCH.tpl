{+START,IF,{$OR,{$IN_STR,{$BASE_URL},https://},{$EQ,{$ZONE},docs}}}
	<div id="cse-search-form" class="srhHold">
		<img aria-busy="true" alt="Loading" class="vertical_alignment" src="{$IMG*,loading}" />
	</div>

	<script src="https://www.google.com/jsapi" type="text/javascript"></script>

	<script type="text/javascript">// <![CDATA[
		google.load('search','1',{language:'en'});

		google.setOnLoadCallback(function() {
			var customSearchControl=new google.search.CustomSearchControl('');
			customSearchControl.setResultSetSize(google.search.Search.FILTERED_CSE_RESULTSET);
			var options=new google.search.DrawOptions();
			options.setSearchFormRoot('cse-search-form');
			customSearchControl.draw('cse',options);

			var cse_form=document.getElementById('cse-search-form');

			var search_input=get_elements_by_class_name(cse_form,'gsc-input')[1];
			search_input.placeholder='Search tutorials';

			var search_button=get_elements_by_class_name(cse_form,'gsc-search-button')[1];
			search_button.value='Search tutorials';

			get_elements_by_class_name(cse_form,'gsc-search-box')[0].action='{$SELF_URL;}';
			get_elements_by_class_name(cse_form,'gsc-search-box')[0].method='post';
			get_elements_by_class_name(cse_form,'gsc-search-box')[0].innerHTML+='{$INSERT_SPAMMER_BLACKHOLE;^/}';
			get_elements_by_class_name(cse_form,'gsc-search-box')[0].onkeypress=function(event) {
				if (enter_pressed(event))
					get_elements_by_class_name(cse_form,'gsc-search-box')[0].submit();
			};
			get_elements_by_class_name(cse_form,'gsc-search-button')[0].onclick=function() {
				get_elements_by_class_name(cse_form,'gsc-search-box')[0].submit();
			};

			{+START,IF_NON_EMPTY,{$_POST,search}}
				customSearchControl.execute('{$_POST;/,search}'); // Relay through search from prior page
			{+END}

		},true);
	//]]></script>
{+END}

{+START,IF,{$NOR,{$IN_STR,{$BASE_URL},https://},{$EQ,{$ZONE},docs}}}
	<form method="get" action="{$URL_FOR_GET_FORM*,{$PAGE_LINK,site:search}}" class="srhHold">
		{$HIDDENS_FOR_GET_FORM,{$PAGE_LINK,site:search}}

		<input class="srhInp" type="text" placeholder="Search" value="" />

		<div class="srhBtn">
			<input type="submit" title="Search" />
		</div>
	</form>
{+END}
