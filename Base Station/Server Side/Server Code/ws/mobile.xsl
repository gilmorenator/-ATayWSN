<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">

The weather at <xsl:value-of select='all_stations/station/station_name'/> located at <xsl:value-of select='all_stations/station/station_location'/>.

<br />
      <xsl:for-each select="all_stations/station/entry">
      <xsl:sort select="datetime" order="descending"/>
	  
The weather at <xsl:value-of select='datetime'/> was as follows:
<br />
The wind is coming from <xsl:value-of select='wind_direction'/> degrees <xsl:value-of select='quadrant'/>. There was <xsl:value-of select='rainfall'/> mm of rain in the last hour. The temperature is <xsl:value-of select='temperature'/> degrees celcius.
<br />
<img>
			<xsl:attribute name="src">
			  <xsl:value-of select='picture'/>
			  </xsl:attribute>
			  <xsl:attribute name="alt"></xsl:attribute>
			  <xsl:attribute name="width">150</xsl:attribute>
			  <xsl:attribute name="height">122</xsl:attribute>

</img>
<br />
</xsl:for-each>
This station is currently <xsl:value-of select='all_stations/station/status'/> and will be updated at <xsl:value-of select='all_stations/station/next_update'/> which is <xsl:value-of select='all_stations/station/ttl'/> away.
	
	  
      
	  </xsl:template>
</xsl:stylesheet>