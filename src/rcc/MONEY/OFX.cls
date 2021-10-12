Class rcc.MONEY.OFX [ Abstract, Not ProcedureBlock ]
{

ClassMethod Make(
	File = "",
	Src = "",
	Ballance = 0,
	BankId = "",
	AcctId = "",
	Days = 25) As %Status
{
#; need CRLF als line terminator for WIN !!!!	
#define CRLF out.Write($c(13,10))	
 set out=##class(%Stream.FileBinary).%New()
 set out.Filename=File
 set since=$ZD($h-Days,8)_"000000[+1:CET]"
 set now=$ZD(+$h,8)_"000000[+1:CET]"
#;HEADER
    for i=1:1:37 {
        set lin=$p($TEXT(hdr+i),";;",2) 
        if lin["DTSTART" set lin=lin_since
        if (lin["DTSERV")||(lin["DTEND") set lin=lin_now
        if lin["BANKID" set lin=lin_BankId
        if lin["ACCTID" set lin=lin_AcctId
        do out.Write(lin),$$$CRLF
    w lin,!    
    }  
#;MAIN LOOP
	set sql="select DTPOSTED,TRNAMT,FITID,NAME,MEMO "
			_" from RCC_MONEY."_Src_"X "
			_" where not DTPOSTED < '"_since_"'"
	set rs=##class(%ResultSet).%New()
	set sc=rs.Prepare(sql)
	set sc=rs.Execute()
	while rs.Next() {
		do out.Write("<STMTTRN>"),$$$CRLF
		do out.Write("<TRNTYPE>XFER"),$$$CRLF
		for col="DTPOSTED","TRNAMT","FITID","NAME","MEMO" {
			set lin="<"_col_">"_rs.%Get(col)			
			do out.Write(lin),$$$CRLF
		}
	  do out.Write("</STMTTRN>"),$$$CRLF
	}
#;TRAILER
    for i=1:1:9 {
        set lin=$PIECE($TEXT(trailer+i),";;",2) 
        if lin["DTASOF" set lin=lin_now
        if lin["BALAMT" set lin=lin_Ballance
        do out.Write(lin),$$$CRLF
	}
 do out.Flush()
 quit $$$OK 

hdr
 ;;OFXHEADER:100
 ;;DATA:OFXSGML
 ;;VERSION:102
 ;;SECURITY:NONE
 ;;ENCODING:USASCII
 ;;CHARSET:1252
 ;;COMPRESSION:NONE
 ;;OLDFILEUID:NONE
 ;;NEWFILEUID:NONE
 ;;<OFX>
 ;;<SIGNONMSGSRSV1>
 ;;<SONRS>
 ;;<STATUS>
 ;;<CODE>0
 ;;<SEVERITY>INFO
 ;;</STATUS>
 ;;<DTSERVER>
 ;;<LANGUAGE>ENG
 ;;</SONRS>
 ;;</SIGNONMSGSRSV1>
 ;;<BANKMSGSRSV1>
 ;;<STMTTRNRS>
 ;;<TRNUID>1
 ;;<STATUS>
 ;;<CODE>0
 ;;<SEVERITY>INFO
 ;;</STATUS>
 ;;<STMTRS>
 ;;<CURDEF>EUR
 ;;<BANKACCTFROM>
 ;;<BANKID>
 ;;<ACCTID>
 ;;<ACCTTYPE>CHECKING
 ;;</BANKACCTFROM>
 ;;<BANKTRANLIST>
 ;;<DTSTART>
 ;;<DTEND>  
trailer
 ;;</BANKTRANLIST>
 ;;<LEDGERBAL>
 ;;<BALAMT>
 ;;<DTASOF>
 ;;</LEDGERBAL>
 ;;</STMTRS>
 ;;</STMTTRNRS>
 ;;</BANKMSGSRSV1>
 ;;</OFX>
}

}
