{$REQUIRE_CSS,downloads_plus}

{$REQUIRE_JAVASCRIPT,jquery.stepcarousel}

	<script>//<![CDATA[
		stepcarousel.setup({
			galleryid: 'mygallery', //id of carousel DIV
			beltclass: 'belt', //class of inner "belt" DIV containing all the panel DIVs
			panelclass: 'panel', //class of panel DIVs each holding content
			autostep: {enable:true, moveby:1, pause:3000},
			panelbehavior: {speed:500, wraparound:false, wrapbehavior:'slide', persist:true},
			defaultbuttons: {enable: true, moveby: 1, leftnav: ['{$IMG;,composr_homesite/left-arrow}', -40, 70], rightnav: ['{$IMG;,composr_homesite/right-arrow}', 10, 70]},
			statusvars: ['statusA', 'statusB', 'statusC'], //register 3 variables that contain current panel (start), current panel (last), and total panels
			contenttype: ['inline'] //content setting ['inline'] or ['ajax', 'path_to_external_file']
		})
	//]]></script>


			<div class="cntRow">
				<h1>Addons (Composr 10)</h1>
			</div>

			<div class="cntRow">
				<div class="addon-box">
					<div class="addon-box-img"><img alt="Utilities" height="98" src="{$IMG*,composr_homesite/admin-ut-icon}" width="98" /></div>

					<div class="addon-box-title">
						<a href="#">Admin Utilities</a><br />
						<span>(6 entries, 0 subcategories)</span>
					</div>
				</div>

				<div class="addon-box">
					<div class="addon-box-img"><img alt="development" height="98" src="{$IMG*,composr_homesite/deve-icon}" width="98" /></div>

					<div class="addon-box-title">
						<a href="#">Development</a><br />
						<span>(16 entries, 0 subcategories)</span>
					</div>
				</div>

				<div class="addon-box">
					<div class="addon-box-img"><img alt="fun and games" height="98" src="{$IMG*,composr_homesite/fun-icon}" width="98" /></div>

					<div class="addon-box-title">
						<a href="#">Fun and Games</a><br />
						<span>(12 entries, 0 subcategories)</span>
					</div>
				</div>

				<div class="addon-box">
					<div class="addon-box-img"><img alt="Graphical" height="98" src="{$IMG*,composr_homesite/graphical-icon}" width="98" /></div>

					<div class="addon-box-title">
						<a href="#">Graphical</a><br />
						<span>(10 entries, 0 subcategories)</span>
					</div>
				</div>

				<div class="addon-box">
					<div class="addon-box-img"><img alt="Information Display" height="98" src="{$IMG*,composr_homesite/info-icon}" width="98" /></div>

					<div class="addon-box-title">
						<a href="#">Information Display</a><br />
						<span>(15 entries, 0 subcategories)</span>
					</div>
				</div>

				<div class="addon-box">
					<div class="addon-box-img"><img alt="New Features" height="98" src="{$IMG*,composr_homesite/feature-icon}" width="98" /></div>

					<div class="addon-box-title">
						<a href="#">New Features</a><br />
						<span>(17 entries, 0 subcategories)</span>
					</div>
				</div>

				<div class="addon-box">
					<div class="addon-box-img"><img alt="Themes" height="98" src="{$IMG*,composr_homesite/theme-icon}" width="98" /></div>

					<div class="addon-box-title">
						<a href="#">Themes</a><br />
						<span>Themes provide a new look to Portal. Themes are a kind of addon. You can actually install the..<br />
						(15 entries, 0 subcategories)</span>
					</div>
				</div>

				<div class="addon-box">
					<div class="addon-box-img"><img alt="Third Party Integration" height="98" src="{$IMG*,composr_homesite/thirdparty-icon}" width="98" /></div>

					<div class="addon-box-title">
						<a href="#">Third Party Integration</a><br />
						<span>(11 entries, 0 subcategories)</span>
					</div>
				</div>

				<div class="addon-box">
					<div class="addon-box-img"><img alt="Translation" height="98" src="{$IMG*,composr_homesite/translation-icon}" width="98" /></div>

					<div class="addon-box-title">
						<a href="#">Translation</a><br />
						<span>(1 entries, 0 subcategories)</span>
					</div>
				</div>

				<div class="addon-box">
					<div class="addon-box-img"><img alt="Uncategorised/ Alpha" height="98" src="{$IMG*,composr_homesite/uncat-icon}" width="98" /></div>

					<div class="addon-box-title">
						<a href="#">Uncategorised/ Alpha</a><br />
						<span>(7 entries, 0 subcategories)</span>
					</div>
				</div>

				<div class="addon-box">
					<div class="addon-box-img"><img alt="Addons" height="98" src="{$IMG*,composr_homesite/addon-icon}" width="98" /></div>

					<div class="addon-box-title">
						<a href="#">Addons</a><br />
						<span>(1 entries, 0 subcategories)</span>
					</div>
				</div>

				<div class="addon-box">
					<div class="addon-box-img"><img alt="Installation" height="98" src="{$IMG*,composr_homesite/installation-icon}" width="98" /></div>

					<div class="addon-box-title">
						<a href="#">Installation</a><br />
						<span>(7 entries, 0 subcategories)</span>
					</div>
				</div>
			</div>

			<div class="cntRow">
				<div class="FTholder headFT">
					Popular Addons:
				</div>

				<div class="FTholder">
					<div class="carosol">
						<div class="stepcarousel galleryFT" id="mygallery">
							<div class="belt">
								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-1}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-2}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-3}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-4}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-5}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-1}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-2}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-3}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-4}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-5}" width="140" /></a>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="FTholder">
					<div class="row-block">
						<h2>Community Advertising</h2>

						<div class="bannerr"><img alt="Community Advertising" height="319" src="{$IMG*,composr_homesite/community_advertising}" width="960" /></div>

						<p>These banners are from the members of the Composr community, bought with <span>points</span>.</p>
					</div>
				</div>
			</div>




			<div class="cntRow">
				<h1>Admin Utilities</h1>
			</div>

			<div class="cntRow">
				<div class="addon-block">
					<h2>Admin Search Stemmer by Chris Graham</h2>

					<div class="addon-block-content">
						<div class="addon-block-img"><img alt="" height="154" src="{$IMG*,composr_homesite/imggg}" width="200" /></div>

						<div class="addon-block-txt">
							<p>Our new Admin Zone search has premiered in 4.0.3. One small thing that is missing is something called a stemmer. A stemmer allows you to search for something like 'publish' in the results. This is the stemmer.</p>

							<div class="addon-block-strip">
								<div class="addon-strip-blk1">
									Downloads: 240
								</div>

								<div class="addon-strip-blk2">
									Added: 14 August 2012
								</div>

								<div class="addon-strip-blk2">
									Rating:
								</div>
							</div>

							<div class="addon-strip-row">
								<strong>License:</strong> GPL
							</div>

							<div class="addon-strip-row">
								<strong>Additional credits/attributions</strong><br />
								Jon Abernathy
							</div>

							<div class="addon-block-more">
								<a href="#">More info</a>
							</div>

							<div class="addon-block-download">
								<a href="#">Download now (1.42 Mb)</a>
							</div>

							<div class="clear"></div>
						</div>

						<div class="clear"></div>
					</div>
				</div>

				<div class="addon-block">
					<h2>Getid3 by Chris Graham</h2>

					<div class="addon-block-content">
						<div class="addon-block-img"><img alt="" height="148" src="{$IMG*,composr_homesite/getid-img}" width="198" /></div>

						<div class="addon-block-txt">
							<p>This addon will automatically detect the Height, Width and Length of video files when they are uploaded to the gallery.</p>

							<div class="addon-block-strip">
								<div class="addon-strip-blk1">
									Downloads: 240
								</div>

								<div class="addon-strip-blk2">
									Added: 14 August 2012
								</div>

								<div class="addon-strip-blk2">
									Rating:
								</div>
							</div>

							<div class="addon-strip-row">
								<strong>License:</strong> GPL
							</div>

							<div class="addon-strip-row">
								<strong>System Requirements/ Dependencies</strong><br />
								galleries
							</div>

							<div class="addon-strip-row">
								<strong>Additional credits/attributions</strong><br />
								James Heinrich, Allan Hansen
							</div>

							<div class="addon-block-more">
								<a href="#">More info</a>
							</div>

							<div class="addon-block-download">
								<a href="#">Download now (1.42 Mb)</a>
							</div>

							<div class="clear"></div>
						</div>

						<div class="clear"></div>
					</div>
				</div>

				<div class="addon-block">
					<h2>Java Uploader Ftp Source Code by Chris Graham</h2>

					<div class="addon-block-content">
						<div class="addon-block-img"><img alt="" height="157" src="{$IMG*,composr_homesite/javauploader-img}" width="179" /></div>

						<div class="addon-block-txt">
							<p>This is a modified version of the third-party Open Source HTML Large File Uploader Code. It has been improved quite significantly to integrate very seamlessly with Composr. This code is included so people can modify it themselves also - but mainly because it is needed in order to generate a signed certificate, so users can see that it is your domain that is certifying the applet as safe.</p>

							<div class="addon-block-strip">
								<div class="addon-strip-blk1">
									Downloads: 204
								</div>

								<div class="addon-strip-blk2">
									Added: 14 August 2012
								</div>

								<div class="addon-strip-blk2">
									Rating:
								</div>
							</div>

							<div class="addon-strip-row">
								<strong>License:</strong> Based on open code posted without license
							</div>

							<div class="addon-strip-row">
								<strong>Additional credits/attributions</strong><br />
								-----
							</div>

							<div class="addon-block-more">
								<a href="#">More info</a>
							</div>

							<div class="addon-block-download">
								<a href="#">Download now (1.42 Mb)</a>
							</div>

							<div class="clear"></div>
						</div>

						<div class="clear"></div>
					</div>
				</div>

				<div class="addon-block">
					<h2>Composr Tutorials by Chris Graham</h2>

					<div class="addon-block-content">
						<div class="addon-block-img"><img alt="Composr Tutorials" height="148" src="{$IMG*,composr_homesite/composor-tutorials-img}" width="204" /></div>

						<div class="addon-block-txt">
							<p>Here is a downloadable archive of the version 4.3 documentation. To view this documentation load up the docs: tutorials page-link (i.e. /docs/index?page=tutorials). You can also use the Debranding tool from the Admin Zone to make documentation point towards your own install, by setting your own site's base URL as the brand URL. The documentation is primarily maintained on our website, and this archive is only provided for those who wish to view it off..</p>

							<div class="addon-block-strip">
								<div class="addon-strip-blk1">
									Downloads: 201
								</div>

								<div class="addon-strip-blk2">
									Added: 14 August 2012
								</div>

								<div class="addon-strip-blk2">
									Rating:
								</div>
							</div>

							<div class="addon-block-more">
								<a href="#">More info</a>
							</div>

							<div class="addon-block-download">
								<a href="#">Download now (1.42 Mb)</a>
							</div>

							<div class="clear"></div>
						</div>

						<div class="clear"></div>
					</div>
				</div>

				<div class="addon-block">
					<h2>ocThumbsUp by Chris Graham</h2>

					<div class="addon-block-content">
						<div class="addon-block-img"><img alt="ocThumbsUp" height="157" src="{$IMG*,composr_homesite/javauploader-img}" width="179" /></div>

						<div class="addon-block-txt">
							<p>ocThumbsUp allows inline attachments to get a custom-created thumbnail, via an integrated editing tool. After creating the attachment an automatic thumbnail will be generated, and then anyone with Admin Zone access gets the chance to customise it by choosing the size, cropping, and scaling.</p>

							<div class="addon-block-strip">
								<div class="addon-strip-blk1">
									Downloads: 180
								</div>

								<div class="addon-strip-blk2">
									Added: 14 August 2012
								</div>

								<div class="addon-strip-blk2">
									Rating:
								</div>
							</div>

							<div class="addon-strip-row">
								<strong>License:</strong> BSD
							</div>

							<div class="addon-strip-row">
								<strong>System Requirements</strong><br />
								GD
							</div>

							<div class="addon-strip-row">
								<strong>Additional credits/attributions</strong><br />
								Webmotionuk.
							</div>

							<div class="addon-block-more">
								<a href="#">More info</a>
							</div>

							<div class="addon-block-download">
								<a href="#">Download now (1.42 Mb)</a>
							</div>

							<div class="clear"></div>
						</div>

						<div class="clear"></div>
					</div>
				</div>

				<div class="addon-block">
					<h2>ocWhitelist by Chris Graham</h2>

					<div class="addon-block-content">
						<div class="addon-block-img"><img alt="Whitelist" height="157" src="{$IMG*,composr_homesite/javauploader-img}" width="179" /></div>

						<div class="addon-block-txt">
							<p>ocThumbsUp allows inline attachments to get a custom-created thumbnail, via an integrated editing tool. After creating the attachment an automatic thumbnail will be generated, and then anyone with Admin Zone access gets the chance to customise it by choosing the size, cropping, and scaling.</p>

							<div class="addon-block-strip">
								<div class="addon-strip-blk1">
									Downloads: 143
								</div>

								<div class="addon-strip-blk2">
									Added: 14 August 2012
								</div>

								<div class="addon-strip-blk2">
									Rating:
								</div>
							</div>

							<div class="addon-strip-row">
								<strong>Code</strong><br />
								[tag...]...[/t
							</div>

							<div class="addon-block-more">
								<a href="#">More info</a>
							</div>

							<div class="addon-block-download">
								<a href="#">Download now (1.42 Mb)</a>
							</div>

							<div class="clear"></div>
						</div>

						<div class="clear"></div>
					</div>
				</div>
			</div>

			<div class="cntRow">
				<div class="FTholder headFT">
					Popular Addons:
				</div>

				<div class="FTholder">
					<div class="carosol">
						<div class="stepcarousel galleryFT" id="mygallery">
							<div class="belt">
								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-1}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-2}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-3}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-4}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-5}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-1}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-2}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-3}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-4}" width="140" /></a>
								</div>

								<div class="panel">
									<a href="#"><img alt="" height="104" src="{$IMG*,composr_homesite/addon-thumb-5}" width="140" /></a>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="FTholder">
					<div class="row-block">
						<h2>Community Advertising</h2>

						<div class="bannerr"><img alt="Community Advertising" height="319" src="{$IMG*,composr_homesite/community_advertising}" width="960" /></div>

						<p>These banners are from the members of the Composr community, bought with <a href="{$PAGE_LINK*,site:pointstore}">points</a></p>
					</div>
				</div>
			</div>



{TITLE}

{+START,IF_NON_EMPTY,{DESCRIPTION}}
	<div itemprop="description">
		{DESCRIPTION}
	</div>
{+END}

{$SET,bound_catalogue_entry,{$CATALOGUE_ENTRY_FOR,download_category,{ID}}}
{+START,IF_NON_EMPTY,{$GET,bound_catalogue_entry}}{$CATALOGUE_ENTRY_ALL_FIELD_VALUES,{$GET,bound_catalogue_entry}}{+END}

{+START,IF_NON_EMPTY,{SUBCATEGORIES}}
	<div class="box box___download_category_screen"><div class="box_inner compacted_subbox_stream">
		<h2>{$?,{$EQ,{ID},1},{!CATEGORIES},{!SUBCATEGORIES_HERE}}</h2>

		<div>
			{SUBCATEGORIES}
		</div>
	</div></div>
{+END}

{+START,IF_NON_EMPTY,{DOWNLOADS}}
	{DOWNLOADS}

	<div class="box category_sorter inline_block"><div class="box_inner">
		{$SET,show_sort_button,1}
		{SORTING}
	</div></div>
{+END}

{+START,IF,{$CONFIG_OPTION,show_content_tagging}}{TAGS}{+END}

{$REVIEW_STATUS,download_category,{ID}}

{+START,INCLUDE,NOTIFICATION_BUTTONS}
	NOTIFICATIONS_TYPE=download
	NOTIFICATIONS_ID={ID}
	BREAK=1
	RIGHT=1
{+END}

{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
{+START,INCLUDE,STAFF_ACTIONS}
	1_URL={SUBMIT_URL*}
	1_TITLE={!ADD_DOWNLOAD}
	1_REL=add
	1_ICON=menu/_generic_admin/add_one
	2_URL={ADD_CAT_URL*}
	2_TITLE={!ADD_DOWNLOAD_CATEGORY}
	2_REL=add
	2_ICON=menu/_generic_admin/add_one_category
	3_ACCESSKEY=q
	3_URL={EDIT_CAT_URL*}
	3_TITLE={!EDIT_DOWNLOAD_CATEGORY}
	3_REL=edit
	3_ICON=menu/_generic_admin/edit_this_category
{+END}

{+START,IF,{$CONFIG_OPTION,show_screen_actions}}{+START,IF_PASSED,_TITLE}{$BLOCK,failsafe=1,block=main_screen_actions,title={$META_DATA,title}}{+END}{+END}

{+START,IF_NON_EMPTY,{SUBCATEGORIES}}{+START,IF,{$EQ,{ID},1}}
	<hr class="spaced_rule" />

	<div class="boxless_space">
		{+START,BOX}{$BLOCK,block=main_multi_content,param=download,filter={ID}*,no_links=1,efficient=0,give_context=0,include_breadcrumbs=1,render_if_empty=1,max=10,mode=recent,title={!RECENT,10,{!SECTION_DOWNLOADS}}}{+END}

		{+START,IF,{$CONFIG_OPTION,is_on_rating}}
			{+START,BOX}{$BLOCK,block=main_multi_content,param=download,filter={ID}*,no_links=1,efficient=0,give_context=0,include_breadcrumbs=1,render_if_empty=1,max=10,mode=top,title={!TOP,10,{!SECTION_DOWNLOADS}}}{+END}
		{+END}
	</div>
{+END}{+END}
