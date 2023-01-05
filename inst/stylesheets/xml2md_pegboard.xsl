<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:md="http://commonmark.org/xml/1.0">


<!-- 
  
  Convert Markdown Document to a commented/annotated code handout
  ===============================================================

  This stylesheet assumes that you have preprocessed all direct children of the
  document with `@comment` attributes, specifying the comment character:

      xml2::xml_children(doc) |> xml2::xml_set_attr("comment", "#")

  When we do this, the stylesheet knows to insert a comment character before
  processing the content. 

  This stylesheet was previously used to collapse callout blocks into code
  blocks with roxygen2 comments. I have repurposed it to process handouts

--> 

<!-- Import tinkr XSL -->
<!-- NOTE: the FIXME is replaced dynamically in R by the path to tinkr's stylesheet -->
<xsl:import href="FIXME"/>
<xsl:variable name="comment" select="md:document/@comment" />

<!-- This part handles the top-level elements starting an indent block (headers/lists) -->
<xsl:template match="/md:document[@comment]/md:*" mode="indent-block">
    <xsl:value-of select="$comment" />
    <xsl:text> </xsl:text>
    <xsl:apply-imports select="md:*" mode="indent-block"/>
    <!-- This prevents an extra comment from appearing at the top of the doc -->
    <xsl:if test="preceding-sibling::md:*">
        <xsl:value-of select="$comment" />
        <xsl:text> </xsl:text>
    </xsl:if>
</xsl:template>

<!--
This part prefixes all of the internal elements of blocks
(any newlines as part of the paragraph or secondary list elements)
-->
<xsl:template match="/md:document[@comment]/md:*" mode="indent">
    <xsl:value-of select="$comment" />
    <xsl:text> </xsl:text>
</xsl:template>

<!--
  This is a modified copy of the code block directive from the xml2md stylesheet
  in {tinkr}. It adds a single comment character before the final code fence.
-->
<xsl:template match="/md:document[@comment]//md:code_block">
    <xsl:apply-templates select="." mode="indent-block"/>

    <xsl:variable name="t" select="string(.)"/>
    <xsl:variable name="delim">
        <xsl:call-template name="code-delim">
            <xsl:with-param name="text" select="$t"/>
            <xsl:with-param name="delim" select="'```'"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:value-of select="$delim"/>
    <xsl:value-of select="@info"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:call-template name="indent-lines">
        <xsl:with-param name="code" select="$t"/>
    </xsl:call-template>
    <xsl:apply-templates select="ancestor::md:*" mode="indent"/>
    <!-- ZNK: add single comment character before final fence -->
    <xsl:value-of select="$comment" />
    <xsl:text> </xsl:text>
    <xsl:value-of select="$delim"/>
    <xsl:text>&#10;</xsl:text>
</xsl:template>

<!--
  DEPRECATED

  When there is a "xygen" tag, this adds the tag before the text like so:
  <comment>
  <comment> @<xygen>
  ...stuff here ...
-->
<xsl:template match="md:*[@xygen]">
    <xsl:value-of select="@comment"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:value-of select="@comment"/>
    <xsl:text> &#64;</xsl:text>
    <xsl:value-of select="@xygen"/>
    <xsl:choose>
    <!-- If the current node is a heading node, then it's part of the tag -->
        <xsl:when test="boolean(self::md:heading[@level='2'])">
            <xsl:text> </xsl:text>
            <xsl:value-of select='self::md:heading[1]'/>
            <xsl:text>&#10;</xsl:text>
        </xsl:when>
    <!-- In all other cases, the node is processed normally -->
        <xsl:otherwise>
            <xsl:text>&#10;</xsl:text>
            <xsl:apply-imports select="md:*" mode="indent"/>
            <xsl:value-of select="@comment"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:output method="text" encoding="utf-8"/>

</xsl:stylesheet>
