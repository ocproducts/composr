{$SET,search,{$_POST,search}}
{$SET,spammer_blackhole,{$INSERT_SPAMMER_BLACKHOLE}}

<link rel="stylesheet" href="http://www.google.com/cse/style/look/default.css" type="text/css" />
{$REQUIRE_CSS,google_search}

<section class="box box___block_side_google_search" data-require-javascript="google_search"
         data-tpl="blockSideGoogleSearch" data-tpl-params="{+START,PARAMS_JSON,search,spammer_blackhole}{_*}{+END}">
    <div class="box_inner">
        {+START,IF_NON_EMPTY,{TITLE}}<h3>{TITLE*}</h3>{+END}

        <div id="cse-search-form" style="width: 100%;">
            <span class="vertical_alignment">{!LOADING}</span>
            <img class="vertical_alignment" alt="" src="{$IMG*,loading}" />
        </div>
    </div>
</section>
