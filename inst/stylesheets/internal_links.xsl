<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:md="http://commonmark.org/xml/1.0">

  <xsl:import href="FIXME"/>

  <xsl:output omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>


  <!-- Identity transform -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Liquid tag links -->
  <xsl:template match="md:text[(contains(text(), '[') and contains(text(), ']({{') and contains(text(), '}}'))]">
    <!-- NOTE: no need to copy here since we are manipulating the strings -->

    <!-- Process the text string to extract the tags -->
    <xsl:variable name="pre"  select="substring-before(., '[')"/>
    <xsl:variable name="txt"  select="substring-after(substring-before(., ']'), '[')"/>
    <xsl:variable name="dest" select="substring-before(substring-after(., ']('), ')')"/>
    <xsl:variable name="post" select="substring-after(substring-after(., ']('), ')')"/>

    <!-- add the text before the link -->
    <xsl:call-template name="new-text-node">
      <xsl:with-param name="text" select="$pre"/>
    </xsl:call-template>


    <!-- create the link element -->
    <xsl:call-template name="new-link-node">
      <xsl:with-param name="dest" select="$dest"/>
      <xsl:with-param name="text" select="$txt"/>
    </xsl:call-template>

    <!-- add the text after the link -->
    <xsl:call-template name="new-text-node">
      <xsl:with-param name="text" select="$post"/>
    </xsl:call-template>

  </xsl:template>


  <xsl:template name="new-text-node">
    <xsl:param name="text"/>

    <xsl:if test="not($text='')">
      <xsl:element name="text" namespace="http://commonmark.org/xml/1.0">
        <xsl:value-of select="$text"/>
      </xsl:element>
    </xsl:if>

  </xsl:template>

  <xsl:template name="new-link-node">
    <xsl:param name="text"/>
    <xsl:param name="dest"/>

    <xsl:element name="link" namespace="http://commonmark.org/xml/1.0">
      <xsl:attribute name="destination">
        <xsl:value-of select="$dest"/>
      </xsl:attribute>
      <xsl:call-template name="new-text-node">
        <xsl:with-param name="text" select="$text"/>
      </xsl:call-template>
    </xsl:element>

  </xsl:template>
</xsl:stylesheet>
