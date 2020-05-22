<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:md="http://commonmark.org/xml/1.0">


<!-- Import tinkr XSL -->
<!-- NOTE: the FIXME is replaced dynamically in R by the path to tinkr's stylesheet -->
<xsl:import href="FIXME"/>



<!-- This part handles the top-level elements starting an indent block (headers/lists) -->
<xsl:template match="md:*[@comment]" mode="indent-block">
    <xsl:value-of select="@comment" />
    <xsl:apply-imports select="md:*" mode="indent-block"/>
    <xsl:value-of select="@comment" />
</xsl:template>

<!-- This part prefixes all of the internal elements of blocks
     (any newlines as part of the paragraph or secondary list elements) -->
<xsl:template match="md:*[@comment]" mode="indent">
    <xsl:value-of select="@comment" />
</xsl:template>

<xsl:template match="md:*[@soln]">
    <xsl:if test="@soln='end'">
        <xsl:apply-imports select="md:*" />
    </xsl:if>
    <xsl:value-of select="@comment"/>
    <xsl:text>&#64;solution:</xsl:text>
    <xsl:value-of select="@soln"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="@soln='start'">
        <xsl:apply-imports select="md:*" />
    </xsl:if>
</xsl:template>
<!-- Code block -->


<xsl:output method="text" encoding="utf-8"/>

</xsl:stylesheet>
