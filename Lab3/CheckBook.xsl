<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  <xsl:template match="checkbook">
    <html>
      <head/>
      <body>
        <h3>
          <xsl:text>Income from </xsl:text>
          <xsl:value-of select="child::*[1]/date"/>
          <xsl:text> until </xsl:text>
          <xsl:value-of select="child::*[last()]/date"/>
          <xsl:text>:</xsl:text>
        </h3>
        <xsl:apply-templates select="deposit"/>
        <h3>
          <xsl:text>Expenditures from </xsl:text>
          <xsl:value-of select="child::*[1]/date"/>
          <xsl:text> until </xsl:text>
          <xsl:value-of select="child::*[last()]/date"/>
          <xsl:text>, ranked from highest to lowest:</xsl:text>
        </h3>
        <xsl:apply-templates select="payment">
          <xsl:sort data-type="number" order="descending" select="amount"/>
        </xsl:apply-templates>
        <h3>Balance</h3>
        <p>
          <xsl:text>Your balance as of </xsl:text>
          <xsl:value-of select="child::*[last()]/date"/>
          <xsl:text> is </xsl:text>
          <tt>
            <b>
              <xsl:choose>
                <xsl:when test="sum( payment/amount )> sum( deposit/amount )">
                  <font color="red">
                    <xsl:text>$</xsl:text>
                    <xsl:value-of select="sum( deposit/amount )
                                    - sum( payment/amount )"/>
                  </font>
                </xsl:when>
                <xsl:otherwise>
                  <font color="blue">
                    <xsl:text>$</xsl:text>
                    <xsl:value-of select="sum( deposit/amount )
                                    - sum( payment/amount )"/>
                  </font>
                </xsl:otherwise>
              </xsl:choose>
            </b>
          </tt>
        </p>
        <xsl:if test="sum( payment/amount )> sum( deposit/amount )">
          <p>
            <font color="red">
              <xsl:text>DANGER! Deposit money quick!</xsl:text>
            </font>
          </p>
        </xsl:if>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="payment[@type='atm']">
    <p>
      <xsl:value-of select="position()"/>
      <xsl:text>. On </xsl:text>
      <xsl:value-of select="date"/>
      <xsl:text>, you withdrew </xsl:text>
      <tt>
        <b>
          <xsl:text>$</xsl:text>
          <xsl:value-of select="amount"/>
        </b>
      </tt>
      <xsl:text> from an ATM for </xsl:text>
      <xsl:value-of select="description"/>
      <xsl:text>.</xsl:text>
    </p>
  </xsl:template>

  <xsl:template match="payment">
    <p>
      <xsl:value-of select="position()"/>
      <xsl:text>. On </xsl:text>
      <xsl:value-of select="date"/>
      <xsl:text>, you paid </xsl:text>
      <tt>
        <b>
          <xsl:text>$</xsl:text>
          <xsl:value-of select="amount"/>
        </b>
      </tt>
      <xsl:text> to </xsl:text>
      <i>
        <xsl:value-of select="payee"/>
      </i>
      <xsl:text> for </xsl:text>
      <xsl:value-of select="description"/>
      <xsl:text>.</xsl:text>
    </p>
  </xsl:template>

  <xsl:template match="deposit">
    <p>
      <xsl:value-of select="position()"/>
      <xsl:text>. On </xsl:text>
      <xsl:value-of select="date"/>
      <xsl:text>, </xsl:text>
      <tt>
        <b>
          <xsl:text>$</xsl:text>
          <xsl:value-of select="amount"/>
        </b>
      </tt>
      <xsl:text> was deposited into your account by </xsl:text>
      <i>
        <xsl:value-of select="payor"/>
      </i>
      <xsl:text>.</xsl:text>
    </p>
  </xsl:template>
</xsl:stylesheet>