<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:md="http://commonmark.org/xml/1.0">


<!-- Import commonmark XSL -->

<xsl:import href="FIXME"/>
<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

<!-- params -->

<xsl:output method="text" encoding="utf-8"/>


<!-- kramdown tags -->

 <xsl:template match="md:*[@ktag]">
    <xsl:apply-imports select="md:*"/>
    <xsl:if test="ancestor::md:block_quote">&gt; </xsl:if>
    <xsl:if test="ancestor::md:block_quote/ancestor::md:block_quote">&gt; </xsl:if>
    <xsl:value-of select="@ktag"/>
    <xsl:text>&#10;</xsl:text>
</xsl:template>




</xsl:stylesheet>
