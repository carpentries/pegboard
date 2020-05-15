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
 <xsl:template match="md:*/md:block_quote[not(ancestor::md:block_quote)][@ktag]">
    <xsl:text>&#10;&gt; </xsl:text>
    <xsl:apply-templates select="./md:block_quote" mode="indent"/>
    <xsl:apply-templates select="md:*"/>
    <xsl:value-of select="@ktag"/>
    <xsl:text>&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template match="md:*/md:block_quote[md:block_quote[1]/@ktag]">
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="./md:block_quote" mode="indent"/>
    <xsl:apply-templates select="md:*"/>
    <xsl:text>&gt; </xsl:text>
    <xsl:value-of select="md:block_quote/@ktag"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:value-of select="@ktag"/>
    <xsl:text>&#10;&#10;</xsl:text>
</xsl:template>



</xsl:stylesheet>
