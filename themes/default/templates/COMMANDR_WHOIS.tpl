<div class="wide-table-wrap"><table class="map-table autosized-table wide-table results-table">
	<tbody>
		<tr>
			<th>{!USERNAME}</th>
			<td>{NAME*}</td>
		</tr>
		<tr>
			<th>{!MEMBER_ID}</th>
			<td>{ID*}</td>
		</tr>
		<tr>
			<th>{!IP_ADDRESS}</th>
			<td>
				{+START,IF_EMPTY,{IP}{IP_LIST}}
					{!UNKNOWN}
				{+END}
				{+START,IF_NON_EMPTY,{IP}{IP_LIST}}
					<ul>
						<li class="whois-ip">{IP*}</li>
						{IP_LIST}
					</ul>
				{+END}
			</td>
		</tr>
		<tr>
			<th>{!ACTIONS}</th>
			<td>
				<ul class="actions-list">
					<li><a href="http://whatismyipaddress.com/ip/{IP*}">Reverse-DNS/WHOIS/Geo-Lookup</a></li>
					<li><a href="https://ping.eu/ping/?host={IP*}">Ping</a></li>
					<li><a href="https://ping.eu/traceroute/?host={IP*}">Tracert</a></li>
				</ul>
			</td>
		</tr>
	</tbody>
</table></div>
