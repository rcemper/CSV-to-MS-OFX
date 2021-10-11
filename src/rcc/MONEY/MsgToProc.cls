Class rcc.MONEY.MsgToProc Extends Ens.Request
{

/// where does it come from
Property Src As %String;

Property Ballance As %Numeric;

Storage Default
{
<Data name="MsgToProcDefaultData">
<Subscript>"MsgToProc"</Subscript>
<Value name="1">
<Value>Src</Value>
</Value>
<Value name="2">
<Value>Balance</Value>
</Value>
<Value name="3">
<Value>Ballance</Value>
</Value>
</Data>
<DefaultData>MsgToProcDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
