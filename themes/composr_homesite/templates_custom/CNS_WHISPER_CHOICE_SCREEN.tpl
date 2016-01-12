{+START,SET,whisper_screen_text}
	{+START,IF,{$EQ,{$USERNAME,{$_GET,intended_solely_for}},Chris Graham}}
		{+START,BOX}
			You are sending a whisper to Chris Graham. Please don't ask for free technical support from Chris, as as an employee (Managing Director) of ocProducts he works on Composr as his commercial full time job, and hence needs to charge for his time under <a href="{$PAGE_LINK*,site:professional_support}">ocProducts's support system</a>. By all means use the forum for free consultation with other users if you don't want to use ocProducts' support plan, but please avoid soliciting free support from ocProducts directly.
		{+END}
	{+END}
{+END}

{+START,INCLUDE,CNS_WHISPER_CHOICE_SCREEN}{+END}
