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
                <xsl:param name="prefixdc">dcterms.</xsl:param>
                <xsl:param name="suffix">_s</xsl:param>
                
                <xsl:for-each select="$content//dwr:DarwinRecordSet/*">
                       <xsl:for-each select=".">
                               <field>
                                       <xsl:attribute name="name">
                                       <xsl:choose>
                                               <xsl:when test="(substring-before(name(),':')='dwc')">
                                                        <xsl:choose>
                                                               <!-- Create seperate DWC event fields -->
                                                               <xsl:when test="(substring-after(name(),':')='Event')">
                                                                       <xsl:variable name="eventType" select="dwc:eventRemarks/text()" />
                                                                       <xsl:for-each select=".">
                                                                               <xsl:value-of select="concat($prefix, substring-after(name(),':'), '_', $eventType, $suffix)"/>
                                                                       </xsl:for-each>  
                                                               </xsl:when>
                                                               <!-- Create seperate DWC taxon fields -->
                                                               <xsl:when test="(substring-after(name(),':')='Taxon')">
                                                                       <xsl:variable name="taxonType" select="dwc:taxonRemarks/text()" />
                                                                       <xsl:for-each select=".">
                                                                               <xsl:value-of select="concat($prefix, substring-after(name(),':'), '_', $taxonType, $suffix)"/>
                                                                       </xsl:for-each>  
                                                               </xsl:when>
                                                               <xsl:otherwise>
                                                                       <xsl:value-of select="concat($prefix, substring-after(name(),':'), $suffix)"/>
                                                               </xsl:otherwise>
                                                       </xsl:choose>
                                               </xsl:when>
                                               <xsl:otherwise>
                                                       <xsl:choose>
                                                               <xsl:when test="(substring-after(name(),':')='Location')">
                                                                       <xsl:variable name="locationType" select="normalize-space(dwc:locality/text())" />
                                                                       <xsl:for-each select=".">
                                                                               <xsl:value-of select="concat($prefixdc, substring-after(name(),':'), '_', translate($locationType, ' ', ''), $suffix)"/>
                                                                       </xsl:for-each>     
                                                               </xsl:when>
                                                               <xsl:otherwise>
                                                                       <xsl:value-of select="concat($prefixdc, substring-after(name(),':'),$suffix)"/>
                                                               </xsl:otherwise>
                                                       </xsl:choose>
                                                       
                                               </xsl:otherwise>
                                       </xsl:choose>
                                               </xsl:attribute>
                                       <xsl:for-each select="node()[not(self::text()[not(normalize-space())])]">
                                               <xsl:value-of select="normalize-space(text())"/>
                                               <xsl:text>;</xsl:text>
                                       </xsl:for-each>
                               </field>  
                       </xsl:for-each>
                </xsl:for-each>
        </xsl:template> 
 </xsl:stylesheet>
