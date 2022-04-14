<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:variable name="counter" select="0"/>


  <xsl:include href="header.xsl" />
  <xsl:include href="senderReceiver.xsl" />
  <xsl:include href="mailReason.xsl" />
  <xsl:include href="footer.xsl" />
  <xsl:include href="style.xsl" />
  <xsl:include href="recordTitle.xsl" />

  <xsl:variable name="PICKUP">
    <xsl:value-of select="notification_data/incoming_request/borrowing_library" />                                                   
  </xsl:variable>

  <!-- Extract the first two characters of the Agency Code to determine if this is a long loan (BANDSTRA 10/19/21) -->
  <xsl:variable name="AGENCY_CODE">
    <xsl:value-of select="substring($PICKUP, 9, 2)" />                                                   </xsl:variable>

  <xsl:variable name="PARTNER">
    <xsl:value-of select="notification_data/partner_name"/>
  </xsl:variable>

  <xsl:variable name="REQ_BAR">
    <xsl:value-of select="notification_data/incoming_request/requested_barcode" />                                                   
  </xsl:variable>

  <xsl:variable name="METADATA">
    <xsl:value-of select="notification_data/incoming_request/request_metadata" /> 
  </xsl:variable>

  <xsl:variable name="REQUESTED_BARCODE">
    <xsl:value-of select='substring-before(substring-after($METADATA,"dc:barcode>"),"&lt;/dc:")'/>                                            
  </xsl:variable>



  <xsl:template name="id-info">
    <xsl:param name="line"/>
    <xsl:variable name="first" select="substring-before($line,'//')"/>
    <xsl:variable name="rest" select="substring-after($line,'//')"/>
    <xsl:if test="$first = '' and $rest = '' ">
      <!--br/-->
    </xsl:if>
    <xsl:if test="$rest != ''">
      <xsl:value-of select="$rest"/><br/>
    </xsl:if>
    <xsl:if test="$rest = ''">
      <xsl:value-of select="$line"/><br/>
    </xsl:if>

  </xsl:template>

  <xsl:template name="id-info-hdr">
    <xsl:call-template name="id-info">
      <xsl:with-param name="line" select="notification_data/incoming_request/external_request_id"/>
      <xsl:with-param name="label" select="'Bibliographic Information:'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="/">
    <html>
      <head>
	<xsl:call-template name="generalStyle" />
      </head>

      <body>
	<xsl:attribute name="style">
	  <xsl:call-template name="bodyStyleCss" /> <!-- style.xsl -->
	</xsl:attribute>

	<xsl:choose>
	  <xsl:when test="$PARTNER = 'MeLCat'">  
	    <img src="https://col-hope.primo.exlibrisgroup.com/discovery/custom/01COL_HOPE-HOPE/img/mel-logo.png" alt="MeLCat Logo" /><br />
	    <xsl:value-of select="notification_data/general_data/current_date"/><br /> 
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:call-template name="head" /> <!-- header.xsl -->
	  </xsl:otherwise>
	</xsl:choose>

	<div class="messageArea">
	  <div class="messageBody">
	    <table cellspacing="0" cellpadding="5" border="0">


	      <tr>
		<td>
		  <b>@@supplied_to@@: </b>
		  <xsl:value-of select="notification_data/partner_name"/>
                </td>
	      </tr>

	      <tr>             
		<td>
		  <b>Pickup at: </b>
                  <xsl:value-of select='substring-after($PICKUP,"Pickup:")'/>
		</td>
	      </tr>
	      
	      <tr>
		<td>
		  <b>@@borrower_reference@@: </b>
		  <xsl:call-template name="id-info-hdr"/>
		</td>
	      </tr>



	      <tr>
		<td><b>@@my_id@@: </b><img src="externalId.png" alt="externalId" /></td>
	      </tr>

	      <tr>
		<td>
		  <b>@@format@@: </b>
		  <xsl:value-of select="notification_data/incoming_request/format"/>
		</td>
	      </tr>
	      <!--
		  <xsl:if  test="notification_data/incoming_request/needed_by_dummy/full_date" >
		    <tr>
		      <td>
			<b>@@date_needed_by@@: </b>
			<xsl:value-of select="notification_data/incoming_request/needed_by"/>
		      </td>
		    </tr>
		  </xsl:if>
		  -->

		  <xsl:if  test="notification_data/incoming_request/note != ''" >
		    <tr>
		      <td>
			<b>@@request_note@@: </b>
			<xsl:value-of select="notification_data/incoming_request/note"/>
		      </td>
		    </tr>
		  </xsl:if>
		  <!--
		      <xsl:if  test="notification_data/incoming_request/requester_email" >
			<tr>
			  <td>
			    <b>@@requester_email@@: </b>
			    <xsl:value-of select="notification_data/incoming_request/requester_email"/>
			  </td>
			</tr>
		      </xsl:if>
		      -->
		      <xsl:if  test="notification_data/assignee != ''" >
			<tr>
			  <td>
			    <b>@@assignee@@: </b>
			    <xsl:value-of select="notification_data/assignee"/>
			  </td>
			</tr>
		      </xsl:if>

		      <xsl:if test="notification_data/level_of_service !=''">
			<tr>
			  <td>
			    <b>@@level_of_service@@: </b>
			    <xsl:value-of select="notification_data/level_of_service"/>
			  </td>

			</tr>
		      </xsl:if>



		      <!--
			  <tr>
			    <td>

			      <br></br>
			    <b>Requested Barcode: </b><xsl:value-of select='$REQ_BAR'/></td>
			  </tr>



			  <tr>
			    <td>

			      <b>@@library@@: </b>
			      <xsl:value-of select="notification_data/items/physical_item_display_for_printing/library_name"/>
			    </td>
			  </tr>
			  <tr>
			    <td><b>@@location@@: </b><xsl:value-of select="notification_data/items/physical_item_display_for_printing/location_name"/></td>
			  </tr>


			  <tr>
			    <td><b>@@call_number@@: </b><xsl:value-of select="notification_data/items/physical_item_display_for_printing/call_number"/></td>
			  </tr>

			  -->





			  <xsl:for-each select="notification_data/items/physical_item_display_for_printing">
			    <br></br>

			    <xsl:variable name="BAR">
			      <xsl:value-of select="barcode" />                                                   
			    </xsl:variable>

			    <xsl:variable name="LOCATION_CODE">
			      <xsl:value-of select="location_code" />                                         
			    </xsl:variable>

			    <xsl:if test="$REQUESTED_BARCODE = $BAR ">
			      <tr><td>
				<br></br>
			      </td></tr>

			      <!-- Display a special note if this is a long loan (BANDSTRA 10/25/21) -->
			      <!-- UNCOMMENT THE FOLLOWING SECTION AFTER MCLS ACTIVATES "LONG LOANS" FOR HOPE COLLEGE -->
			      <!--
				  <xsl:if test="($AGENCY_CODE = 'za') or ($AGENCY_CODE = 'zg')"><xsl:if test="not($LOCATION_CODE = 'hvmc2') and not($LOCATION_CODE = 'hvux2') and not($LOCATION_CODE = 'hvvd2') and not($LOCATION_CODE = 'hvuc2') and not($LOCATION_CODE = 'hvuo2') and not($LOCATION_CODE = 'hvdvd') and not($LOCATION_CODE = 'hvvv2') and not($LOCATION_CODE = 'hvva2')"><tr><td style="background:#024;border:8px dotted #f46a1f;border-radius:4px;color:#fff;display:block;font-size:24px;font-weight:bold;margin-bottom:20px;padding:20px;text-align:center;width:100%">LONG LOAN</td></tr></xsl:if></xsl:if>
				  -->
				  <tr>

				    <td><xsl:value-of select="title"/></td>
				  </tr>

				  <tr>
				    <td>
				      <b>@@library@@: </b>
				      <xsl:value-of select="library_name"/>
				    </td>
				  </tr>

				  <tr>
				    <td><b>@@location@@: </b><xsl:value-of select="location_name"/></td>
				  </tr>
				      <xsl:if  test="call_number" >
					<tr>
					  <td><b>@@call_number@@: </b><xsl:value-of select="call_number"/></td>
					</tr>
				      </xsl:if>

				      <tr>
					<td><b>@@item_barcode@@: </b><img src="cid:{concat(concat('Barcode',position()),'.png')}" alt="{concat('Barcode',position())}" /></td>
				      </tr>



				      <xsl:if test="issue_level_description !=''">
					<tr>
					  <td>
					    <b>Description:</b><xsl:value-of select="issue_level_description"/>
					  </td>
					</tr>
				      </xsl:if>


			    </xsl:if>


			  </xsl:for-each>    


			</table>
		      </div>
		    </div>


		    <table>
		      <xsl:attribute name="style">
			<xsl:call-template name="footerTableStyleCss" /> <!-- style.xsl -->
		      </xsl:attribute>
		      <tr>
			<xsl:attribute name="style">
			  <xsl:call-template name="listStyleCss" /> <!-- style.xsl -->
			</xsl:attribute>
			<td align="center">Hope&#160;College&#160;Van&#160;Wylen&#160;Library&#160;&#40;zg520&#41;</td>
		      </tr>
		    </table>


		  </body>
		</html>


	      </xsl:template>
	    </xsl:stylesheet>
