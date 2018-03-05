<?xml version="1.0" encoding="UTF-8"?>
<!-- edited with XMLSpy v2010 rel. 3 (x64) (http://www.altova.com) by everis Spain, S.L. (everis Spain, S.L.) -->
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" 
xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" 
xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" 
xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
xmlns:ccts="urn:un:unece:uncefact:documentation:2"
xmlns:epo="http://data.europa.eu/ePO/ontology#">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="office:body">
			<!-- output ISO 11179 root element starting tag -->
			<DataElementDictionary xmlns:epo="http://data.europa.eu/ePO/ontology#" xmlns:ccts="urn:un:unece:uncefact:documentation:2">
			<xsl:apply-templates select="office:spreadsheet/table:table"/>
			<!-- output ISO 11179 root element closing tag -->
			</DataElementDictionary>		
	</xsl:template>
	
	<xsl:template match="office:spreadsheet/table:table">
		<xsl:if test="upper-case(@table:name)= upper-case('ePO-Glossary')">
					<xsl:apply-templates select="table:table-row"/>
		</xsl:if>				
	</xsl:template>

	<xsl:function name="epo:getCellContent">
		<xsl:param name="node"/>
		<xsl:param name="colpos"/>
		<xsl:value-of select="$node/table:table-cell[sum(preceding-sibling::*/@table:number-columns-repeated) + position() - count(preceding-sibling::*/@table:number-columns-repeated) &lt;= $colpos][last()]/text:p/text()"/>	
	</xsl:function>

	<xsl:template match="table:table-row">
		<xsl:if test="position() >2">
			<xsl:call-template name="createComponent"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="createComponent">
	
		<xsl:variable name="ID" select="1"/>
		<xsl:variable name="CONCEPT" select="2"/>
		<xsl:variable name="DEFINITION" select="3"/>
		<xsl:variable name="EXAMPLES" select="4"/>
		<xsl:variable name="SOURCE" select="5"/>
		<xsl:variable name="ADDITIONAL_INFO" select="6"/>
		
		<xsl:variable name="PREFERRED_OPTION" select="8"/>
		<xsl:variable name="JUSTIFICATION" select="9"/>
		
		
		<!-- Phases -->
		<xsl:variable name="E-NOTIFICATION" select="16"/>
		<xsl:variable name="E-ACCESS" select="17"/>
		<xsl:variable name="E-SUBMISSION" select="18"/>
		<xsl:variable name="E-EVALUATION" select="19"/>
		<xsl:variable name="E-AWARDING" select="20"/>
		<xsl:variable name="E-REQUEST" select="21"/>
		<xsl:variable name="E-ORDERING" select="22"/>
		<xsl:variable name="E-FULFILMENT" select="23"/>
		<xsl:variable name="E-INVOICING" select="24"/>
		<xsl:variable name="E-PAYMENT" select="25"/>
	
		<xsl:variable name="examplesNotEmpy" select="epo:getCellContent(., $EXAMPLES)"/>
		<xsl:variable name="additionalInformationNotEmpty" select="epo:getCellContent(., $ADDITIONAL_INFO)"/>
		<xsl:variable name="justificationNotEmpty" select="epo:getCellContent(., $JUSTIFICATION)"/>
		<xsl:variable name="option" select="epo:getCellContent(., $PREFERRED_OPTION)"/>
				<xsl:if test="upper-case($option) = 'YES'">
					<epo:DictionaryEntry>
						<xsd:annotation>
							<xsd:documentation xml:lang="en">
								<ccts:DictionaryEntryName><xsl:value-of select="epo:getCellContent(., $CONCEPT)"/></ccts:DictionaryEntryName>
								<ccts:Definition><xsl:value-of select="epo:getCellContent(., $DEFINITION)"/></ccts:Definition>
								<xsl:if test="$examplesNotEmpy != ''"><ccts:Examples><xsl:value-of select="$examplesNotEmpy"/></ccts:Examples></xsl:if>
								<xsl:if test="$additionalInformationNotEmpty != ''"><ccts:AdditionalInformation><xsl:value-of select="$additionalInformationNotEmpty"/></ccts:AdditionalInformation></xsl:if>
								<xsl:if test="$justificationNotEmpty!= ''"><ccts:Justification><xsl:value-of select="$justificationNotEmpty"/></ccts:Justification></xsl:if>
								
								<xsl:variable name="nextSiblings" select="following-sibling::table:table-row"/>
								<xsl:variable name="currentConcept" select="epo:getCellContent(., $ID)"/>
								<xsl:for-each select="$nextSiblings">
									<xsl:variable name="nestedConcept" select="epo:getCellContent(., $ID)"/>
									<xsl:if test="upper-case($currentConcept) = upper-case($nestedConcept)">
										<ccts:AlternativeDataEntry>
											<ccts:AlternativeEntryName><xsl:value-of	select="epo:getCellContent(., $CONCEPT)"/></ccts:AlternativeEntryName>
											<ccts:AlternativeDefinition><xsl:value-of	select="epo:getCellContent(., $DEFINITION)"/></ccts:AlternativeDefinition>
											<ccts:AlternativeSource><xsl:value-of	select="epo:getCellContent(., $SOURCE)"/></ccts:AlternativeSource>
										</ccts:AlternativeDataEntry>
									</xsl:if>
								</xsl:for-each>
									
								<xsl:variable name="a" select="epo:getCellContent(., $E-NOTIFICATION)"/>			<xsl:variable name="b" select="epo:getCellContent(., $E-ACCESS)"/>
								<xsl:variable name="c" select="epo:getCellContent(., $E-SUBMISSION)"/>
								<xsl:variable name="d" select="epo:getCellContent(., $E-EVALUATION)"/>
								<xsl:variable name="e" select="epo:getCellContent(., $E-AWARDING)"/>
								<xsl:variable name="f" select="epo:getCellContent(., $E-REQUEST)"/>
								<xsl:variable name="g" select="epo:getCellContent(., $E-ORDERING)"/>
								<xsl:variable name="h" select="epo:getCellContent(., $E-FULFILMENT)"/>
								<xsl:variable name="i" select="epo:getCellContent(., $E-INVOICING)"/>
								<xsl:variable name="j" select="epo:getCellContent(., $E-PAYMENT)"/>
					
								<xsl:if test="$a != '' or $b != '' or $c != '' or $d != '' or $e != '' or $f != '' or $g != '' or $h != '' or $i != '' or $j != ''">
									<ccts:UsageRule>
										<xsl:if test="$a != ''">| e-Notification </xsl:if>
										<xsl:if test="$b !=''">| e-Access </xsl:if>
										<xsl:if test="$c !=''">| e-Submission </xsl:if>
										<xsl:if test="$d !=''">| e-Evaluation </xsl:if>
										<xsl:if test="$e !=''">| e-Awarding </xsl:if>
										<xsl:if test="$f !=''">| e-Request </xsl:if>
										<xsl:if test="$g !=''">| e-Ordering </xsl:if>
										<xsl:if test="$h !=''">| e-Fulfilment </xsl:if>
										<xsl:if test="$i !=''">| e-Invoicing </xsl:if>
										<xsl:if test="$j !=''">| e-Payment </xsl:if>|</ccts:UsageRule>
								</xsl:if>
							</xsd:documentation>
						</xsd:annotation>
					</epo:DictionaryEntry>
				</xsl:if>
	</xsl:template>	
</xsl:stylesheet>
