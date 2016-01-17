<body class="website_body zone_running_{$ZONE*} page_running_{$PAGE*}" id="main_website" itemscope="itemscope" itemtype="http://schema.org/WebPage">
	<header itemscope="itemscope" itemtype="http://schema.org/WPHeader" role="banner">
		<div class="row">
			<figure class="logo"><a href="{$PAGE_LINK*,:}"><img src="{$IMG*,composr_homesite/mobile/logo-composr}" alt="Composr logo"></a></figure>

			<div class="headRCol">
				<ul>
					<li>
						{$,Login form for guests}
						{+START,IF,{$IS_GUEST}}
							<div class="top_form">
								{$BLOCK,block=top_login}
							</div>
						{+END}

						{+START,IF,{$NOT,{$IS_GUEST}}}
							<div class="top_buttons">
								{$BLOCK,block=top_notifications}

								{$BLOCK,block=top_personal_stats}
							</div>
						{+END}
					</li>
				</ul>

				<form method="get" action="{$URL_FOR_GET_FORM*,{$PAGE_LINK,site:search}}" class="srhHold">
					{$HIDDENS_FOR_GET_FORM,{$PAGE_LINK,site:search}}

					<input class="srhInp" type="text" placeholder="Search" value="" />

					<div class="srhBtn">
						<input type="submit" title="Search" />
					</div>
				</form>
			</div>
		</div>
	</header>

	{MIDDLE}

   <div class="footer">Copyright &copy; <a href="{$PAGE_LINK*,ocproducts:}">ocProducts Ltd</a>, {$FROM_TIMESTAMP*,%Y}. All Rights Reserved.</div>
</body>
