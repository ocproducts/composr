{$REQUIRE_CSS,composr_homesite__tutorials}

<div class="cntRow">
	{TITLE}
	{$METADATA,breadcrumb_self,Tutorials}

	<div class="tut-row">
		<div class="leftMenu">
			<ul>
				{+START,LOOP,TAGS}
					<li>
						<a href="{$PAGE_LINK*,_SEARCH:tutorials:{_loop_var}}"{+START,IF,{$EQ,{$_GET,type},{_loop_var}}} class="active"{+END}>{_loop_var*}</a>
					</li>
				{+END}
			</ul>
		</div>

		<div class="right">
			{+START,IF_NON_EMPTY,{$_POST,search}}
				<div id="cse">
				</div>
			{+END}

			{+START,IF_EMPTY,{$_POST,search}}
				{+START,LOOP,TUTORIALS}
					<div class="tbox">
						<h2>
							{TITLE*}

							<a href="{URL*}"><img alt="Go to tutorial" height="20" src="{$IMG*,composr_homesite/tutorials/next}" width="20" /></a>
						</h2>

						<div class="content">
							<div class="lf"><a class="left spaced" href="{URL*}"><img width="145" src="{ICON*}" alt="" /></a></div>

							<div class="blk">
								<div class="txt">
									{SUMMARY*}
								</div>

								<div class="bottom">
									<div class="float_surrounder">
										{+START,IF_NON_EMPTY,{AUTHOR}}
											<div class="blk1">
												by <abbr title="{AUTHOR*}">{$PREG_REPLACE, .*$,,{$PREG_REPLACE,^(Dr) ,$1&nbsp;,{AUTHOR*}}}</abbr>
											</div>
										{+END}

										<div class="blk2 blk2Long">
											<span>Tags:</span>
											{+START,LOOP,TAGS}
												<a href="{$PAGE_LINK*,_SEARCH:tutorials:{_loop_var}}">{_loop_var*}</a>{+START,IF,{$NEQ,{_loop_key},{$SUBTRACT,{TAGS},1}}},{+END}
											{+END}
										</div>
									</div>

									<div class="float_surrounder">
										<div class="blk1">
											{+START,IF,{$EQ,{ADD_DATE},{EDIT_DATE}}}
												<abbr title="Edited: {EDIT_DATE*}">{ADD_DATE*}</abbr>
											{+END}

											{+START,IF,{$NEQ,{ADD_DATE},{EDIT_DATE}}}
												{ADD_DATE*}
											{+END}
										</div>

										<div class="blk2">
											{$?,{CORE},Core,Auxillary} Doc;

											<span>Difficulty:</span>
											{$UCASE*,{DIFFICULTY_LEVEL},1}
										</div>

										<div class="blk3">
											<a href="{URL*}">&gt;&gt; {+START,CASES,{MEDIA_TYPE}}
												document=Read more
												video=Watch video
												audio=Listen
												slideshow=View slideshow
												book=Buy book
											{+END}</a>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				{+END}
			{+END}

			<h2>Need better information{+START,IF_NON_EMPTY,{TAG_SELECTED}} on {TAG_SELECTED*}{+END}?</h2>

			<p>The Composr documentation is user-driven:</p>

			<div class="list">
				<ul>
				<li>If you have found documentation problems that you'd like someone else to solve log an <a target="_blank" href="http://compo.sr/tracker/set_project.php?project_id=7">issue to the tracker</a>.</li>
				<li>If you'd like to contribute a chunk of documentation to go into a tutorial, also log an <a target="_blank" href="http://compo.sr/tracker/set_project.php?project_id=7">issue to the tracker</a>. As&nbsp;a&nbsp;user, it is possible you may find some useful extra tidbits of information there.</li>
				<li>If you want to contribute a new tutorial you can submit a link.</li>
				</ul>
			</div>

			<div class="button">
				<a href="{$PAGE_LINK*,_SEARCH:cms_tutorials}">Submit a link</a>
			</div>
		</div>
	</div>
</div>
