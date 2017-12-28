{$REQUIRE_JAVASCRIPT,filedump}

{$SET,file_link,}
{+START,IF_NON_EMPTY,{$_GET,filename}}
	{$SET,file_link,{$PAGE_LINK;,_SELF:_SELF:embed:place={$_GET&,place}:file={$_GET&,filename}:wide_high=1}}
{+END}

<div data-tpl="filedumpScreen" data-tpl-params="{+START,PARAMS_JSON,file_link}{_*}{+END}">
	{TITLE}

	<div class="filedump-screen">
		<div class="float-surrounder"><div class="tabs" role="tablist">
			<a aria-controls="g_thumbnails" role="tab" href="#!" id="t_thumbnails" class="tab tab_active tab_first js-click-select-tab-g" data-tp-tab="thumbnails"><span>{!VIEW_THUMBNAILS}</span></a>

			<a aria-controls="g_listing" role="tab" href="#!" id="t_listing" class="tab{+START,IF_EMPTY,{CREATE_FOLDER_FORM}{UPLOAD_FORM}} tab_last{+END} js-click-select-tab-g" data-tp-tab="listing"><span>{!VIEW_LISTING}</span></a>

			{+START,IF_NON_EMPTY,{CREATE_FOLDER_FORM}}
				<a aria-controls="g_create_folder" role="tab" href="#!" id="t_create_folder" class="tab{+START,IF_EMPTY,{UPLOAD_FORM}} tab_last{+END} js-click-select-tab-g" data-tp-tab="create_folder"><span>{!FILEDUMP_CREATE_FOLDER}</span></a>
			{+END}

			{+START,IF_NON_EMPTY,{UPLOAD_FORM}}
				<a aria-controls="g_upload" role="tab" href="#!" id="t_upload" class="tab tab_last js-click-select-tab-g" data-tp-tab="upload"><span>{!UPLOAD}</span></a>
			{+END}
		</div></div>
		<div class="tab-surround">
			<div aria-labeledby="t_thumbnails" role="tabpanel" id="g_thumbnails" style="display: block">
				<a id="tab__thumbnails"></a>

				{+START,INCLUDE,FILEDUMP_SEARCH}
					I=1
					TAB=thumbnails
				{+END}

				<form class="js-submit-check-filedump-selections" title="{!ACTION}" action="{POST_URL*}" autocomplete="off">
					{$INSERT_SPAMMER_BLACKHOLE}

					{+START,IF_NON_EMPTY,{THUMBNAILS}}
						<div class="float-surrounder filedump-thumbnails">
							{+START,LOOP,THUMBNAILS}
								<div class="box"><div class="box-inner">
									{+START,IF,{CHOOSABLE}}
										<span class="filedump-select">{ACTIONS}</span>
									{+END}

									{+START,IF_PASSED,EMBED_URL}
										<p class="filedump-embed"><a id="embed_link_{FILENAME|*}" href="{EMBED_URL*}" data-open-as-overlay='{"width": 950, "height": 680}' class="link_exempt">{!_FILEDUMP_EMBED}</a></p>
									{+END}

									<p><a {+START,IF,{IS_IMAGE}} rel="lightbox"{+END} href="{URL*}">{THUMBNAIL}</a></p>

									<p class="meta associated-details">
										<strong>{FILENAME*}</strong><br />
										<span class="associated-details">({+START,IF_NON_EMPTY,{_SIZE}}{SIZE*}{+END}{+START,IF_NON_EMPTY,{DATE}}{+START,IF_NON_EMPTY,{_SIZE}}, {+END}{DATE*}{+END}{+START,IF_NON_EMPTY,{WIDTH}}, {WIDTH*}&times;{HEIGHT*}{+END})</span>
									</p>
								</div></div>
							{+END}
						</div>
					{+END}
					{+START,IF_EMPTY,{THUMBNAILS}}
						<p class="nothing_here">{!NO_ENTRIES}</p>
					{+END}

					{+START,INCLUDE,FILEDUMP_FOOTER}I=1{+END}
				</form>

				{+START,INCLUDE,NOTIFICATION_BUTTONS}
					NOTIFICATIONS_TYPE=filedump
					NOTIFICATIONS_ID={PLACE}
					RIGHT=1
				{+END}

				{+START,IF_NON_EMPTY,{PAGINATION_THUMBNAILS}}
					<div class="float-surrounder force_margin">
						{PAGINATION_THUMBNAILS}
					</div>
				{+END}
			</div>

			<div aria-labeledby="t_listing" role="tabpanel" id="g_listing" style="display: none">
				<a id="tab__listing"></a>

				{+START,INCLUDE,FILEDUMP_SEARCH}
					I=2
					TAB=listing
				{+END}

				<form class="js-submit-check-filedump-selections" title="{!ACTION}" action="{POST_URL*}" method="post" autocomplete="off">
					{$INSERT_SPAMMER_BLACKHOLE}

					{+START,IF_NON_EMPTY,{LISTING}}
						{LISTING}
					{+END}
					{+START,IF_EMPTY,{LISTING}}
						<p class="nothing_here">{!NO_ENTRIES}</p>
					{+END}

					{+START,INCLUDE,FILEDUMP_FOOTER}I=2{+END}
				</form>

				{+START,INCLUDE,NOTIFICATION_BUTTONS}
					NOTIFICATIONS_TYPE=filedump
					NOTIFICATIONS_ID={PLACE}
					RIGHT=1
				{+END}

				{+START,IF_NON_EMPTY,{PAGINATION_LISTING}}
					<div class="float-surrounder force_margin">
						{PAGINATION_LISTING}
					</div>
				{+END}
			</div>

			{+START,IF_NON_EMPTY,{CREATE_FOLDER_FORM}}
				<div aria-labeledby="t_create_folder" role="tabpanel" id="g_create_folder" style="display: none">
					<a id="tab__create_folder"></a>

					{+START,INCLUDE,FORM_SCREEN_ARE_REQUIRED}{+END}

					{CREATE_FOLDER_FORM}
				</div>
			{+END}

			{+START,IF_NON_EMPTY,{UPLOAD_FORM}}
				<div aria-labeledby="t_upload" role="tabpanel" id="g_upload" style="display: none">
					<a id="tab__upload"></a>

					{+START,INCLUDE,FORM_SCREEN_ARE_REQUIRED}{+END}

					{UPLOAD_FORM}
				</div>
			{+END}
		</div>
	</div>

	{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
	{+START,IF,{$AND,{$SHOW_DOCS},{$HAS_PRIVILEGE,see_software_docs}}}
		{+START,INCLUDE,STAFF_ACTIONS}
			STAFF_ACTIONS_TITLE={!STAFF_ACTIONS}

			1_URL={$TUTORIAL_URL*,tut_collaboration}
			1_TITLE={!HELP}
			1_REL=help
			1_ICON=menu/pages/help

			{+START,IF,{$IS_ADMIN}}
				2_URL={$PAGE_LINK*,_SELF:_SELF:broken}
				2_TITLE={!FIND_BROKEN_FILEDUMP_LINKS}
				2_ICON=menu/adminzone/tools/cleanup
			{+END}
		{+END}
	{+END}
</div>
