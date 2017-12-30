{$,Used to display the shipping address of an order}

<table class="map_table results-table shipping_address autosized-table"><tbody>
	<tr><th>{!NAME}</th><td>{FIRSTNAME*} {LASTNAME*}</td></tr>
	<tr><th>{$PREG_REPLACE,.*: ,,{!SPECIAL_CPF__cms_street_address}}</th><td>{$REPLACE*,
,<br />,{STREET_ADDRESS}}</td></tr>
	<tr><th>{$PREG_REPLACE,.*: ,,{!SPECIAL_CPF__cms_city}}</th><td>{CITY*}</td></tr>
	<tr><th>{$PREG_REPLACE,.*: ,,{!SPECIAL_CPF__cms_county}}</th><td>{COUNTY*}</td></tr>
	<tr><th>{$PREG_REPLACE,.*: ,,{!SPECIAL_CPF__cms_state}}</th><td>{STATE*}</td></tr>
	<tr><th>{$PREG_REPLACE,.*: ,,{!SPECIAL_CPF__cms_post_code}}</th><td>{POST_CODE*}</td></tr>
	<tr><th>{$PREG_REPLACE,.*: ,,{!SPECIAL_CPF__cms_country}}</th><td>{$COUNTRY_CODE_TO_NAME*,{COUNTRY}}</td></tr>
	<tr><th>{!EMAIL_ADDRESS}</th><td>{EMAIL*}</td></tr>
	<tr><th>{!PHONE_NUMBER}</th><td>{PHONE*}</td></tr>
</tbody></table>
