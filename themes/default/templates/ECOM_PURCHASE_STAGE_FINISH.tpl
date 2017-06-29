{$REQUIRE_CSS,messages}

<div class="site_special_message {$?,{SUCCESS},ssm_inform,ssm_warn}" role="alert">
	<div class="site_special_message_inner">
		<div class="box box___ecom_purchase_stage_finish"><div class="box_inner">
			{+START,IF_NON_PASSED,MESSAGE}
				{$PARAGRAPH,{$?,{$OR,{$_GET,keep_ecommerce_local_test},{$CONFIG_OPTION,use_local_payment}},{!PURCHASE_FINISHED_SIMPLE},{!PURCHASE_FINISHED}}}
			{+END}
			{+START,IF_PASSED,MESSAGE}
				{$PARAGRAPH,{$REPLACE,  ,<br />,{MESSAGE*}}}
			{+END}
		</div></div>
	</div>
</div>
