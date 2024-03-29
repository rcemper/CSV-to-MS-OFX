Class rcc.MONEY.InputFileService Extends Ens.BusinessService
{
/// Find acceptable input file

Parameter ADAPTER = "EnsLib.File.InboundAdapter";

Method OnProcessInput(
	pInput As %FileCharacterStream,
	Output pOutput As %RegisteredObject) As %Status
{
	set file=$p(pInput.Filename,pInput.Directory,2)
		,src=$e(file,1,2)
	set obj=$CLASSMETHOD("rcc.MONEY."_src,"%New")
	set bal=obj.BallanceGet()
	do obj.Load(pInput)
	set msg=##class(rcc.MONEY.MsgToProc).%New()
	set msg.Src=src
	set msg.Ballance=+bal
	DO ..SendRequestAsync("rcc.MONEY.Process",msg)
	Quit $$$OK
}

}
