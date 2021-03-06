<?xml version="1.0" encoding="UTF-8"?>
<!-- DWC -->
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:foxml="info:fedora/fedora-system:def/foxml#"
        xmlns:dcterms="http://purl.org/dc/terms/" 
        xmlns:dwr="http://rs.tdwg.org/dwc/dwcrecord/"
        xmlns:dwc="http://rs.tdwg.org/dwc/terms/">
        
        <xsl:template match="foxml:datastream[@ID='DWC']/foxml:datastreamVersion[last()]" name="index_DWC">
                <xsl:param name="content"/>
                <xsl:param name="prefix">dwc.</xsl:param>

                <xsl:for-each select="$content//dwc:Occurrence/*">
                                <xsl:choose>
                                        <xsl:when test="contains(text(), 'purchasedFrom')">
                                                <field>
                                                        <xsl:attribute name="name">
                                                                <xsl:value-of select="concat($prefix, 'purchasedFrom')"/>  
                                                        </xsl:attribute>
                                                        <xsl:value-of select="substring-after(text(), 'purchasedFrom ')"/>
                                                </field>
                                        </xsl:when>
                                        <xsl:when test="not(contains(name(), 'basisOfRecord'))">
                                                <field>
                                                        <xsl:attribute name="name">
                                                                <xsl:value-of select="concat($prefix, substring-after(name(),':'))"/>  
                                                        </xsl:attribute>
                                                        <xsl:value-of select="."/>
                                                </field>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:text></xsl:text>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:for-each>
                        
                <xsl:for-each select="$content//dwc:Taxon/*">
                                <xsl:choose>
                                        <xsl:when test="not(contains(name(), 'taxonRemarks'))">
                                                <field>
                                                        <xsl:attribute name="name">
                                                                <xsl:value-of select="concat($prefix, 'Taxon_', parent::node()/*[contains(name(), 'taxonRemarks')]/text())"/>  
                                                        </xsl:attribute>
                                                        <xsl:value-of select="."/>
                                                </field>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:text></xsl:text>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:for-each>
                        
                <xsl:for-each select="$content//dcterms:Location/*">
                                <xsl:choose>
                                        <xsl:when test="not(contains(name(), 'locality')) and not(contains(name(), 'locationRemarks'))">
                                                <field>
                                                        <xsl:attribute name="name">
                                                                <xsl:value-of select="concat($prefix, translate(parent::node()/*[contains(name(), 'locality')]/text(), ' ', ''), '_location')"/>  
                                                        </xsl:attribute>
                                                        <xsl:value-of select="normalize-space(substring-before(text(),'('))"/>
                                                </field>
                                                <field>
                                                        <xsl:attribute name="name">
                                                                <xsl:value-of select="concat($prefix, translate(parent::node()/*[contains(name(), 'locality')]/text(), ' ', ''), '_location_PID')"/>  
                                                        </xsl:attribute>
                                                        <xsl:value-of select="normalize-space(substring-before(substring-after(text(),'('), ')'))"/>
                                                </field>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:text></xsl:text>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:for-each>
                        
                <xsl:for-each select="$content//dwc:Event/*">
                                <xsl:choose>
                                        <xsl:when test="not(contains(name(), 'eventRemarks'))">
                                                <field>
                                                        <xsl:attribute name="name">
                                                                <xsl:value-of select="concat($prefix, parent::node()/*[contains(name(), 'eventRemarks')]/text(), '_', substring-after(name(),':'))"/>  
                                                        </xsl:attribute>
                                                        <xsl:value-of select="."/>
                                                </field>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:text></xsl:text>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:for-each>
                        
                <xsl:for-each select="$content//dwc:MeasurementOrFact/*">
                                <xsl:choose>
                                        <xsl:when test="not(contains(name(), 'measurementValue')) and not(contains(name(), 'measurementUnit'))">
                                                <field>
                                                        <xsl:attribute name="name">
                                                                <xsl:value-of select="concat($prefix, substring-after(name(),':'))"/>  
                                                        </xsl:attribute>
                                                        <xsl:value-of select="."/>
                                                </field>
                                        </xsl:when>
                                        <xsl:when test="contains(name(), 'measurementUnit')">
                                                <field>
                                                        <xsl:attribute name="name">
                                                                <xsl:value-of select="concat($prefix, 'Relationship_', parent::node()/*[contains(name(), 'measurementValue')]/text(), '_PID')"/> 
                                                        </xsl:attribute>
                                                        <xsl:value-of select="substring-before(substring-after(text(),'('), ')')"/>
                                                </field>
                                                <field>
                                                        <xsl:attribute name="name">
                                                                <xsl:value-of select="concat($prefix, 'Relationship_', parent::node()/*[contains(name(), 'measurementValue')]/text())"/> 
                                                        </xsl:attribute>
                                                        <xsl:value-of select="normalize-space(substring-before(text(),'('))"/>
                                                </field>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:text></xsl:text>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:for-each>
                        
                        
                <xsl:for-each select="$content//dwc:ResourceRelationship/*">
                                <xsl:choose>
                                        <xsl:when test="not(contains(name(), 'relationshipOfResource'))">
                                                <xsl:if test="contains(name(), 'relatedResourceID')">
                                                        <field>
                                                                <xsl:attribute name="name">
                                                                        <xsl:value-of select="concat($prefix, 'Relationship_', parent::node()/*[contains(name(), 'relationshipOfResource')]/text(), '_PID')"/> 
                                                                </xsl:attribute>
                                                                <xsl:value-of select="substring-before(substring-after(text(),'('), ')')"/>
                                                        </field>
                                                        <field>
                                                                <xsl:attribute name="name">
                                                                        <xsl:value-of select="concat($prefix, 'Relationship_', parent::node()/*[contains(name(), 'relationshipOfResource')]/text())"/> 
                                                                </xsl:attribute>
                                                                <xsl:value-of select="normalize-space(substring-before(text(),'('))"/>
                                                        </field>
                                                </xsl:if>
                                                <xsl:if test="not(contains(name(), 'relatedResourceID'))">
                                                        <field>
                                                                <xsl:attribute name="name">
                                                                        <xsl:value-of select="concat($prefix, 'Relationship_', substring-after(name(), ':'))"/> 
                                                                </xsl:attribute>
                                                                <xsl:value-of select="."/>
                                                        </field>
                                                </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:text></xsl:text>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:for-each>
                 
        </xsl:template>
</xsl:stylesheet>
