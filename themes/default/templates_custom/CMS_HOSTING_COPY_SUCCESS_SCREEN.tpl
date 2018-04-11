{TITLE}

<p>
	{!HOSTING_COPY_SUCCESS}
</p>

<form action="{INSTALL_URL*}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	{HIDDEN}
	<input type="hidden" name="ftp_folder" value="{FTP_FOLDER*}" />

	<div class="proceed-button">
		<button class="button-screen buttons--proceed" type="submit">{!PROCEED}</button>
	</div>
</form>
