Class rcc.MONEY.Process Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='rcc.MONEY.MsgToProc' response='Ens.Response' height='2000' width='2000' >
<sequence xend='200' yend='600' >
<switch name='src check' xpos='200' ypos='250' xend='200' yend='500' >
<case condition='request.Src = "BW"' name='BW' >
<call name='make OFX BW' target='rcc.MONEY.OFX.BW' async='1' xpos='335' ypos='400' >
<request type='rcc.MONEY.MsgToOp' >
<assign property="callrequest.Ballance" value="request.Ballance" action="set" />
</request>
<response type='Ens.Response' />
</call>
</case>
<case condition='request.Src = "AT"' name='AT' >
<call name='make OFX AT' target='rcc.MONEY.OFX.AT' async='1' xpos='605' ypos='400' >
<request type='rcc.MONEY.MsgToOp' >
<assign property="callrequest.Ballance" value="request.Ballance" action="set" />
</request>
<response type='Ens.Response' />
</call>
</case>
<default name='default' />
</switch>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
