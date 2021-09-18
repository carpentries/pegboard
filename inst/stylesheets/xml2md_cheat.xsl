<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:md="http://commonmark.org/xml/1.0">


<!-- Import tinkr XSL -->
<!-- NOTE: the FIXME is replaced dynamically in R by the path to tinkr's stylesheet -->
<xsl:import href="FIXME"/>

<!-- 
  2021-09-17: This is my attempt at creating a cheat sheet, purl style without
  purl since it would require us to write and read the file again. I KNOW it is
  possible to do this, but at the moment, there are aspects that are eluding me.

  I took this from my dovetail xsl template and the gfm template to try and 
  comment everything that wasn't a code block, but of course I'm forgetting how
  the document works and there are some lines that are double commented and some
  that are uncommented because of the paragraph rules for commonmark. 

  This will be useful at some point to avoid the read/write cycles, but right
  now IDK.
-->

<xsl:template match="md:code_block">
  <xsl:apply-templates select="." mode="indent-block"/>
  <xsl:variable name="t" select="string(.)"/>
  <xsl:call-template name="indent-lines">
      <xsl:with-param name="code" select="$t"/>
  </xsl:call-template>
  <xsl:apply-templates select="ancestor::md:*" mode="indent"/>
</xsl:template>

<!-- This part handles the top-level elements starting an indent block (headers/lists) -->
<xsl:template match="md:*[not(starts-with(@info, '{'))]" mode="indent-block">
    <xsl:text># </xsl:text>
    <xsl:apply-imports select="md:*" mode="indent-block"/>
    <xsl:text># </xsl:text>
</xsl:template>

<xsl:template match="md:*[not(starts-with(@info, '{'))]">
    <xsl:text># </xsl:text>
    <xsl:apply-imports select="md:*" />
</xsl:template>

<xsl:output method="text" encoding="utf-8"/>

</xsl:stylesheet>
