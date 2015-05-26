<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    geshi
 */

/**
 * Hook class.
 */
class Hook_addon_registry_geshi
{
    /**
     * Get a list of file permissions to set
     *
     * @return array File permissions to set
     */
    public function get_chmod_array()
    {
        return array();
    }

    /**
     * Get the version of Composr this addon is for
     *
     * @return float Version number
     */
    public function get_version()
    {
        return cms_version_number();
    }

    /**
     * Get the addon category
     *
     * @return string The category
     */
    public function get_category()
    {
        return 'Information Display';
    }

    /**
     * Get the addon author
     *
     * @return string The author
     */
    public function get_author()
    {
        return 'Chris Graham';
    }

    /**
     * Find other authors
     *
     * @return array A list of co-authors that should be attributed
     */
    public function get_copyright_attribution()
    {
        return array(
            'The Authors of GeSHi',
        );
    }

    /**
     * Get the addon licence (one-line summary only)
     *
     * @return string The licence
     */
    public function get_licence()
    {
        return 'GPL';
    }

    /**
     * Get the description of the addon
     *
     * @return string Description of the addon
     */
    public function get_description()
    {
        return 'Apply syntax highlighting to a block of coding which is pasted inside the Comcode [tt]code[/tt] tag as follows:

[code=\"Comcode\"][codebox=\"language\"]the code goes here[/codebox][/code]';
    }

    /**
     * Get a list of tutorials that apply to this addon
     *
     * @return array List of tutorials
     */
    public function get_applicable_tutorials()
    {
        return array();
    }

    /**
     * Get a mapping of dependency types
     *
     * @return array File permissions to set
     */
    public function get_dependencies()
    {
        return array(
            'requires' => array(),
            'recommends' => array(),
            'conflicts_with' => array()
        );
    }

    /**
     * Explicitly say which icon should be used
     *
     * @return URLPATH Icon
     */
    public function get_default_icon()
    {
        return 'themes/default/images/icons/48x48/menu/_generic_admin/component.png';
    }

    /**
     * Get a list of files that belong to this addon
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'sources_custom/hooks/systems/addon_registry/geshi.php',
            'sources_custom/geshi/.htaccess',
            'sources_custom/geshi/index.html',
            'sources_custom/geshi/4cs.php',
            'sources_custom/geshi/abap.php',
            'sources_custom/geshi/actionscript.php',
            'sources_custom/geshi/actionscript3.php',
            'sources_custom/geshi/ada.php',
            'sources_custom/geshi/apache.php',
            'sources_custom/geshi/applescript.php',
            'sources_custom/geshi/apt_sources.php',
            'sources_custom/geshi/asm.php',
            'sources_custom/geshi/asp.php',
            'sources_custom/geshi/autohotkey.php',
            'sources_custom/geshi/autoit.php',
            'sources_custom/geshi/avisynth.php',
            'sources_custom/geshi/awk.php',
            'sources_custom/geshi/bash.php',
            'sources_custom/geshi/basic4gl.php',
            'sources_custom/geshi/bf.php',
            'sources_custom/geshi/bibtex.php',
            'sources_custom/geshi/blitzbasic.php',
            'sources_custom/geshi/bnf.php',
            'sources_custom/geshi/boo.php',
            'sources_custom/geshi/c.php',
            'sources_custom/geshi/c_mac.php',
            'sources_custom/geshi/caddcl.php',
            'sources_custom/geshi/cadlisp.php',
            'sources_custom/geshi/cfdg.php',
            'sources_custom/geshi/cfm.php',
            'sources_custom/geshi/cil.php',
            'sources_custom/geshi/clojure.php',
            'sources_custom/geshi/cmake.php',
            'sources_custom/geshi/cobol.php',
            'sources_custom/geshi/cpp-qt.php',
            'sources_custom/geshi/cpp.php',
            'sources_custom/geshi/csharp.php',
            'sources_custom/geshi/css.php',
            'sources_custom/geshi/cuesheet.php',
            'sources_custom/geshi/d.php',
            'sources_custom/geshi/dcs.php',
            'sources_custom/geshi/delphi.php',
            'sources_custom/geshi/diff.php',
            'sources_custom/geshi/div.php',
            'sources_custom/geshi/dos.php',
            'sources_custom/geshi/dot.php',
            'sources_custom/geshi/eiffel.php',
            'sources_custom/geshi/email.php',
            'sources_custom/geshi/erlang.php',
            'sources_custom/geshi/fo.php',
            'sources_custom/geshi/fortran.php',
            'sources_custom/geshi/freebasic.php',
            'sources_custom/geshi/fsharp.php',
            'sources_custom/geshi/gambas.php',
            'sources_custom/geshi/gdb.php',
            'sources_custom/geshi/genero.php',
            'sources_custom/geshi/gettext.php',
            'sources_custom/geshi/glsl.php',
            'sources_custom/geshi/gml.php',
            'sources_custom/geshi/gnuplot.php',
            'sources_custom/geshi/groovy.php',
            'sources_custom/geshi/haskell.php',
            'sources_custom/geshi/hq9plus.php',
            'sources_custom/geshi/html4strict.php',
            'sources_custom/geshi/idl.php',
            'sources_custom/geshi/ini.php',
            'sources_custom/geshi/inno.php',
            'sources_custom/geshi/intercal.php',
            'sources_custom/geshi/io.php',
            'sources_custom/geshi/java.php',
            'sources_custom/geshi/java5.php',
            'sources_custom/geshi/javascript.php',
            'sources_custom/geshi/jquery.php',
            'sources_custom/geshi/kixtart.php',
            'sources_custom/geshi/klonec.php',
            'sources_custom/geshi/klonecpp.php',
            'sources_custom/geshi/latex.php',
            'sources_custom/geshi/lisp.php',
            'sources_custom/geshi/locobasic.php',
            'sources_custom/geshi/logtalk.php',
            'sources_custom/geshi/lolcode.php',
            'sources_custom/geshi/lotusformulas.php',
            'sources_custom/geshi/lotusscript.php',
            'sources_custom/geshi/lscript.php',
            'sources_custom/geshi/lsl2.php',
            'sources_custom/geshi/lua.php',
            'sources_custom/geshi/m68k.php',
            'sources_custom/geshi/make.php',
            'sources_custom/geshi/mapbasic.php',
            'sources_custom/geshi/matlab.php',
            'sources_custom/geshi/mirc.php',
            'sources_custom/geshi/mmix.php',
            'sources_custom/geshi/modula3.php',
            'sources_custom/geshi/mpasm.php',
            'sources_custom/geshi/mxml.php',
            'sources_custom/geshi/mysql.php',
            'sources_custom/geshi/newlisp.php',
            'sources_custom/geshi/nsis.php',
            'sources_custom/geshi/oberon2.php',
            'sources_custom/geshi/objc.php',
            'sources_custom/geshi/ocaml-brief.php',
            'sources_custom/geshi/ocaml.php',
            'sources_custom/geshi/oobas.php',
            'sources_custom/geshi/oracle11.php',
            'sources_custom/geshi/oracle8.php',
            'sources_custom/geshi/pascal.php',
            'sources_custom/geshi/per.php',
            'sources_custom/geshi/perl.php',
            'sources_custom/geshi/perl6.php',
            'sources_custom/geshi/php-brief.php',
            'sources_custom/geshi/php.php',
            'sources_custom/geshi/pic16.php',
            'sources_custom/geshi/pike.php',
            'sources_custom/geshi/pixelbender.php',
            'sources_custom/geshi/plsql.php',
            'sources_custom/geshi/povray.php',
            'sources_custom/geshi/powerbuilder.php',
            'sources_custom/geshi/powershell.php',
            'sources_custom/geshi/progress.php',
            'sources_custom/geshi/prolog.php',
            'sources_custom/geshi/properties.php',
            'sources_custom/geshi/providex.php',
            'sources_custom/geshi/purebasic.php',
            'sources_custom/geshi/python.php',
            'sources_custom/geshi/qbasic.php',
            'sources_custom/geshi/rails.php',
            'sources_custom/geshi/rebol.php',
            'sources_custom/geshi/reg.php',
            'sources_custom/geshi/robots.php',
            'sources_custom/geshi/rsplus.php',
            'sources_custom/geshi/ruby.php',
            'sources_custom/geshi/sas.php',
            'sources_custom/geshi/scala.php',
            'sources_custom/geshi/scheme.php',
            'sources_custom/geshi/scilab.php',
            'sources_custom/geshi/sdlbasic.php',
            'sources_custom/geshi/smalltalk.php',
            'sources_custom/geshi/smarty.php',
            'sources_custom/geshi/sql.php',
            'sources_custom/geshi/systemverilog.php',
            'sources_custom/geshi/tcl.php',
            'sources_custom/geshi/teraterm.php',
            'sources_custom/geshi/text.php',
            'sources_custom/geshi/thinbasic.php',
            'sources_custom/geshi/tsql.php',
            'sources_custom/geshi/typoscript.php',
            'sources_custom/geshi/vb.php',
            'sources_custom/geshi/vbnet.php',
            'sources_custom/geshi/verilog.php',
            'sources_custom/geshi/vhdl.php',
            'sources_custom/geshi/vim.php',
            'sources_custom/geshi/visualfoxpro.php',
            'sources_custom/geshi/visualprolog.php',
            'sources_custom/geshi/whitespace.php',
            'sources_custom/geshi/whois.php',
            'sources_custom/geshi/winbatch.php',
            'sources_custom/geshi/xml.php',
            'sources_custom/geshi/xorg_conf.php',
            'sources_custom/geshi/xpp.php',
            'sources_custom/geshi/z80.php',
            'sources_custom/geshi.php',
        );
    }
}
