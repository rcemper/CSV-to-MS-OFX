Class rcc.MONEY.AT Extends %Persistent [ Final, SqlRowIdPrivate, SqlTableName = ATX ]
{

Parameter DEFAULTGLOBAL = "^rcc.MONEY.AT.";

Property BookDate As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = DTPOSTED ];

Property Ballance As %Numeric [ Transient ];

Property Amount As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = TRNAMT ];

Property BookRef As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = FITID ];

Property BookInfo As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = MEMO ];

Property PartnerName As %String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = NAME ];

Property Ref As %String(MAXLEN = "") [ Private ];

Property Valuta As %Date [ Private ];

Index idx On (Valuta, Ref) [ IdKey ];

ClassMethod Load(file As %FileCharacterStream) As %Status
{
	do file.Rewind()
	for rec=0:1 {
		quit:file.AtEnd
		if 'rec {
			set title=file.ReadLine()
			set tlist=$listfromstring($translate(title,$char(0)),";")
			set tit=$listbuild("Valutadatum","Betrag","Buchungsreferenz","Buchungs-Info","Partnername","Buchungsdatum")
 #;Partner IBAN;Partner BIC;Partner Kontonummer;Partner Bank-Code (BLZ);Währung
 			set collist=""
 			for t=1:1:$LISTLENGTH(tit) {
	 			set col=$listfind(tlist,$list(tit,t)) 
	 			set:col collist=collist_$listbuild(col)
	 			} 
	 		continue
	 		}
 		set obj=..%New()	
	 	set sc=0	
		set rec=file.ReadLine()
		set lis=$listfromstring($translate(rec,$char(0)),";") 
  		if '$listlength(lis) continue ;evtl. EOF ?
		
		for rcc=1:1:$listlength(collist) {
			set col=$list(collist,rcc) 
			goto $case(rcc,1:VALUTA
						,2:TRNAMT
						,3:FITID
						,4:MEMO
						,5:NAME
						,6:DTPOSTED
						,:DONE)
VALUTA	;1	;use booking date instead
			continue	
TRNAMT	;2	;Betrag
			set obj.Amount=""_$justify(+$translate($translate($list(lis,col),"."),",","."),0,2)
			continue
FITID	;3  ;Buchungsreferenz; Ersterfassungsreferenz; Fit
			set obj.BookRef=$list(lis,col)
			set obj.Ref=obj.BookRef
			continue
MEMO	;4	;Buchungs-Info    
			set obj.BookInfo=$select($list(lis,col)="":"???",1:..cvt($list(lis,col)))
			continue
NAME	;5  ;Partnername 
			set obj.PartnerName=$select($list(lis,col)="":"Bank",1:..cvt($list(lis,col)))
			continue
DTPOSTED ;6	;Buchungdatum um mit Auszug synchron zu sein ! 	  
			set obj.Valuta=$zdateh($translate($list(lis,col),".","/"),4)
			set obj.BookDate=+$zdate(obj.Valuta,8)_"000000[+1:CET]"
DONE
			continue						
			}
		set id=obj.Valuta_"||"_obj.Ref	
  		if obj.%ExistsId(id) continue
#; prevent double id		
		set sc=obj.%Save()
	}
	quit sc
}

/// convert to pure ASCII for M$ !!!
ClassMethod cvt(txt = "") As %String
{
 set:txt["&" txt=$replace(txt,"&","&amp;") 
 set:txt["Ä" txt=$replace(txt,"Ä","Ae") 
 set:txt["Ö" txt=$replace(txt,"Ö","Oe") 
 set:txt["Ü" txt=$replace(txt,"Ü","Ue") 
 set:txt["ä" txt=$replace(txt,"ä","ae") 
 set:txt["ö" txt=$replace(txt,"ö","oe") 
 set:txt["ü" txt=$replace(txt,"ü","ue") 
 set:txt["ß" txt=$replace(txt,"ß","ss") 
 quit txt
}

Method BallanceGet() As %Numeric [ ServerOnly = 1 ]
{
	Quit $g(@..#DATALOCATIONGLOBAL)
}

Method BallanceSet(Arg As %Numeric) As %Status [ ServerOnly = 1 ]
{
	set @..#DATALOCATIONGLOBAL= Arg    
	Quit $$$OK
}

Storage Default
{
<Data name="ATDefaultData">
<Value name="1">
<Value>BookDate</Value>
</Value>
<Value name="2">
<Value>Amount</Value>
</Value>
<Value name="3">
<Value>BookRef</Value>
</Value>
<Value name="4">
<Value>BookInfo</Value>
</Value>
<Value name="5">
<Value>PartnerName</Value>
</Value>
</Data>
<DataLocation>^rcc.MONEY.AT.D</DataLocation>
<DefaultData>ATDefaultData</DefaultData>
<IdLocation>^rcc.MONEY.AT.D</IdLocation>
<IndexLocation>^rcc.MONEY.AT.I</IndexLocation>
<StreamLocation>^rcc.MONEY.AT.S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
