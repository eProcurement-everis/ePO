<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : EconomicOperator.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : CONTRACTOR from TED to :EconomicOperator and :EconomicOperatorGroup from ePO
    ####################################################################################
    -->
    <!-- TED - AWARD_CONTRACT/AWARDED_CONTRACT maps to ePO - EconomicOperator or EconomicOperatorGroup -->
    <xsl:template match="ted:AWARD_CONTRACT[parent::*/@CATEGORY = 'ORIGINAL']/ted:AWARDED_CONTRACT">        
        <!-- If ted:NO_AWARDED_TO_GROUP, maps with :EconomicOperator. And there is only one. -->
        <xsl:if test="exists(ted:NO_AWARDED_TO_GROUP)">
            <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
            <xsl:call-template name="create_EO">
                <xsl:with-param name="subject" select="'_:EO'"/>
                <xsl:with-param name="last" select="true()"/>
            </xsl:call-template>
            <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
        </xsl:if>
        <!-- If ted:AWARDED_TO_GROUP, maps with :EconomicOperatorGroup -->
        <xsl:if test="exists(ted:AWARDED_TO_GROUP)">
            <xsl:call-template name="create_EOGroup"/>
        </xsl:if>        
    </xsl:template>
    
    <!-- :EconomicOperatorGroup individual -->
    <xsl:template name="create_EOGroup">
        <!-- Start SPARQL query :EconomicOperator individual -->
        <xsl:call-template name="create_individual_begin">
            <xsl:with-param name="subject" select="'_:EOG'"/>
            <xsl:with-param name="object" select="':EconomicOperatorGroup'"/>
        </xsl:call-template>
        
        <!-- :EconomicOperatorGroup :groupsEconomicOperators :EconomicOperator -->
        <xsl:for-each select="ted:CONTRACTOR">
            <xsl:variable name="id_number" select="count(following-sibling::ted:CONTRACTOR)"/>
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="':groupsEconomicOperators'"/>
                <xsl:with-param name="object" select="concat('_:EO',$id_number)"/>
                <xsl:with-param name="last" select="if($id_number=0) then true() else false()"/>
            </xsl:call-template>
        </xsl:for-each>
        
        <!-- Each :EconomicOperatorGroup memebers must be inserted as :EconomicOperator individual with :isMemberOf _:EOG -->
        <xsl:call-template name="create_EOGroup_members">
            <xsl:with-param name="EO" select="."/>
        </xsl:call-template>
        
        <!-- Close SPARQL query -->
        <xsl:call-template name="create_individual_end"/>        
    </xsl:template>
    
    <xsl:template name="create_EOGroup_members">
        <xsl:param name="EO"/>
        
        <xsl:for-each select="$EO/ted:CONTRACTOR">
            <xsl:variable name="id_number" select="count(following-sibling::ted:CONTRACTOR)"/>
            <!-- :EconomicOperator individual -->
            <xsl:call-template name="create_EO">
                <xsl:with-param name="subject" select="concat('_:EO',$id_number)"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="':isMemberOf'"/>
                <xsl:with-param name="object" select="'_:EOG'"/>
                <xsl:with-param name="last" select="true()"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <!-- :EconomicOperator individual -->
    <xsl:template name="create_EO">
        <xsl:param name="subject"/>
        <xsl:param name="last"/>
        
        <!-- :EconomicOperator individual -->
        <xsl:call-template name="add_property">
            <xsl:with-param name="subject" select="$subject"/>
            <xsl:with-param name="predicate" select="'rdf:type'"/>
            <xsl:with-param name="object" select="':EconomicOperator'"/>
            <xsl:with-param name="last" select="$last"/>
        </xsl:call-template>
                
        <!-- _:EconomicOperator :hasCountryCode countryCode -->
        <!-- UNCOMMENT WHEN country code values ARE IN THE TTL -->
        <!--xsl:call-template name="add_property_no_subject">
            <xsl:with-param name="predicate" select="':hasCountryCode'"/>
            <xsl:with-param name="object" select="concat(':', ted:CONTRACTOR/ted:ADDRESS_CONTRACTOR/ted:COUNTRY/@VALUE)"/>
            <xsl:with-param name="last" select="true()"/>
        </xsl:call-template-->        
    </xsl:template>
    
</xsl:stylesheet>