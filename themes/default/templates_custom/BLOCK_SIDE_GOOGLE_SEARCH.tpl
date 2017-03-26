<section class="box box___block_side_google_search"><div class="box_inner">
	{+START,IF_NON_EMPTY,{TITLE}}<h3>{TITLE*}</h3>{+END}

	<div id="cse-search-form" style="width: 100%;">
		<span class="vertical_alignment">{!LOADING}</span>
		<img class="vertical_alignment" alt="" src="{$IMG*,loading}" />
	</div>

	<script src="https://www.google.com/jsapi" type="text/javascript"></script>

	<script type="text/javascript">// <![CDATA[
    google.load('search', '1', { language: 'en' });
    google.setOnLoadCallback(function() {
        var customSearchControl = new google.search.CustomSearchControl('');
        customSearchControl.setResultSetSize(google.search.Search.FILTERED_CSE_RESULTSET);
        var options = new google.search.DrawOptions();
        options.setSearchFormRoot('cse-search-form');
        customSearchControl.draw('cse', options);

        var cse_form = document.getElementById('cse-search-form');

        if (!document.getElementById('cse')) {// Not on the results page, so we need to direct the search to it
            cse_form.querySelector('.gsc-search-box').action = '{$PAGE_LINK;/,_SEARCH:{PAGE_NAME}}';
            cse_form.querySelector('.gsc-search-box').method = 'post';
            cse_form.querySelector('.gsc-search-box').innerHTML += '{$INSERT_SPAMMER_BLACKHOLE;^/}';
            cse_form.querySelector('.gsc-search-button').onclick = function () {
                cse_form.querySelector('.gsc-search-box').submit();
            };
        } else {// On result page, so normal operation
            cse_form.querySelector('.gsc-search-button').onclick = function () {
                var no_search_entered = document.getElementById('no_search_entered');
                if (no_search_entered) {
                    no_search_entered.parentNode.removeChild(no_search_entered);
                }
            };

            {+START,IF_NON_EMPTY,{$_POST,search}}
                customSearchControl.execute('{$_POST;/,search}'); // Relay through search from prior page
            {+END}
        }

    },true);
	//]]></script>

	<link rel="stylesheet" href="http://www.google.com/cse/style/look/default.css" type="text/css" />
	{$REQUIRE_CSS,google_search}
</div></section>
