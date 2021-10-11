Class rcc.MONEY.OFX.AT Extends Ens.BusinessOperation
{

Parameter ADAPTER = "rcc.MONEY.OFX.OutboundAdapter";

Property Adapter As rcc.MONEY.OFX.OutboundAdapter;

Method OP(
	pRequest As rcc.MONEY.MsgToOp,
	Output pResponse As Ens.Response) As %Status
{
	set file=..Adapter.FilePath_"AT_"_$TR($ZDT($h,8)," :","_")_".OFX"
	set ball=pRequest.Ballance
	set bkid=..Adapter.BankId
	set acid=..Adapter.AccountId
	set sc=##class(rcc.MONEY.OFX).Make(file,"AT",ball,bkid,acid)
	quit $$$OK
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
