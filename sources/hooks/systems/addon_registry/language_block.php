<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    language_block
 */

/**
 * Hook class.
 */
class Hook_addon_registry_language_block
{
    /**
     * Get a list of file permissions to set.
     *
     * @param  boolean $runtime Whether to include wildcards represented runtime-created chmoddable files
     * @return array File permissions to set
     */
    public function get_chmod_array($runtime = false)
    {
        return array();
    }

    /**
     * Get the version of Composr this addon is for.
     *
     * @return float Version number
     */
    public function get_version()
    {
        return cms_version_number();
    }

    /**
     * Get the description of the addon.
     *
     * @return string Description of the addon
     */
    public function get_description()
    {
        return 'Blocks to allow visitors to choose their language.';
    }

    /**
     * Get a list of tutorials that apply to this addon.
     *
     * @return array List of tutorials
     */
    public function get_applicable_tutorials()
    {
        return array(
            'tut_intl',
            'tut_intl_users',
            'tut_intl_maintenance',
        );
    }

    /**
     * Get a mapping of dependency types.
     *
     * @return array File permissions to set
     */
    public function get_dependencies()
    {
        return array(
            'requires' => array(),
            'recommends' => array(),
            'conflicts_with' => array(),
        );
    }

    /**
     * Explicitly say which icon should be used.
     *
     * @return URLPATH Icon
     */
    public function get_default_icon()
    {
        return 'themes/default/images/icons/admin/component.svg';
    }

    /**
     * Get a list of files that belong to this addon.
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'sources/hooks/systems/addon_registry/language_block.php',
            'themes/default/templates/BLOCK_SIDE_LANGUAGE.tpl',
            'themes/default/templates/BLOCK_TOP_LANGUAGE.tpl',
            'sources/blocks/side_language.php',
            'sources/blocks/top_language.php',
            'sources/hooks/systems/config/block_top_language.php',
            'themes/default/images/flags_large/ad.svg',
            'themes/default/images/flags_large/ae.svg',
            'themes/default/images/flags_large/af.svg',
            'themes/default/images/flags_large/ag.svg',
            'themes/default/images/flags_large/ai.svg',
            'themes/default/images/flags_large/al.svg',
            'themes/default/images/flags_large/am.svg',
            'themes/default/images/flags_large/an.svg',
            'themes/default/images/flags_large/ao.svg',
            'themes/default/images/flags_large/aq.svg',
            'themes/default/images/flags_large/ar.svg',
            'themes/default/images/flags_large/as.svg',
            'themes/default/images/flags_large/at.svg',
            'themes/default/images/flags_large/au.svg',
            'themes/default/images/flags_large/aw.svg',
            'themes/default/images/flags_large/ax.svg',
            'themes/default/images/flags_large/az.svg',
            'themes/default/images/flags_large/ba.svg',
            'themes/default/images/flags_large/bb.svg',
            'themes/default/images/flags_large/bd.svg',
            'themes/default/images/flags_large/be.svg',
            'themes/default/images/flags_large/bf.svg',
            'themes/default/images/flags_large/bg.svg',
            'themes/default/images/flags_large/bh.svg',
            'themes/default/images/flags_large/bi.svg',
            'themes/default/images/flags_large/bj.svg',
            'themes/default/images/flags_large/bl.svg',
            'themes/default/images/flags_large/bm.svg',
            'themes/default/images/flags_large/bn.svg',
            'themes/default/images/flags_large/bo.svg',
            'themes/default/images/flags_large/bq.svg',
            'themes/default/images/flags_large/br.svg',
            'themes/default/images/flags_large/bs.svg',
            'themes/default/images/flags_large/bt.svg',
            'themes/default/images/flags_large/bv.svg',
            'themes/default/images/flags_large/bw.svg',
            'themes/default/images/flags_large/by.svg',
            'themes/default/images/flags_large/bz.svg',
            'themes/default/images/flags_large/ca.svg',
            'themes/default/images/flags_large/cc.svg',
            'themes/default/images/flags_large/cd.svg',
            'themes/default/images/flags_large/cf.svg',
            'themes/default/images/flags_large/cg.svg',
            'themes/default/images/flags_large/ch.svg',
            'themes/default/images/flags_large/ci.svg',
            'themes/default/images/flags_large/ck.svg',
            'themes/default/images/flags_large/cl.svg',
            'themes/default/images/flags_large/cm.svg',
            'themes/default/images/flags_large/cn.svg',
            'themes/default/images/flags_large/co.svg',
            'themes/default/images/flags_large/cr.svg',
            'themes/default/images/flags_large/cu.svg',
            'themes/default/images/flags_large/cv.svg',
            'themes/default/images/flags_large/cw.svg',
            'themes/default/images/flags_large/cx.svg',
            'themes/default/images/flags_large/cy.svg',
            'themes/default/images/flags_large/cz.svg',
            'themes/default/images/flags_large/de.svg',
            'themes/default/images/flags_large/dj.svg',
            'themes/default/images/flags_large/dk.svg',
            'themes/default/images/flags_large/dm.svg',
            'themes/default/images/flags_large/do.svg',
            'themes/default/images/flags_large/dz.svg',
            'themes/default/images/flags_large/ec.svg',
            'themes/default/images/flags_large/ee.svg',
            'themes/default/images/flags_large/eg.svg',
            'themes/default/images/flags_large/eh.svg',
            'themes/default/images/flags_large/er.svg',
            'themes/default/images/flags_large/es.svg',
            'themes/default/images/flags_large/et.svg',
            'themes/default/images/flags_large/eu.svg',
            'themes/default/images/flags_large/fi.svg',
            'themes/default/images/flags_large/fj.svg',
            'themes/default/images/flags_large/fk.svg',
            'themes/default/images/flags_large/fm.svg',
            'themes/default/images/flags_large/fo.svg',
            'themes/default/images/flags_large/fr.svg',
            'themes/default/images/flags_large/ga.svg',
            'themes/default/images/flags_large/gb.svg',
            'themes/default/images/flags_large/gd.svg',
            'themes/default/images/flags_large/ge.svg',
            'themes/default/images/flags_large/gf.svg',
            'themes/default/images/flags_large/gg.svg',
            'themes/default/images/flags_large/gh.svg',
            'themes/default/images/flags_large/gi.svg',
            'themes/default/images/flags_large/gl.svg',
            'themes/default/images/flags_large/gm.svg',
            'themes/default/images/flags_large/gn.svg',
            'themes/default/images/flags_large/gp.svg',
            'themes/default/images/flags_large/gq.svg',
            'themes/default/images/flags_large/gr.svg',
            'themes/default/images/flags_large/gs.svg',
            'themes/default/images/flags_large/gt.svg',
            'themes/default/images/flags_large/gu.svg',
            'themes/default/images/flags_large/gw.svg',
            'themes/default/images/flags_large/gy.svg',
            'themes/default/images/flags_large/hk.svg',
            'themes/default/images/flags_large/hm.svg',
            'themes/default/images/flags_large/hn.svg',
            'themes/default/images/flags_large/hr.svg',
            'themes/default/images/flags_large/ht.svg',
            'themes/default/images/flags_large/hu.svg',
            'themes/default/images/flags_large/id.svg',
            'themes/default/images/flags_large/ie.svg',
            'themes/default/images/flags_large/il.svg',
            'themes/default/images/flags_large/im.svg',
            'themes/default/images/flags_large/in.svg',
            'themes/default/images/flags_large/index.html',
            'themes/default/images/flags_large/io.svg',
            'themes/default/images/flags_large/iq.svg',
            'themes/default/images/flags_large/ir.svg',
            'themes/default/images/flags_large/is.svg',
            'themes/default/images/flags_large/it.svg',
            'themes/default/images/flags_large/je.svg',
            'themes/default/images/flags_large/jm.svg',
            'themes/default/images/flags_large/jo.svg',
            'themes/default/images/flags_large/jp.svg',
            'themes/default/images/flags_large/ke.svg',
            'themes/default/images/flags_large/kg.svg',
            'themes/default/images/flags_large/kh.svg',
            'themes/default/images/flags_large/ki.svg',
            'themes/default/images/flags_large/km.svg',
            'themes/default/images/flags_large/kn.svg',
            'themes/default/images/flags_large/kp.svg',
            'themes/default/images/flags_large/kr.svg',
            'themes/default/images/flags_large/kw.svg',
            'themes/default/images/flags_large/ky.svg',
            'themes/default/images/flags_large/kz.svg',
            'themes/default/images/flags_large/la.svg',
            'themes/default/images/flags_large/lb.svg',
            'themes/default/images/flags_large/lc.svg',
            'themes/default/images/flags_large/li.svg',
            'themes/default/images/flags_large/lk.svg',
            'themes/default/images/flags_large/lr.svg',
            'themes/default/images/flags_large/ls.svg',
            'themes/default/images/flags_large/lt.svg',
            'themes/default/images/flags_large/lu.svg',
            'themes/default/images/flags_large/lv.svg',
            'themes/default/images/flags_large/ly.svg',
            'themes/default/images/flags_large/ma.svg',
            'themes/default/images/flags_large/mc.svg',
            'themes/default/images/flags_large/md.svg',
            'themes/default/images/flags_large/me.svg',
            'themes/default/images/flags_large/mf.svg',
            'themes/default/images/flags_large/mg.svg',
            'themes/default/images/flags_large/mh.svg',
            'themes/default/images/flags_large/mk.svg',
            'themes/default/images/flags_large/ml.svg',
            'themes/default/images/flags_large/mm.svg',
            'themes/default/images/flags_large/mn.svg',
            'themes/default/images/flags_large/mo.svg',
            'themes/default/images/flags_large/mp.svg',
            'themes/default/images/flags_large/mq.svg',
            'themes/default/images/flags_large/mr.svg',
            'themes/default/images/flags_large/ms.svg',
            'themes/default/images/flags_large/mt.svg',
            'themes/default/images/flags_large/mu.svg',
            'themes/default/images/flags_large/mv.svg',
            'themes/default/images/flags_large/mw.svg',
            'themes/default/images/flags_large/mx.svg',
            'themes/default/images/flags_large/my.svg',
            'themes/default/images/flags_large/mz.svg',
            'themes/default/images/flags_large/na.svg',
            'themes/default/images/flags_large/nc.svg',
            'themes/default/images/flags_large/ne.svg',
            'themes/default/images/flags_large/nf.svg',
            'themes/default/images/flags_large/ng.svg',
            'themes/default/images/flags_large/ni.svg',
            'themes/default/images/flags_large/nl.svg',
            'themes/default/images/flags_large/no.svg',
            'themes/default/images/flags_large/np.svg',
            'themes/default/images/flags_large/nr.svg',
            'themes/default/images/flags_large/nu.svg',
            'themes/default/images/flags_large/nz.svg',
            'themes/default/images/flags_large/om.svg',
            'themes/default/images/flags_large/pa.svg',
            'themes/default/images/flags_large/pe.svg',
            'themes/default/images/flags_large/pf.svg',
            'themes/default/images/flags_large/pg.svg',
            'themes/default/images/flags_large/ph.svg',
            'themes/default/images/flags_large/pk.svg',
            'themes/default/images/flags_large/pl.svg',
            'themes/default/images/flags_large/pm.svg',
            'themes/default/images/flags_large/pn.svg',
            'themes/default/images/flags_large/pr.svg',
            'themes/default/images/flags_large/ps.svg',
            'themes/default/images/flags_large/pt.svg',
            'themes/default/images/flags_large/pw.svg',
            'themes/default/images/flags_large/py.svg',
            'themes/default/images/flags_large/qa.svg',
            'themes/default/images/flags_large/re.svg',
            'themes/default/images/flags_large/ro.svg',
            'themes/default/images/flags_large/rs.svg',
            'themes/default/images/flags_large/ru.svg',
            'themes/default/images/flags_large/rw.svg',
            'themes/default/images/flags_large/sa.svg',
            'themes/default/images/flags_large/sb.svg',
            'themes/default/images/flags_large/sc.svg',
            'themes/default/images/flags_large/sd.svg',
            'themes/default/images/flags_large/se.svg',
            'themes/default/images/flags_large/sg.svg',
            'themes/default/images/flags_large/sh.svg',
            'themes/default/images/flags_large/si.svg',
            'themes/default/images/flags_large/sj.svg',
            'themes/default/images/flags_large/sk.svg',
            'themes/default/images/flags_large/sl.svg',
            'themes/default/images/flags_large/sm.svg',
            'themes/default/images/flags_large/sn.svg',
            'themes/default/images/flags_large/so.svg',
            'themes/default/images/flags_large/sr.svg',
            'themes/default/images/flags_large/ss.svg',
            'themes/default/images/flags_large/st.svg',
            'themes/default/images/flags_large/sv.svg',
            'themes/default/images/flags_large/sx.svg',
            'themes/default/images/flags_large/sy.svg',
            'themes/default/images/flags_large/sz.svg',
            'themes/default/images/flags_large/tc.svg',
            'themes/default/images/flags_large/td.svg',
            'themes/default/images/flags_large/tf.svg',
            'themes/default/images/flags_large/tg.svg',
            'themes/default/images/flags_large/th.svg',
            'themes/default/images/flags_large/tj.svg',
            'themes/default/images/flags_large/tk.svg',
            'themes/default/images/flags_large/tl.svg',
            'themes/default/images/flags_large/tm.svg',
            'themes/default/images/flags_large/tn.svg',
            'themes/default/images/flags_large/to.svg',
            'themes/default/images/flags_large/tr.svg',
            'themes/default/images/flags_large/tt.svg',
            'themes/default/images/flags_large/tv.svg',
            'themes/default/images/flags_large/tw.svg',
            'themes/default/images/flags_large/tz.svg',
            'themes/default/images/flags_large/ua.svg',
            'themes/default/images/flags_large/ug.svg',
            'themes/default/images/flags_large/um.svg',
            'themes/default/images/flags_large/us.svg',
            'themes/default/images/flags_large/uy.svg',
            'themes/default/images/flags_large/uz.svg',
            'themes/default/images/flags_large/va.svg',
            'themes/default/images/flags_large/vc.svg',
            'themes/default/images/flags_large/ve.svg',
            'themes/default/images/flags_large/vg.svg',
            'themes/default/images/flags_large/vi.svg',
            'themes/default/images/flags_large/vn.svg',
            'themes/default/images/flags_large/vu.svg',
            'themes/default/images/flags_large/wf.svg',
            'themes/default/images/flags_large/ws.svg',
            'themes/default/images/flags_large/xk.svg',
            'themes/default/images/flags_large/ye.svg',
            'themes/default/images/flags_large/yt.svg',
            'themes/default/images/flags_large/za.svg',
            'themes/default/images/flags_large/zm.svg',
        );
    }

    /**
     * Get mapping between template names and the method of this class that can render a preview of them.
     *
     * @return array The mapping
     */
    public function tpl_previews()
    {
        return array(
            'templates/BLOCK_SIDE_LANGUAGE.tpl' => 'block_side_language',
            'templates/BLOCK_TOP_LANGUAGE.tpl' => 'block_top_language',
        );
    }

    /**
     * Get a preview(s) of a (group of) template(s), as a full standalone piece of HTML in Tempcode format.
     * Uses sources/lorem.php functions to place appropriate stock-text. Should not hard-code things, as the code is intended to be declarative.
     * Assumptions: You can assume all Lang/CSS/JavaScript files in this addon have been pre-required.
     *
     * @return array Array of previews, each is Tempcode. Normally we have just one preview, but occasionally it is good to test templates are flexible (e.g. if they use IF_EMPTY, we can test with and without blank data).
     */
    public function tpl_preview__block_side_language()
    {
        return array(
            lorem_globalise(do_lorem_template('BLOCK_SIDE_LANGUAGE', array(
                'BLOCK_ID' => lorem_word(),
                'LANGS' => placeholder_options(),
            )), null, '', true)
        );
    }

    /**
     * Get a preview(s) of a (group of) template(s), as a full standalone piece of HTML in Tempcode format.
     * Uses sources/lorem.php functions to place appropriate stock-text. Should not hard-code things, as the code is intended to be declaritive.
     * Assumptions: You can assume all Lang/CSS/JavaScript files in this addon have been pre-required.
     *
     * @return array Array of previews, each is Tempcode. Normally we have just one preview, but occasionally it is good to test templates are flexible (e.g. if they use IF_EMPTY, we can test with and without blank data).
     */
    public function tpl_preview__block_top_language()
    {
        return array(
            lorem_globalise(do_lorem_template('BLOCK_TOP_LANGUAGE', array(
                'LANGS' => array(
                    'FR' => array('FULL_NAME' => 'French', 'COUNTRY_FLAG' => 'fr'),
                    'DE' => array('FULL_NAME' => 'German', 'COUNTRY_FLAG' => 'de'),
                ),
                'CURRENT_LANG_FULL_NAME' => 'English',
                'CURRENT_LANG_COUNTRY_FLAG' => 'en',
                'CURRENT_LANG' => 'EN',
            )), null, '', true)
        );
    }
}
