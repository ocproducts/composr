<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="html" />
    <xsl:include href="layout.xsl" />

    <xsl:template match="/project" mode="contents">

        <div class="hero-unit">
            <h1>
                <xsl:value-of select="$title" disable-output-escaping="yes"/>
                <xsl:if test="$title = ''">phpDocumentor</xsl:if>
            </h1>
            <h2>Documentation</h2>
        </div>

        <div class="row">
            <div class="span7">
                 <xsl:if test="count(/project/package[@name != '' and @name != 'default']) > 0">
                <div class="well">
                    <ul class="nav nav-list">
                        <li class="nav-header">Packages</li>
                        <xsl:apply-templates select="/project/package" mode="menu">
                            <xsl:sort select="@name"/>
                        </xsl:apply-templates>
                    </ul>
                </div>
                </xsl:if>

            </div>
            <div class="span5">
					<b>Welcome to the Composr API documentation.</b><br />
					<br />
					For other documentation (including our developers guide, the Code Book), see the <a target="_blank" title="Documentation section of our website (this link will open in a new window)" href="http://compo.sr/docs/">documentation section of our website</a>.
					<br />
					<br />
					The packages in this documentation (shown above) correspond to the addons that Composr is split up into. All packages beginning 'core_' can be assumed to be installed on any Composr version.
					<br />
					<br />
					Be aware that you still often need to use the 'require_code' command to gain access to source code files (e.g. access <tt>sources/files.php</tt> using<br /><code>require_code('files');</code>.<br /><br />Some source files are always loaded up, see the 'init' function of <tt>sources/global2.php</tt> to discover which.<br /><br />
					Hooks are called up by whatever code using the hooks.<br /><br />
					Modules are called up on-demand by users as pages (but aren't included in this API documentation).<br /><br />
					Blocks are called up by placement on pages using Comcode, or in templates using Tempcode.
					<br />
					<br />
					<br />
					To find the forum driver API you can look at <em>core_forum_drivers</em>, but also look at the base <strong>Forum_driver_base</strong> class under <em>core</em>.
					<br />
					To find the database API look at the <strong>database_driver</strong> class under <em>core</em>.
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>