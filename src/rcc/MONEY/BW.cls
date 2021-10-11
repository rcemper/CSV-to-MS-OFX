Class rcc.MONEY.BW Extends %Persistent [ Final, SqlRowIdPrivate, SqlTableName = BWX ]
{

Parameter DEFAULTGLOBAL = "^rcc.MONEY.BW.";

Property Ballance As %Numeric [ Transient ];

Property PartnerName As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = NAME ];

Property BookInfo As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MEMO ];

Property BookDate As %String(MAXLEN = "") [ SqlColumnNumber = 4 ];

Property Valuta As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = DTPOSTED ];

Property Amount As %String [ SqlColumnNumber = 6, SqlFieldName = TRNAMT ];

Property FITID As %String(MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = FITID ];

Property Ref As %String(MAXLEN = "") [ Private ];

Index idx On Ref [ IdKey ];

ClassMethod Load(file As %FileCharacterStream) As %Status
{
	do file.Rewind()
	for rec=1:1 {
		quit:file.AtEnd
		set rec=file.ReadLine()
	 	set obj=..%New()	
	 	set sc=0	
        set lis=$listfromstring(rec,";")
            ,p=$find($list(lis,2),"/00")
  		if '$listlength(lis) continue ;evtl. EOF ?
#;NAME      
        set n=$select((p-5)<30:p-6,1:30)
        set name=$piece($extract($list(lis,2),1,n),"  ")
        set obj.PartnerName=$select($length(name):name,1:"Bank")  		
#;FITID
        set fitid=+$extract($list(lis,2),p,p+7)
        if 'fitid continue
        set (obj.FITID,obj.Ref)=fitid
#;MEMO
        set memo=$extract($list(lis,2),1,p-6)_$extract($list(lis,2),p+8,*)
        set memo=$ZSTRIP(memo,"<=>"," ")
        set memo=$extract(memo,1,128)
        set obj.BookInfo=$select($length(memo):memo,1:"?")        		
#;Buchungsdatum
        set d=$zdateh($translate($list(lis,3),".","/"),4)
        set obj.BookDate=+$zdate(d,8)_"000000[+1:CET]"
#;DTPOSTED valuta
        set d=$zdateh($translate($list(lis,4),".","/"),4)
        set obj.Valuta=+$zdate(d,8)_"000000[+1:CET]"        
#;TRNAMT
        set obj.Amount=""_$justify(+$translate($translate($list(lis,5),"."),",","."),0,2) 
#;prevent double id		
  		if obj.%ExistsId(fitid) continue
		set sc=obj.%Save()
		if 'sc zw  b
	}
	quit sc
}

Method RefGet() As %Numeric [ ServerOnly = 1 ]
{
	Quit ..FITID
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
<Data name="BWDefaultData">
<Value name="1">
<Value>PartnerName</Value>
</Value>
<Value name="2">
<Value>BookInfo</Value>
</Value>
<Value name="3">
<Value>BookDate</Value>
</Value>
<Value name="4">
<Value>Valuta</Value>
</Value>
<Value name="5">
<Value>Amount</Value>
</Value>
<Value name="6">
<Value>FITID</Value>
</Value>
</Data>
<DataLocation>^rcc.MONEY.BW.D</DataLocation>
<DefaultData>BWDefaultData</DefaultData>
<IdLocation>^rcc.MONEY.BW.D</IdLocation>
<IndexLocation>^rcc.MONEY.BW.I</IndexLocation>
<StreamLocation>^rcc.MONEY.BW.S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
