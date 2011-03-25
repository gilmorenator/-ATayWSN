<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:template match="/">

<a> 
		
				  <xsl:attribute name="href">
		http://localhost/ws/
			  </xsl:attribute>
			  main menu
				</a>

<br />
The weather at <xsl:value-of select='all_stations/station/station_name'/> located at <xsl:value-of select='all_stations/station/station_location'/> the next update will be at <xsl:value-of select='all_stations/station/next_update'/>

<br />
      <xsl:for-each select="all_stations/station/entry">
      <xsl:sort select="datetime" order="descending"/>
	  
	  		<table>
			<xsl:attribute name="border">
			  1
			  </xsl:attribute>
	<tr>
		<td>
		  <xsl:attribute name="align">
			  center
			  </xsl:attribute>
			<xsl:value-of select='datetime'/> The battery voltage is: <xsl:value-of select='voltage'/>		

		</td>
	</tr>
	<tr>
		<td>
	
	<table>
	<xsl:attribute name="border">
			  0
			  </xsl:attribute>
	<tr>
	<td>
			<table>
			<xsl:attribute name="border">
			  0
			  </xsl:attribute>
			<tr>
			<td>
		  <xsl:attribute name="align">
			  center
			  </xsl:attribute>
		The wind speed is <xsl:value-of select='wind_speed'/> mph

			</td>
			</tr>
				<tr>
			<td>
		  <xsl:attribute name="align">
			  center
			  </xsl:attribute>
			
				
				
			  <img> 
		
		
				  <xsl:attribute name="src">
			 quadrant/<xsl:value-of select='quadrant'/>.PNG
			  </xsl:attribute>
			    <xsl:attribute name="height">
			 288
			  </xsl:attribute>
			  
				</img>
			</td>
			</tr>
				<tr>
			<td>
			
		  <xsl:attribute name="align">
			  center
			  </xsl:attribute>
		The wind is coming from  <xsl:value-of select='wind_direction'/> degrees

			</td>
			</tr>
			</table>

	</td>
	<td>
						<table>
						<xsl:attribute name="border">
			  0
			  </xsl:attribute>
								<tr>
									<td>
									  <xsl:attribute name="align">
			  center
			  </xsl:attribute>
								<img> 
		
				  <xsl:attribute name="src">
			 thermometer.gif
			  </xsl:attribute>
				</img>	<br />
									
									
								
								The temperature is <xsl:value-of select='temperature'/> celcius

									</td>
									</tr>
										<tr>
									<td>
									  <xsl:attribute name="align">
			  center
			  </xsl:attribute>
								During the last hour there was <xsl:value-of select='rainfall'/> mm of rain

								<br />
								<img> 
		
				  <xsl:attribute name="src">
			 rain.gif
			  </xsl:attribute>
				</img>
								
								
								
								
									</td>
									</tr>


						</table>

	</td>
<td>
			<img> 
		
				  <xsl:attribute name="src">
			 <xsl:value-of select='picture_farleft'/>
			  </xsl:attribute>
		
			  
				</img>
				<img> 
		
				  <xsl:attribute name="src">
			 <xsl:value-of select='picture_left'/>
			  </xsl:attribute>
	
			  
				</img>
				
				
				<img> 
		
				  <xsl:attribute name="src">
			 <xsl:value-of select='picture'/>
			  </xsl:attribute>
		
			  
				</img>
				
				
				<img> 
		
				  <xsl:attribute name="src">
			 <xsl:value-of select='picture_right'/>
			  </xsl:attribute>
		
			  
				</img>
				<img> 
		
				  <xsl:attribute name="src">
			 <xsl:value-of select='picture_farright'/>
			  </xsl:attribute>
			
			  
				</img>

</td>
	
	
	</tr>
	</table>

	

							

		</td>
	</tr>
	
	</table>         
      <br />
	  
      </xsl:for-each>
	  </xsl:template>
</xsl:stylesheet>
