<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : ProcuringEntity.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : CONTRACTING_BODY from TED to :ProcuringEntity from ePO
    ####################################################################################
    -->
    
    <!-- TED - CONTRACTING_BODY maps to ePO - ProcuringEntity -->
    <xsl:template match="ted:CONTRACTING_BODY[parent::*/@CATEGORY = 'ORIGINAL']">
        <xsl:variable name="root_name" select="/*[1]/ted:FORM_SECTION/child::*[contains(name(), '_2014')]/name()"/>
        
        <!-- :ProcuringEntity individual (TED XML has only one CONTRACTING_BODY. ePO :ProcuringProcedure has one and only one :ProcuringEntity) -->
        <xsl:call-template name="ProcuringEntityIndividual">
            <xsl:with-param name="root_name" select="$root_name"/>
            <xsl:with-param name="check_jointProcurement" select="true()"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :ProcuringEntity individual -->
    <xsl:template name="ProcuringEntityIndividual">
        <xsl:param name="root_name"/>
        <xsl:param name="check_jointProcurement"/>
        
        <!-- Start SPARQL query :ProcuringEntity individual -->
        <xsl:call-template name="create_individual_begin">
            <xsl:with-param name="subject" select="'_:PE'"/>
            <xsl:with-param name="object" select="':ProcuringEntity'"/>
        </xsl:call-template>
        
        
        <!-- _:ProcuringEntity :hasProcuringEntityType :CA (Contracting Authority) or :CE (Contracting Entity) -->
        <xsl:call-template name="ProcuringEntityType">
            <xsl:with-param name="root_name" select="$root_name"/>            
        </xsl:call-template>
        
        <!-- _:ProcuringEntity :hasProcuringEntityRoleType :JPL (Joint Procurement Lead) if JOINT_PROCUREMENT_INVOLVED element exist -->
        <xsl:if test="$check_jointProcurement = true()">
            <xsl:call-template name="jointProcurement"/>
        </xsl:if>
        
        
        <!-- Close SPARQL query -->
        <xsl:call-template name="create_individual_end"/>
    </xsl:template>
    
    <!-- _:ProcuringEntity :hasProcuringEntityType :CA (Contracting Authority) or :CE (Contracting Entity), depending on the FORM_SECTION/child::*/name() type -->
    <xsl:template name="ProcuringEntityType">
        <xsl:param name="root_name"/>
        
        <!-- Every form has pre-defined the ProcuringEntityType, except F08_2014, F12_2014, F13_2014, F15_2014 which could have both types -->
        <xsl:variable name="type" select="document('MappingStructure.xml')/FORM_SECTION/ProcuringEntityType/section[@root=$root_name]/@petype"/>
        <xsl:variable name="xml_type" select="if(exists(ted:CA_ACTIVITY) or $type=':CA') then ':CA' else ':CE'"/>
        
        <xsl:call-template name="add_property_no_subject">
            <xsl:with-param name="predicate" select="':hasProcuringEntityType'"/>
            <xsl:with-param name="object" select="$xml_type"/>
            <xsl:with-param name="last" select="false()"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- _:ProcuringEntity :hasProcuringEntityRoleType :JPL (Joint Procurement Lead) if JOINT_PROCUREMENT_INVOLVED element exist -->
    <xsl:template name="jointProcurement">
        <xsl:if test="exists(ted:JOINT_PROCUREMENT_INVOLVED)">
            <!-- Main :ProcuringEntity has the JPL role of the joint procurement -->
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="':hasProcuringEntityRoleType'"/>
                <xsl:with-param name="object" select="':JPL'"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
            
            <!-- Main :ProcuringEntity :jointProcurement, relates with the other members of the joint procurement (ADDRESS_CONTRACTING_BODY_ADDITIONAL) -->
            <xsl:for-each select="ted:ADDRESS_CONTRACTING_BODY_ADDITIONAL">
                <xsl:variable name="id_number" select="count(following-sibling::ted:ADDRESS_CONTRACTING_BODY_ADDITIONAL)"/>
                <xsl:call-template name="add_property_no_subject">
                    <xsl:with-param name="predicate" select="':jointProcurement'"/>
                    <xsl:with-param name="object" select="concat('_:PE',$id_number)"/>
                    <xsl:with-param name="last" select="if($id_number=0) then true() else false()"/>
                </xsl:call-template>     
            </xsl:for-each>
            
            <!-- Each joint procurement members must be inserted as :ProcuringEntity individual with :hasProcuringEntityRoleType :JPM role -->
            <xsl:call-template name='jointProcurementEntity'>
                <xsl:with-param name="PE" select="."/>                
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- Each joint procurement members must be inserted as :ProcuringEntity individual with :hasProcuringEntityRoleType :JPM role -->
    <xsl:template name="jointProcurementEntity">
        <xsl:param name="PE"/>
        
        <xsl:variable name="root_name" select="/*[1]/ted:FORM_SECTION/child::*[contains(name(), '_2014')]/name()"/>
        
        <xsl:for-each select="$PE/ted:ADDRESS_CONTRACTING_BODY_ADDITIONAL">
            <xsl:variable name="id_number" select="count(following-sibling::ted:ADDRESS_CONTRACTING_BODY_ADDITIONAL)"/>
            <!-- :ProcuringEntity individual -->
            <xsl:call-template name="add_property">
                <xsl:with-param name="subject" select="concat('_:PE',$id_number)"/>
                <xsl:with-param name="predicate" select="'rdf:type'"/>
                <xsl:with-param name="object" select="':ProcuringEntity'"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
            <!-- :ProcuringEntity has the JPM role of the joint procurement -->
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="':hasProcuringEntityRoleType'"/>
                <xsl:with-param name="object" select="':JPM'"/>
                <xsl:with-param name="last" select="true()"/>
            </xsl:call-template>  
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>