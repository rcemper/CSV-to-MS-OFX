Class rcc.MONEY
{
/// Utility outside ENS to provide Ballances and start production
ClassMethod Init()
{
AT	set at=##class(rcc.MONEY.AT).%New()
	set bal=at.Ballance	
	write !,"Enter Ballance AT ("_bal_") :" read bnew,!
	if $l(bnew) {
		set bnew=+$tr(bnew," ,.","")/100 	
		write "New Ballance AT = "_bnew,!
		set at.Ballance=bnew
		kill at
		}
BW	set bw=##class(rcc.MONEY.BW).%New()
	set bal=bw.Ballance	
	write !,"Enter Ballance BW ("_bal_") :" read bnew,!
	if $l(bnew) {
		set bnew=+$tr(bnew," ,.","")/100 	
		write "New Ballance BW = "_bnew,!
		set bw.Ballance=bnew
		kill bw
		}
ENS	read !,"Start Production ? (yYnN)",bnew,!
	if $l(bnew),"yY"[$e(bnew) {
		set sc=##class(Ens.Director).StartProduction("rcc.MONEY.Production")
		if 'sc do $system.OBJ.DisplayError(sc) write !
		}
	do ..Wait()
}

/// wait for results
ClassMethod Wait(hng = 3)
{
	if 1	
	while $t {
		hang hng
		write !,"scan output for BW",!
		do ..DumpBW()
		write !,"scan output for AT",!
		do ..DumpAT()
		read !!,"Continue Scan? (yYnN)",bnew#1,! 	
		if $l(bnew),"yY"[$e(bnew)
		}
	write !,"Bye",!
	quit
}

ClassMethod DumpAT() As %Status
{
	do ##class(Ens.Director).GetAdapterSettings("rcc.MONEY.OFX.AT",.out)
	set dir=out("FilePath")
	set file="AT_*.OFX"
	quit ..Dump(dir,file)
}

ClassMethod Dump(
	dir,
	file = "") As %Status
{
	set rs=##class(%ResultSet).%New("%File:FileSet")
	set sc=rs.Execute(dir,file)
	while rs.Next() {
		set li($i(li))=$lb(rs.Data("ItemName"),rs.Data("Name"))
		write !,li,?5,$li(li(li))
		}
	set nb=0	
	while 'nb {
		read !,"select file #:",nb,! quit:+nb=0
		if '$d(li(nb)) set nb=0
		}
	quit:'nb '$$$OK
	set stream=##class(%Stream.FileCharacter).%New()
	set sc=stream.LinkToFile($li(li(nb),2))
	if sc do stream.OutputToDevice()
	else  do $system.OBJ.DisplayError(sc)
	quit sc
}

ClassMethod DumpBW() As %Status
{
	do ##class(Ens.Director).GetAdapterSettings("rcc.MONEY.OFX.BW",.out)
	set dir=out("FilePath")
	set file="BW_*.OFX"
	quit ..Dump(dir,file)
}

ClassMethod Stop(force = 0)
{
ENS	read !,"Stop Production ? (yYnN)",bnew,!
	if $l(bnew),"yY"[$e(bnew) {
		set sc=##class(Ens.Director).StopProduction(30,force)
		if 'sc do $system.OBJ.DisplayError(sc) write !
	}
	quit
}
// trigger quality check
}
