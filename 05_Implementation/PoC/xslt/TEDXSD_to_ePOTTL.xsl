<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:ted="ted/R2.0.9.S02/publication"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : TEDXSD_to_ePOTTL.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : Transformation from TED XSD to ePO TTL
    ####################################################################################
    -->
    <xsl:import href="common/CommonFunctions.xsl"/>
    <xsl:import href="common/ProcuringEntity.xsl"/>
    
    <xsl:template match="/">
        <xsl:result-document method="text" href="SPARQL_Inserts.txt">
            <xsl:call-template name="prefixes"/>
            
            <xsl:apply-templates/>
        </xsl:result-document>        
    </xsl:template>
    
    <xsl:template match="ted:NOTICE_UUID"/>
    <xsl:template match="ted:TECHNICAL_SECTION"/>
    <xsl:template match="ted:LINKS_SECTION"/>
    <xsl:template match="ted:CODED_DATA_SECTION"/>
    <xsl:template match="ted:TRANSLATION_SECTION"/>
    <xsl:template match="ted:OBJECT_CONTRACT"/>
    <xsl:template match="ted:PROCEDURE"/>
    <xsl:template match="ted:AWARD_CONTRACT"/>
    <xsl:template match="ted:COMPLEMENTARY_INFO"/>
    
</xsl:stylesheet>