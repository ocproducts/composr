{TITLE}

<p>
	{!HOSTING_COPY_SUCCESS}
</p>

<form action="{INSTALL_URL*}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	{HIDDEN}
	<input type="hidden" name="ftp_folder" value="{FTP_FOLDER*}" />

	<div class="proceed_button">
		<input class="button-screen buttons--proceed" type="submit" value="{!PROCEED}" />
	</div>
</form>
