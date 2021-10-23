Class rcc.MONEY.OFX.BW Extends Ens.BusinessOperation
{

Parameter ADAPTER = "rcc.MONEY.OFX.OutboundAdapter";

Property Adapter As rcc.MONEY.OFX.OutboundAdapter;

Parameter INVOCATION = "InProc";

Method OP(
	pRequest As rcc.MONEY.MsgToOp,
	Output pResponse As Ens.Response) As %Status
{
	set file=..Adapter.FilePath_"BW_"_$TR($ZDT($h,8)," :","_")_".OFX"
	set ball=pRequest.Ballance
	set bkid=..Adapter.BankId
	set acid=..Adapter.AccountId
	set sc=##class(rcc.MONEY.OFX).Make(file,"BW",ball,bkid,acid)
	set pResponse=##class(Ens.Response).%New()
	quit sc
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="rcc.MONEY.MsgToOp"> 
		<Method>OP</Method>
	</MapItem>
</MapItems>
}

}
