<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : CommonFunctions.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : Common Functions: create individual
    ####################################################################################
    -->
    
    <xsl:template name="prefixes">
        <xsl:text>PREFIX : &lt;http://data.europa.eu/ePO/ontology#&gt;&#x0A;</xsl:text>
        <xsl:text>PREFIX rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;&#x0A;</xsl:text>
    </xsl:template>
    
    <xsl:template name="create_individual">
        <xsl:param name="subject"/>
        <xsl:param name="object"/>
        
        <xsl:call-template name="create_individual_begin">
            <xsl:with-param name="subject" select="$subject"/>
            <xsl:with-param name="object" select="$object"/>
        </xsl:call-template>
        <xsl:call-template name="create_individual_end"/>
    </xsl:template>
    
    <xsl:template name="create_insert">
        <xsl:text>&#x0A;INSERT DATA&#x0A;{&#x0A;</xsl:text>  
    </xsl:template>
    
    <xsl:template name="create_individual_begin">
        <xsl:param name="subject"/>
        <xsl:param name="object"/>
        
        <xsl:text>&#x0A;INSERT DATA&#x0A;{&#x0A;</xsl:text>
        <xsl:text>&#009;</xsl:text>
        <xsl:value-of select="$subject"/>
        <xsl:text> rdf:type </xsl:text>
        <xsl:value-of select="$object"/>
        <xsl:text>;&#x0A;</xsl:text>
    </xsl:template>
    <xsl:template name="create_individual_end">
        <xsl:text>&#x0A;};&#x0A;</xsl:text>
    </xsl:template>
    
    <xsl:template name="add_property_no_subject">
        <xsl:param name="predicate"/>
        <xsl:param name="object"/>
        <xsl:param name="last"/>
        
        <xsl:text>&#009;&#009;</xsl:text>
        <xsl:value-of select="$predicate"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$object"/>
        
        <xsl:if test="$last = true()"><xsl:text>.&#x0A;</xsl:text></xsl:if>
        <xsl:if test="$last = false()"><xsl:text>;&#x0A;</xsl:text></xsl:if>
        
    </xsl:template>
    
    <xsl:template name="add_property">
        <xsl:param name="subject"/>
        <xsl:param name="predicate"/>
        <xsl:param name="object"/>
        <xsl:param name="last"/>
        
        <xsl:text>&#009;</xsl:text>
        <xsl:value-of select="$subject"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$predicate"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$object"/>
        
        <xsl:if test="$last = true()"><xsl:text>.&#x0A;</xsl:text></xsl:if>
        <xsl:if test="$last = false()"><xsl:text>;&#x0A;</xsl:text></xsl:if>
        
    </xsl:template>
    
</xsl:stylesheet>