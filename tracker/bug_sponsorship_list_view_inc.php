<?php
# MantisBT - a php based bugtracking system

# MantisBT is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# MantisBT is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with MantisBT.  If not, see <http://www.gnu.org/licenses/>.

	/**
	 * This include file prints out the list of users sponsoring the current
	 * bug.	$f_bug_id must be set to the bug id
	 *
	 * @package MantisBT
	 * @copyright Copyright (C) 2000 - 2002  Kenzaburo Ito - kenito@300baud.org
	 * @copyright Copyright (C) 2002 - 2010  MantisBT Team - mantisbt-dev@lists.sourceforge.net
	 * @link http://www.mantisbt.org
	 */

	require_once( 'sponsorship_api.php' );
	require_once( 'collapse_api.php' );

	#
	# Determine whether the sponsorship section should be shown.
	#

	if ( ( config_get( 'enable_sponsorship' ) == ON ) && ( access_has_bug_level( config_get( 'view_sponsorship_total_threshold' ), $f_bug_id ) ) ) {
		$t_sponsorship_ids = sponsorship_get_all_ids( $f_bug_id );

		$t_sponsorships_exist = count( $t_sponsorship_ids ) > 0;
		$t_can_sponsor = !bug_is_readonly( $f_bug_id ) && !current_user_is_anonymous();

		$t_show_sponsorships = $t_sponsorships_exist || $t_can_sponsor;
	} else {
		$t_show_sponsorships = false;
	}

	#
	# Sponsorship Box
	#

	if ( $t_show_sponsorships ) {
?>

<a name="sponsorships" id="sponsorships"></a> <br />

<?php
	collapse_open( 'sponsorship' );
?>

<table class="width100" cellspacing="1">
	<tr>
		<td width="50" rowspan="5">
			<img src="images/dollars.gif" alt="<?php echo lang_get( 'sponsor_verb' ) ?>" border="0" />
		</td>
		<td class="form-title" colspan="2">
		<?php 
			collapse_icon( 'sponsorship' );

			echo lang_get( 'users_sponsoring_bug' );

			$t_details_url = lang_get( 'sponsorship_process_url' );
			if ( !is_blank( $t_details_url ) ) {
				echo '&nbsp;[<a href="' . $t_details_url . '" target="_blank">'
					. lang_get( 'sponsorship_more_info' ) . '</a>]';
			}
		?>
		</td>
	</tr>

<?php
	$f_hours = floatval($hours);
	$f_credits_per = floatval($cms_sc_credits_per_hour);
	$f_price_per = floatval($cms_sc_price_per_credit);
	$f_hours_by_credits = $f_hours*$f_credits_per;
	$cash_needed = $f_hours*$f_credits_per*$f_price_per;
	$cash_needed_string = $cms_sc_main_currency_symbol.number_format($cash_needed).' '.strtoupper($cms_sc_main_currency);
	$cms_sc_main_currency = strtoupper($cms_sc_main_currency);
	$alternate_currencies_links = '';
	if(!empty($cms_sc_alternate_currencies)){
		if(is_array($cms_sc_alternate_currencies)){
			$cur_count = count($cms_sc_alternate_currencies);
			$z = 1;
			foreach($cms_sc_alternate_currencies as $v){
				$alternate_currencies_links .= '<a href="http://www.xe.com/ucc/convert/?Amount='.strval($cash_needed).'&amp;From='.$cms_sc_main_currency.'&amp;To='.strtoupper($v).'" target="_blank">'.strtoupper($v).'</a>';
				if($z !== $cur_count){
					$alternate_currencies_links .= ',&nbsp; ';
				}
				$z++;
			}
			unset($z);		
		} else {
			$alternate_currencies_links .= '<a href="http://www.xe.com/ucc/convert/?Amount='.strval($cash_needed).'&amp;From='.$cms_sc_main_currency.'&amp;To='.strtoupper($cms_sc_alternate_currencies).'" target="_blank">&nbsp;'.strtoupper($cms_sc_alternate_currencies).' etc</a>';
		}
	} else {
		switch ($cms_sc_main_currency){
			case 'EUR':
				$cms_sc_alternate_currencies = 'USD';
				break;
			case 'GBP':
				$cms_sc_alternate_currencies = 'USD';
				break;
			case 'USD':
				$cms_sc_alternate_currencies = 'EUR';
				break;
			case 'CAD':
				$cms_sc_alternate_currencies = 'USD';
				break;
			default:
				$cms_sc_alternate_currencies = 'EUR';
				break;	
		}
		$alternate_currencies_links .= '<a href="http://www.xe.com/ucc/convert/?Amount='.strval($cash_needed).'&amp;From='.$cms_sc_main_currency.'&amp;To='.$cms_sc_alternate_currencies .'" target="_blank">&nbsp;'.$cms_sc_alternate_currencies .' etc</a>';
	}

	if ( $t_can_sponsor ) {
		// Find member's credits
		if ($cms_sc_multi_lang_content)
		{
			$sql='SELECT f.id FROM '.$cms_sc_db_prefix.'f_custom_fields f JOIN '.$cms_sc_db_prefix.'translate t ON t.id=f.cf_name WHERE text_original=\''.$cms_sc_custom_profile_field.'\'';
		} else
		{
			$sql='SELECT f.id FROM '.$cms_sc_db_prefix.'f_custom_fields f WHERE f.cf_name=\''.$cms_sc_custom_profile_field.'\'';
		}
		$result=db_query_bound($sql,array());
		$field_num=db_fetch_array($result);
		$sql='SELECT field_'.strval($field_num['id']).' AS result FROM '.$cms_sc_db_prefix.'f_member_custom_fields WHERE mf_member_id='.auth_get_current_user_id();
		$result=db_query_bound($sql,array());
		$num_credits=db_fetch_array($result);
		$credits_available=isset($num_credits['result'])?$num_credits['result']:0;
		if ($credits_available=='') $credits_available=0;

		// Find how much the user can sponsor
		$result=db_query_bound('SELECT SUM(amount) AS result FROM mantis_sponsorship_table s JOIN mantis_bug_table b ON s.bug_id=b.id WHERE status<80 AND user_id='.auth_get_current_user_id(),array());
		$amount_sponsored=db_fetch_array($result);
		$total_user_sponsored=isset($amount_sponsored['result'])?$amount_sponsored['result']:0;
		if ($total_user_sponsored=='') $total_user_sponsored=0;
		$credits_available_real=$credits_available;
		$credits_sponsored=intval(round($total_user_sponsored/$f_price_per));
		$credits_available-=$credits_sponsored;

		// find the sponsorship so far
		$result=db_query_bound('SELECT SUM(amount) AS result FROM mantis_sponsorship_table WHERE bug_id='.$f_bug_id,array());
		$amount_sponsored=db_fetch_array($result);
		$t_total_sponsorship=isset($amount_sponsored['result'])?$amount_sponsored['result']:0;
		if ($t_total_sponsorship=='') $t_total_sponsorship=0;

?>
	<tr class="row-1">
		<td class="category" width="15%"><?php echo lang_get( 'sponsor_issue' ).lang_get('divide_cost');?></td>
		<td>
			<form method="post" action="bug_set_sponsorship.php">
				<?php if ($hours!=0) { 
				
				?>
				<p><?php echo sprintf(lang_get('cms_sponsor_first_message'), number_format($f_hours), number_format($f_hours_by_credits), $cash_needed_string, $alternate_currencies_links, $cms_sc_business_name, $cms_sc_product_name);?></p>
				<?php } ?>
				<p><?php echo sprintf(lang_get('cms_sponsor_second_message'), $cms_sc_site_url . '/contact/sponsor.htm'); ?></p>

				<?php echo form_security_field( 'bug_set_sponsorship' ) ?>
				<input type="hidden" name="bug_id" value="<?php echo $f_bug_id ?>" size="4" />
				<p>
					<label><input type="text" name="amount_credits" onblur="if (this.value.match(/^\d+$/)) this.form.elements['amount'].value=this.value*<?php echo $f_price_per;?>;" value="" size="20" /> <?php echo lang_get('amount_in_support_credits'); ?></label><?php echo sprintf(lang_get('current_credits_balance'), $credits_available)?> <br />
					<label><input type="text" name="amount" onblur="if (this.value.match(/^\d+$/)) this.form.elements['amount_credits'].value=Math.ceil(this.value/<?php echo $f_price_per;?>);" value="" size="20" /> <?php echo sprintf(lang_get('amount_in_main_currency'), $cms_sc_main_currency)?></label>
				</p>
				<p>
					<input type="submit" class="button" name="sponsor" value="<?php echo lang_get( 'sponsor_verb' ) ?>" />
				</p>
				<?php
				foreach ( $t_sponsorship_ids as $id ) {
					$t_sponsorship = sponsorship_get( $id );
					if ($t_sponsorship->user_id==auth_get_current_user_id()) {
				?>
				<p>
					<?php echo lang_get('filling_in_form_message');?>
				</p>
				<?php
					}
				}
				?>
			</form>
		</td>
	</tr>
<?php
	}

	//$t_total_sponsorship = bug_get_field( $f_bug_id, 'sponsorship_total' );		Can get out of sync!
	$t_total_sponsorship_confirmed = 0;
	if ( $t_total_sponsorship > 0 ) {
?>
	<tr class="row-2">
		<td class="category" width="15%"><?php echo lang_get( 'sponsors_list' ) ?></td>
		<td>
		<?php
			/*echo sprintf( lang_get( 'total_sponsorship_amount' ),
				sponsorship_format_amount( $t_total_sponsorship ) ), ' ('.round(floatval($t_total_sponsorship)/5.5).' support credits)';*/

			if ( access_has_bug_level( config_get( 'view_sponsorship_details_threshold' )
				, $f_bug_id ) ) {
				//echo '<br /><br />';
				$i = 0;
				foreach ( $t_sponsorship_ids as $id ) {
					$t_sponsorship = sponsorship_get( $id );
					$t_date_added = date( config_get( 'normal_date_format' )
						, $t_sponsorship->date_submitted );

					echo ($i > 0) ? '<br />' : '';
					$i++;

					echo $t_date_added . ': ';
					print_user( $t_sponsorship->user_id );
					echo ' - ' , sponsorship_format_amount( $t_sponsorship->amount ) , ' ('.round(floatval($t_sponsorship->amount)/$cms_sc_price_per_credit).' '.lang_get('support_credits').' )';
					if ( access_has_bug_level( config_get( 'handle_sponsored_bugs_threshold' ), $f_bug_id ) ) {
						echo ' ' . get_enum_element( 'sponsorship', $t_sponsorship->paid );
					}
					// Find how many credits they currently have
					if ($cms_sc_multi_lang_content)
					{
						$sql='SELECT f.id FROM '.$cms_sc_db_prefix.'f_custom_fields f JOIN '.$cms_sc_db_prefix.'translate t ON t.id=f.cf_name WHERE text_original=\''.$cms_sc_custom_profile_field.'\'';
					} else
					{
						$sql='SELECT f.id FROM '.$cms_sc_db_prefix.'f_custom_fields f WHERE f.cf_name=\''.$cms_sc_custom_profile_field.'\'';
					}
					$result=db_query_bound($sql,array());
					$field_num=db_fetch_array($result);
					$sql='SELECT field_'.strval($field_num['id']).' AS result FROM '.$cms_sc_db_prefix.'f_member_custom_fields WHERE mf_member_id='.$t_sponsorship->user_id;
					$result=db_query_bound($sql,array());
					$num_credits=db_fetch_array($result);

					// Enough or not?
					if ($num_credits['result']*$cms_sc_price_per_credit>=$t_sponsorship->amount)
					{
						echo lang_get('backed_by_existing_support_credits');
						$t_total_sponsorship_confirmed+=$t_sponsorship->amount;
					} else
					{
						echo lang_get('not_backed_by_existing_support_credits');
						if ($t_sponsorship->user_id==auth_get_current_user_id())
						{
							echo sprintf(lang_get('buy_some'),$cms_sc_commercial_support_url);
						}
					}
				}
			}
		?>
		</td>
		</tr>
		<tr class="row-1">
			<td class="category" width="15%"><?php echo lang_get('progress_theory')?></td>
			<td>
				<progress style="width: 100%" value="<?php echo $t_total_sponsorship; ?>" max="<?php echo $cash_needed; ?>"></progress>
				<?php echo round(100*$t_total_sponsorship/$cash_needed).'% ('.round(($cash_needed-$t_total_sponsorship)/$f_price_per).' '.lang_get('credits_remaining').')'; ?>
			</td>
		</tr>
		<?php if ($tpl_bug->status!=80) { ?>
		<tr class="row-1">
			<td class="category" width="15%"><?php echo lang_get('progress_paid_up')?></td>
			<td>
				<progress style="width: 100%" value="<?php echo $t_total_sponsorship_confirmed; ?>" max="<?php echo $cash_needed; ?>"></progress>
				<?php echo round(100*$t_total_sponsorship_confirmed/$cash_needed).'% ('.round(($cash_needed-$t_total_sponsorship_confirmed)/$f_price_per).' '.lang_get('credits_remaining').')'; ?>
			</td>
		</tr>
		<?php } ?>
<?php
		}
?>
</table>

<?php
	collapse_closed( 'sponsorship' );
?>

<table class="width100" cellspacing="1">
	<tr>
		<td class="form-title">
<?php
			collapse_icon( 'sponsorship' );
			echo lang_get( 'users_sponsoring_bug' );

			$t_details_url = lang_get( 'sponsorship_process_url' );
			if ( !is_blank( $t_details_url ) ) {
				echo '&nbsp;[<a href="' . $t_details_url . '" target="_blank">'
					. lang_get( 'sponsorship_more_info' ) . '</a>]';
			}

	//$t_total_sponsorship = bug_get_field( $f_bug_id, 'sponsorship_total' );
	if ( $t_total_sponsorship > 0 ) {
		echo ' <span style="font-weight: normal;">(';
		echo sprintf( lang_get( 'total_sponsorship_amount' ),
			sponsorship_format_amount( $t_total_sponsorship ) );
		echo ')</span>';
	}
?>
		</td>
	</tr>
</table>

<?php
	collapse_end( 'sponsorship' );
} # If sponsorship enabled
