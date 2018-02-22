<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    testing_platform
 */

/**
 * Composr test case class (unit testing).
 */
class comcode_code_test_set extends cms_test_case
{
    public function testComcodeCodeTags()
    {
        set_option('eager_wysiwyg', '0');

        require_code('comcode_from_html');

        $cases = array();

        // 0
        $from = '[code]Food & Drink[/code]'; // Vanilla non-WYSIWYG
        $to = '<div class="comcode_code_wrap"><div class="comcode_code"><h4>Code</h4><div class="webstandards_checker_off"><code class="comcode_code_inner">Food &amp; Drink</code></div></div></div>';
        $forced_html_to_comcode = false;
        $do_for_admin_too = true;
        $cases[] = array($from, $to, $forced_html_to_comcode, $do_for_admin_too);

        // 1
        $from = '[code]Food &amp; Drink[/code]'; // This is INCORRECT, and we therefore expect it to not parse correctly
        $to = '<div class="comcode_code_wrap"><div class="comcode_code"><h4>Code</h4><div class="webstandards_checker_off"><code class="comcode_code_inner">Food &amp;amp; Drink</code></div></div></div>';
        $forced_html_to_comcode = false;
        $do_for_admin_too = true;
        $cases[] = array($from, $to, $forced_html_to_comcode, $do_for_admin_too);

        // 2
        $from = '[semihtml][code]Food &amp; Drink[/code][/semihtml]'; // Vanilla WYSIWYG
        $to = '<div class="comcode_code_wrap"><div class="comcode_code"><h4>Code</h4><div class="webstandards_checker_off"><code class="comcode_code_inner">Food &amp; Drink</code></div></div></div>';
        $forced_html_to_comcode = false;
        $do_for_admin_too = true;
        $cases[] = array($from, $to, $forced_html_to_comcode, $do_for_admin_too);

        // 3
        $from = '[semihtml][code]Food & Drink[/code][/semihtml]'; // The entity error will be auto-fixed within parser behaviours
        $to = '<div class="comcode_code_wrap"><div class="comcode_code"><h4>Code</h4><div class="webstandards_checker_off"><code class="comcode_code_inner">Food &amp; Drink</code></div></div></div>';
        $forced_html_to_comcode = false;
        $do_for_admin_too = true;
        $cases[] = array($from, $to, $forced_html_to_comcode, $do_for_admin_too);

        // 4
        $from = '[html][code]Food &amp; Drink[/code][/html]'; // This is INCORRECT, and we therefore expect it to not parse correctly
        $to = '[code]Food &amp; Drink[/code]';
        $forced_html_to_comcode = false;
        $do_for_admin_too = true;
        $cases[] = array($from, $to, $forced_html_to_comcode, $do_for_admin_too);

        // 5
        $from = '[semihtml][code]<div>Food &amp; Drink</div><br /><div>On the house</div>[/code][/semihtml]'; // Complex WYSIWYG (HTML within code tag adjusted to Comcode-Textcode-formatting)
        $to = '<div class="comcode_code_wrap"><div class="comcode_code"><h4>Code</h4><div class="webstandards_checker_off"><code class="comcode_code_inner">Food &amp; Drink<br /><br />On the house<br /></code></div></div></div>';
        $forced_html_to_comcode = false;
        $do_for_admin_too = true;
        $cases[] = array($from, $to, $forced_html_to_comcode, $do_for_admin_too);

        // 6
        $from = '[semihtml][code]<composr-test>Food &amp; Drink</composr-test><br /><composr-test>On the house</composr-test>[/code][/semihtml]'; // Complex WYSIWYG (exotic HTML within code tag carries through)
        $to = '<div class="comcode_code_wrap"><div class="comcode_code"><h4>Code</h4><div class="webstandards_checker_off"><code class="comcode_code_inner"><composr-test>Food &amp; Drink</composr-test><br /><composr-test>On the house</composr-test></code></div></div></div>';
        $forced_html_to_comcode = false;
        $do_for_admin_too = true;
        $cases[] = array($from, $to, $forced_html_to_comcode, $do_for_admin_too);

        // 7
        $from = '[semihtml][code]Food &amp; Drink<script>window.alert("!");</script>[/code][/semihtml]'; // Security: It's essential that unsafe code is stripped, as it would be easy to accidentally let it leak through within code tag parsing (we read it in verbatim where we normally apply the security and have to filter it later, depending on the output transformations required by the particular code type)
        $to = '<div class="comcode_code_wrap"><div class="comcode_code"><h4>Code</h4><div class="webstandards_checker_off"><code class="comcode_code_inner">Food &amp; Drinkwindow.alert(&quot;!&quot;);</code></div></div></div>';
        $forced_html_to_comcode = false;
        $do_for_admin_too = false;
        $cases[] = array($from, $to, $forced_html_to_comcode, $do_for_admin_too);

        // 8
        $from = "[code] x  y\nz[/code]"; // White-space preservation for non-WYSIWYG
        $to = '<div class="comcode_code_wrap"><div class="comcode_code"><h4>Code</h4><div class="webstandards_checker_off"><code class="comcode_code_inner">&nbsp;x &nbsp;y<br />z</code></div></div></div>';
        $forced_html_to_comcode = false;
        $do_for_admin_too = true;
        $cases[] = array($from, $to, $forced_html_to_comcode, $do_for_admin_too);

        // 9
        $from = "[semihtml][code]&nbsp;x &nbsp;y<br />z[/code][/semihtml]"; // White-space preservation for WYSIWYG
        $to = '<div class="comcode_code_wrap"><div class="comcode_code"><h4>Code</h4><div class="webstandards_checker_off"><code class="comcode_code_inner">&nbsp;x &nbsp;y<br />z</code></div></div></div>';
        $forced_html_to_comcode = false;
        $do_for_admin_too = true;
        $cases[] = array($from, $to, $forced_html_to_comcode, $do_for_admin_too);

        // 10
        $from = "[semihtml]<code>&nbsp;x &nbsp;y<br />z</code>[/semihtml]"; // HTML Code tags for WYSIWYG, without forcing to Comcode
        $to = '<code>&nbsp;x &nbsp;y<br />z</code>';
        $forced_html_to_comcode = false;
        $do_for_admin_too = true;
        $cases[] = array($from, $to, $forced_html_to_comcode, $do_for_admin_too);

        // 11
        $from = "[semihtml]<code>&nbsp;x &nbsp;y<br />z</code>[/semihtml]"; // HTML Code tags for WYSIWYG, with forcing to Comcode
        $to = '<div class="comcode_code_wrap"><div class="comcode_code"><h4>Code</h4><div class="webstandards_checker_off"><code class="comcode_code_inner">&nbsp;x &nbsp;y<br />z</code></div></div></div>';
        $forced_html_to_comcode = true;
        $do_for_admin_too = true;
        $cases[] = array($from, $to, $forced_html_to_comcode, $do_for_admin_too);

        // 12
        if (file_exists(get_file_base() . '/sources_custom/geshi/')) {
            $from = '[code="PHP"]echo "food & drink";[/code]'; // Vanilla non-WYSIWYG via GeSHI
            $to = '<div class="comcode_code_wrap"><div class="comcode_code"><h4>Code (<kbd>PHP</kbd>)</h4><div class="webstandards_checker_off"><div class="comcode_code_inner"><div class="php" style="font-family:monospace;"><span style="color: #b1b100;">echo</span><span style="color: #0000ff;">&quot;food &amp; drink&quot;</span><span style="color: #339933;">;</span></div></div></div></div></div>';
            $forced_html_to_comcode = false;
            $do_for_admin_too = true;
            $cases[] = array($from, $to, $forced_html_to_comcode, $do_for_admin_too);
        }

        $only = get_param_integer('only', null);
        foreach ($cases as $i => $_bits) {
            if (($only !== null) && ($only != $i)) {
                continue;
            }

            list($from, $to, $forced_html_to_comcode, $do_for_admin_too) = $_bits;

            if ($forced_html_to_comcode) {
                $_from = semihtml_to_comcode($from, true);
            } else {
                $_from = $from;
            }

            $ret = static_evaluate_tempcode(comcode_to_tempcode($_from, $GLOBALS['FORUM_DRIVER']->get_guest_id()));
            $got = $this->html_simplify($ret);
            $this->assertTrue($got == $to, 'Failed to properly evaluate Comcode CASE#' . strval($i) . '; FROM: ' . $from . '; EXPECTED: ' . $to . '; GOT: ' . $got . ' [AS GUEST]');

            if ($do_for_admin_too) {
                $ret = static_evaluate_tempcode(comcode_to_tempcode($_from, null, true));
                $got = $this->html_simplify($ret);
                $this->assertTrue($got == $to, 'Failed to properly evaluate Comcode CASE#' . strval($i) . '; FROM:' . $from . '; EXPECTED: ' . $to . '; GOT: ' . $got . ' [AS ADMIN]');
            }
        }
    }

    protected function html_simplify($code)
    {
        $code = trim($code);
        $code = preg_replace('#\s*(<[^<>]*>)\s*#', '$1', $code); // No white-space around tags
        $code = preg_replace('#\s+#', ' ', $code); // Only single spaces for any white-space

        return $code;
    }
}
