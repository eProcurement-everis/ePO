<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" 
xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" 
xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" 
xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
xmlns:ccts="urn:un:unece:uncefact:documentation:2"
xmlns:epo="http://data.europa.eu/ePO/ontology#"
xmlns:math="http://exslt.org/math"
extension-element-prefixes="math">

	<xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
	<xsl:template match="/">
		<xsl:call-template name="header"/>
		<xsl:call-template name="body"/>
		<xsl:apply-templates/> 
	</xsl:template>
	<xsl:template match="epo:DictionaryEntry">
		<xsl:apply-templates select="xsd:annotation"/>
	</xsl:template>
	<xsl:template match="xsd:annotation">
		<xsl:apply-templates select="xsd:documentation"/>
	</xsl:template>

	<xsl:template match="xsd:documentation">
	
	<xsl:variable name="examples" select="ccts:Examples"/>
	<xsl:variable name="source" select="epo:Sources"/>
	<xsl:variable name="usedIn" select="ccts:UsageRule"/>
	
	<xsl:variable name="entryPos">
		<xsl:number count="epo:DictionaryEntry" format="1"/>
	</xsl:variable>		
	
	<xsl:variable name="altC" select="count(ccts:AlternativeDataEntry)"/>	
	
	<xsl:variable name="Entry" select="upper-case(substring(ccts:DictionaryEntryName/text(), 1,1))"/>
	<xsl:variable name="nextEntry" select="upper-case(substring(../../../epo:DictionaryEntry[$entryPos + 1]/xsd:annotation/xsd:documentation/ccts:DictionaryEntryName/text(), 1,1))"/>		
	
	<xsl:if test="$entryPos = 1">
[.text-center]
== <xsl:value-of select="$Entry"/>
'''
</xsl:if>
[.text-left]
=== <xsl:value-of select="ccts:DictionaryEntryName"/>
<xsl:text>&#10;</xsl:text>
<xsl:text>&#10;</xsl:text>
<xsl:value-of select="ccts:Definition"/>
<xsl:text>&#10;</xsl:text>
<xsl:if test="ccts:AdditionalInformation !=''"> (<xsl:value-of select="ccts:AdditionalInformation"/>).</xsl:if>
		<xsl:if test="$altC >= 1">
<xsl:text>&#10;</xsl:text>
*Alternative definition<xsl:if test="$altC > 1">s</xsl:if>*:
<xsl:text>&#10;</xsl:text>
	<xsl:for-each select="ccts:AlternativeDataEntry">
			<xsl:variable name="alternativeDataEntry" select="ccts:AlternativeEntryName"/>
			<xsl:variable name="alternativeDefinition" select="ccts:AlternativeDefinition"/>
			<xsl:variable name="alternativeSource" select="ccts:AlternativeSource"/>
			<xsl:if test="$alternativeDefinition!=''">
* <xsl:value-of select="$alternativeDefinition"/><xsl:if test="$alternativeSource!=''">(Source: <xsl:value-of select="$alternativeSource"/>).</xsl:if>
			</xsl:if>
<xsl:text>&#10;</xsl:text>
		</xsl:for-each>
	</xsl:if>

<xsl:if test="$examples !=''">*Ex.*:<xsl:value-of select="$examples"/></xsl:if>	
<xsl:text>&#10;</xsl:text>
<xsl:if test="$source !=''">*Source*:<xsl:value-of select="$source"/></xsl:if>	
<xsl:text>&#10;</xsl:text>
<xsl:if test="$usedIn !=''">*Used in*:<xsl:value-of select="$usedIn"/></xsl:if>
<xsl:text>&#10;</xsl:text>
	<xsl:if test="$Entry != $nextEntry and $nextEntry !=''">
[.text-center]
== <xsl:value-of select="$nextEntry"/>
'''
<xsl:text>&#10;</xsl:text>
[.text-left]
	</xsl:if>	
	</xsl:template>
	<xsl:template name="header">
= eProcurement Ontology (ePO) Glossary
	</xsl:template>
	<xsl:template name="body">
The following list of e-Procurement concepts have been identified through an analysis of the e-Notification and e-Access phases and also taking into account the labels in the *e-Forms*, to be used soon by all tenderers in the EU.
*e-Forms* are one of the actions in the Single Market Strategy, where the European Commission has committed to "facilitate the collection, consolidation, management and analysis of procurement data, supporting Member States’ efforts towards better governance in public procurement".

In the GitHub section link:https://github.com/eProcurement-everis/ePO/wiki/Glossary-Management[Glossary Management] you will find instructions of how to contribute to the enrichment and improvement of the ePO Glossary.

This page was automatically generated using as the source a spreadsheet containing the 
link:https://github.com/eProcurement-everis/ePO/blob/master/02_IR_DED/eProcurement_glossary_and%20DED.ods[*Foundational e-Forms, the ePO Glossary and the Data Element Dictionary (DED)*], 
which takes its definitions from the ePO Glossary (click on the link to download this spreadsheet).

The transfomation is based on two XSL-T stylesheets. The resources used to generate the page can be downloaded from the folder "<a href="https://github.com/eProcurement-everis/ePO/tree/master/02_IR_DED/xlst" style="text-decoration:none;">02_IR_DED/xslt</a>", in the ePO Github source repository. Any suggestion to improve its layout and behaviour will be appreciated.
	</xsl:template>
</xsl:stylesheet>
