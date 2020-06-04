<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:md="http://commonmark.org/xml/1.0">


  <xsl:output omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>
  <!--
  Notes:

  I think I've finally wrapped my head around this. Templates in xslt are like
  functions in R. The thing about these is that they can be named or have a
  matching pattern for nodes, or both. It's a lot uglier than dealing with R,
  but it seems to do the job :)

  <apply-templates select=".">

  is much like purrr::walk(., ~~context~~), you
  run through a nodeset and all its children, applying templates that match
  those nodes. If a template does not have a match pattern, then it doesn't get
  applied.

  <call-template name="SOMETHING">
    <with-param name="p1" select="'a'"/>
    <with-param name="p2" select="$x"/>
    <with-param name="p3">
      <xsl:value-of "@y">
    </with-param>
  </call-template>

  is like SOMETHING(p1 = 'a', p2 = x, p3 = attr(., "y"))
  This gets called on an individual node

  -->


  <!-- Identity transform -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Liquid tag links -->
  <xsl:template name="liquid-tags" match="md:text[(contains(text(), '[') and contains(text(), ']({{') and contains(text(), '}}'))]">
    <xsl:param name="text" select="string(.)"/>

    <!-- NOTE: no need to copy here since we are manipulating the strings -->
    <!-- Process the text string to extract the tags -->
    <xsl:variable name="pre"  select="substring-before($text, '[')"/>
    <xsl:variable name="txt"  select="substring-after(substring-before($text, ']'), '[')"/>
    <xsl:variable name="dest" select="substring-before(substring-after($text, ']('), ')')"/>
    <xsl:variable name="post" select="substring-after(substring-after($text, ']('), ')')"/>

    <xsl:choose>
      <!-- If any of the elements were parsed -->
      <xsl:when test="$pre or $dest or $txt or $post">


        <!-- add the text before the link -->
        <xsl:if test="$pre!='!'">
          <xsl:call-template name="new-text-node">
            <xsl:with-param name="text" select="$pre"/>
          </xsl:call-template>
        </xsl:if>

        <!-- create the link element -->
        <xsl:call-template name="new-link-node">
          <xsl:with-param name="type">
            <xsl:choose>
              <xsl:when test="$pre='!'">image</xsl:when>
              <xsl:otherwise>link</xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="dest" select="$dest"/>
          <xsl:with-param name="text" select="$txt"/>
        </xsl:call-template>

        <!-- process any text after the link -->
        <xsl:call-template name="liquid-tags">
          <xsl:with-param name="text" select="$post"/>
        </xsl:call-template>

      </xsl:when>

      <!-- When none of the elements were parsed, it's a text node -->
      <xsl:otherwise>

        <xsl:call-template name="new-text-node">
          <xsl:with-param name="text" select="$text"/>
        </xsl:call-template>

      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- HELPER TEMPLATES -->

  <!-- Create a new text node, or nothing if empty -->
  <xsl:template name="new-text-node">
    <xsl:param name="text"/>

    <xsl:if test="$text">
      <xsl:element name="text" namespace="http://commonmark.org/xml/1.0">
        <xsl:value-of select="$text"/>
      </xsl:element>
    </xsl:if>

  </xsl:template>

  <!-- Create a new link node, or nothing if empty -->
  <xsl:template name="new-link-node">
    <xsl:param name="type" select="'link'"/>
    <xsl:param name="text"/>
    <xsl:param name="dest"/>

    <xsl:if test="$dest">
      <xsl:element name="{$type}" namespace="http://commonmark.org/xml/1.0">
        <xsl:attribute name="destination">
          <xsl:value-of select="$dest"/>
        </xsl:attribute>
        <xsl:call-template name="new-text-node">
          <xsl:with-param name="text" select="$text"/>
        </xsl:call-template>
      </xsl:element>
    </xsl:if>

  </xsl:template>
</xsl:stylesheet>
