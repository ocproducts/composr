{TITLE}

{$GET,whisper_screen_text}

<div class="cns-whisper-lead-in">
	<img src="{$IMG*,icons/48x48/buttons/new_topic}" alt="" class="right" />

	{+START,IF,{$HAS_PRIVILEGE,use_pt}}<p>{!WHISPER_TEXT}</p>{+END}
</div>


<div class="float-surrounder">
	{+START,IF,{$HAS_PRIVILEGE,use_pt}}
		<div class="cns-whisper-choose-box right">
			<div class="box box___cns_whisper_choice_screen"><div class="box-inner">
				<h2>{!PRIVATE_TOPIC}</h2>

				<form title="{!PRIVATE_TOPIC}" action="{$URL_FOR_GET_FORM*,{URL}}" method="get" autocomplete="off">
					{$HIDDENS_FOR_GET_FORM,{URL}}

					<div>
						<p>{!WHISPER_PT,{$DISPLAYED_USERNAME*,{USERNAME}}}</p>

						<input type="hidden" name="type" value="new_pt" />

						<p class="proceed_button">
							<input class="button-screen buttons--new-topic" type="submit" data-disable-on-click="1" value="{!QUOTE_TO_PT}" />
						</p>
					</div>
				</form>
			</div></div>
		</div>
	{+END}

	<div class="cns-whisper-choose-box">
		<div class="box box___cns_whisper_choice_screen"><div class="box-inner">
			<h2>{!PERSONAL_POST}</h2>

			<form title="{!PERSONAL_POST}" action="{$URL_FOR_GET_FORM*,{URL}}" method="get" autocomplete="off">
				{$HIDDENS_FOR_GET_FORM,{URL}}

				<div>
					<p>{!WHISPER_PP,{$DISPLAYED_USERNAME*,{USERNAME}}}</p>

					<input type="hidden" name="type" value="new_post" />

					<p class="proceed_button">
						<input class="button-screen buttons--new-post-full" type="submit" data-disable-on-click="1" value="{!IN_TOPIC_PP}" />
					</p>
				</div>
			</form>
		</div></div>
	</div>
</div>

<p class="back_button">
	<a href="#!" data-cms-btn-go-back="1"><img title="{!NEXT_ITEM_BACK}" alt="{!NEXT_ITEM_BACK}" src="{$IMG*,icons/48x48/menu/_generic_admin/back}" /></a>
</p>
