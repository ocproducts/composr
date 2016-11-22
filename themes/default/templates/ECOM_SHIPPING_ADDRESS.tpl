<table class="map_table shipping_address autosized_table"><tbody>
	<tr><th>{!NAME}</th><td>{FIRSTNAME*} {LASTNAME*}</td></tr>
	<tr><th>{$PREG_REPLACE,.*: ,,{!SPECIAL_CPF__cms_street_address}}</th><td>{$REPLACE*,\n,<br />,{STREET_ADDRESS}}</td></tr>
	<tr><th>{$PREG_REPLACE,.*: ,,{!SPECIAL_CPF__cms_city}}</th><td>{CITY*}</td></tr>
	<tr><th>{$PREG_REPLACE,.*: ,,{!SPECIAL_CPF__cms_county}}</th><td>{COUNTY*}</td></tr>
	<tr><th>{$PREG_REPLACE,.*: ,,{!SPECIAL_CPF__cms_state}}</th><td>{STATE*}</td></tr>
	<tr><th>{$PREG_REPLACE,.*: ,,{!SPECIAL_CPF__cms_post_code}}</th><td>{POST_CODE*}</td></tr>
	<tr><th>{$PREG_REPLACE,.*: ,,{!SPECIAL_CPF__cms_country}}</th><td>{COUNTRY*}</td></tr>
	<tr><th>{!EMAIL_ADDRESS}</th><td>{EMAIL*}</td></tr>
	<tr><th>{!PHONE_NUMBER}</th><td>{PHONE*}</td></tr>
</tbody></table>
