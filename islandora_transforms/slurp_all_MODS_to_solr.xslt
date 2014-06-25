<?xml version="1.0" encoding="UTF-8"?>
<!-- Basic MODS -->
<xsl:stylesheet version="1.0"
  xmlns:java="http://xml.apache.org/xalan/java"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:mods="http://www.loc.gov/mods/v3"
     exclude-result-prefixes="mods java">
  <!-- <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/config/index/FgsIndex/islandora_transforms/library/xslt-date-template.xslt"/>-->
  <xsl:include href="/var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/library/xslt-date-template.xslt"/>
  <!-- HashSet to track single-valued fields. -->
  <xsl:variable name="single_valued_hashset" select="java:java.util.HashSet.new()"/>

  <xsl:template match="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]" name="index_MODS">
    <xsl:param name="content"/>
    <xsl:param name="prefix"></xsl:param>
    <xsl:param name="suffix">ms</xsl:param>

    <xsl:apply-templates mode="slurping_MODS" select="$content//mods:mods[1]">
      <xsl:with-param name="prefix" select="$prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
      <xsl:with-param name="pid" select="../../@PID"/>
      <xsl:with-param name="datastream" select="../@ID"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Handle dates. -->
  <xsl:template match="mods:*[(@type='date') or (contains(translate(local-name(), 'D', 'd'), 'date'))][normalize-space(text())]" mode="slurping_MODS">
    <xsl:param name="prefix"/>
    <xsl:param name="suffix"/>
    <xsl:param name="pid">not provided</xsl:param>
    <xsl:param name="datastream">not provided</xsl:param>

    <xsl:variable name="rawTextValue" select="normalize-space(text())"/>

    <xsl:variable name="textValue">
      <xsl:call-template name="get_ISO8601_date">
        <xsl:with-param name="date" select="$rawTextValue"/>
        <xsl:with-param name="pid" select="$pid"/>
        <xsl:with-param name="datastream" select="$datastream"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- Use attributes in field name. -->
    <xsl:variable name="this_prefix">
      <xsl:value-of select="$prefix"/>
      <xsl:for-each select="@*">
        <xsl:sort select="concat(local-name(), namespace-uri(self::node()))"/>
        <xsl:value-of select="local-name()"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>_</xsl:text>
      </xsl:for-each>
    </xsl:variable>

    <!-- Prevent multiple generating multiple instances of single-valued fields
         by tracking things in a HashSet -->
    <xsl:variable name="field_name" select="normalize-space(concat($this_prefix, local-name()))"/>
    <!-- The method java.util.HashSet.add will return false when the value is
         already in the set. -->
    <xsl:if test="java:add($single_valued_hashset, $field_name)">
      <xsl:if test="not(normalize-space($textValue)='')">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($field_name, '_dt')"/>
          </xsl:attribute>
          <xsl:value-of select="$textValue"/>
        </field>
      </xsl:if>
      <xsl:if test="not(normalize-space($rawTextValue)='')">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($field_name, '_s')"/>
          </xsl:attribute>
          <xsl:value-of select="$rawTextValue"/>
        </field>
      </xsl:if>
    </xsl:if>

    <xsl:if test="not(normalize-space($textValue)='')">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($prefix, local-name(), '_mdt')"/>
        </xsl:attribute>
        <xsl:value-of select="$textValue"/>
      </field>
    </xsl:if>
    <xsl:if test="not(normalize-space($rawTextValue)='')">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($prefix, local-name(), '_ms')"/>
        </xsl:attribute>
        <xsl:value-of select="$rawTextValue"/>
      </field>
    </xsl:if>
  </xsl:template>

  <!-- Avoid using text alone. -->
  <xsl:template match="text()" mode="slurping_MODS"/>

  <!-- Build up the list prefix with the element context. -->
  <xsl:template match="*" mode="slurping_MODS">
    <xsl:param name="prefix"/>
    <xsl:param name="suffix"/>
    <xsl:param name="pid">not provided</xsl:param>
    <xsl:param name="datastream">not provided</xsl:param>
    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz_'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ '" />

    <xsl:variable name="this_prefix">
      <xsl:value-of select="concat($prefix, local-name(), '_')"/>
      <xsl:if test="@type">
        <xsl:value-of select="concat(@type, '_')"/>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="textValue">
      <xsl:value-of select="normalize-space(text())"/>
    </xsl:variable>

    <xsl:if test="$textValue">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($this_prefix, $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="$textValue"/>
      </field>
      <!-- Fields are duplicated for authority because searches across authorities are common. -->
      <xsl:if test="@authority">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($this_prefix, 'authority_', translate(@authority, $uppercase, $lowercase), '_', $suffix)"/>
          </xsl:attribute>
          <xsl:value-of select="$textValue"/>
        </field>
      </xsl:if>
    </xsl:if>

    <xsl:apply-templates mode="slurping_MODS">
      <xsl:with-param name="prefix" select="$this_prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
      <xsl:with-param name="pid" select="$pid"/>
      <xsl:with-param name="datastream" select="$datastream"/>
    </xsl:apply-templates>
    <xsl:if test="@authority">
      <xsl:apply-templates mode="slurping_MODS">
        <xsl:with-param name="prefix" select="concat($this_prefix, 'authority_', translate(@authority, $uppercase, $lowercase), '_')"/>
        <xsl:with-param name="suffix" select="$suffix"/>
        <xsl:with-param name="pid" select="$pid"/>
        <xsl:with-param name="datastream" select="$datastream"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
