Class rcc.MONEY
{

/// Utility outside ENS
ClassMethod Init()
{
AT	set at=##class(rcc.MONEY.AT).%New()
	set bal=at.Ballance	
	write !,"Enter Ballance AT ("_bal_") :" read new,!
	if $l(new) {
		set new=+$tr(new," ,.","")/100 	
		write "New Ballance AT = "_new,!
		set at.Ballance=new
		kill at
		}
BW	set bw=##class(rcc.MONEY.BW).%New()
	set bal=bw.Ballance	
	write !,"Enter Ballance BW ("_bal_") :" read new,!
	if $l(new) {
		set new=+$tr(new," ,.","")/100 	
		write "New Ballance BW = "_new,!
		set bw.Ballance=new
		kill bw
		}
ENS	read !,"Start Production ? (yYnN)",new,!
	if $l(new),"yY"[$e(new) {
		set sc=##class(Ens.Director).StartProduction("rcc.MONEY.Production")
		if 'sc do $system.OBJ.DisplayError(sc) write !
		}
	do ..Wait()
}

/// wait for reeults
ClassMethod Wait(hang = 5)
{
	if 1	
	while $t {
		hang hang
		do ..DumpBW()
		do ..DumpAT()
		read !!,"Continue ? (yYnN)",new#1,! 	
		if $l(new),"yY"[$e(new)
		}
	write !,"Bye",!
	quit
}

ClassMethod DumpAT(
	datestring = 0,
	all = 0) As %Status
{
	set sc=##class(Ens.Director).GetAdapterSettings("rcc.MONEY.OFX.AT",.out)
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
		read !,"select file #:",nb  quit:+nb=0
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
	set sc=##class(Ens.Director).GetAdapterSettings("rcc.MONEY.OFX.BW",.out)
	set dir=out("FilePath")
	set file="BW_*.OFX"
	quit ..Dump(dir,file)
}

ClassMethod Stop(force = 0)
{
ENS	read !,"Stop Production ? (yYnN)",new,!
	if $l(new),"yY"[$e(new) {
		set sc=##class(Ens.Director).StopProduction(30,force)
		if 'sc do $system.OBJ.DisplayError(sc) write !
	}
	quit
}

}
