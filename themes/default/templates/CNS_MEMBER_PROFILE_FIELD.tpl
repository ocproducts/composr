{+START,IF_EMPTY,{ENCRYPTED_VALUE}}
	{+START,SET,displayed_field}
		{+START,IF_NON_EMPTY,{ICON}}<img class="vertical-alignment" alt="" width="24" height="24" src="{$IMG*,{ICON}}" />{+END}

		{+START,IF,{$EQ,{!ADDRESS}: {NAME},{!cns_special_cpf:SPECIAL_CPF__cms_country}}}
			<span class="vertical-alignment">{$COUNTRY_CODE_TO_NAME,{RAW}}</span>
		{+END}

		{+START,IF,{$NEQ,{NAME_FULL},{!cns_special_cpf:SPECIAL_CPF__cms_country}}}
			<span class="vertical-alignment">{$SMART_LINK_STRIP,{RENDERED},{MEMBER_ID}}</span>
		{+END}

		<!-- {$,Break out of non-terminated comments in CPF} -->
	{+END}

	{+START,IF_PASSED,EDITABILITY}
		{$SET,edit_type,{EDIT_TYPE}}
		{+START,FRACTIONAL_EDITABLE,{RAW},field_{FIELD_ID},_SEARCH:members:view:{MEMBER_ID}:only_tab=edit:only_subtab=settings,{EDITABILITY}}{$GET,displayed_field}{+END}
	{+END}
	{+START,IF_NON_PASSED,EDITABILITY}
		{$GET,displayed_field}
	{+END}
{+END}
{+START,IF_NON_EMPTY,{ENCRYPTED_VALUE}}
	{!encryption:DATA_ENCRYPTED} <a href="#!" class="js-click-member-profile-about-decrypt-data" title="{!encryption:DECRYPT_DATA}: {$STRIP_TAGS,{!encryption:DESCRIPTION_DECRYPT_DATA}}">{!encryption:DECRYPT_DATA}</a>
{+END}
