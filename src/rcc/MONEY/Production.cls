Class rcc.MONEY.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="rcc.MONEY.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description>Load CSV from Bank to M$ MONEY</Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="rcc.MONEY.OFX.AT" Category="" ClassName="rcc.MONEY.OFX.AT" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">C:\MONEY\ENS\out\</Setting>
    <Setting Target="Adapter" Name="BankId">Erste</Setting>
    <Setting Target="Adapter" Name="AccountId">99900777</Setting>
    <Setting Target="Adapter" Name="Overwrite">1</Setting>
  </Item>
  <Item Name="rcc.MONEY.OFX.BW" Category="" ClassName="rcc.MONEY.OFX.BW" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">C:\MONEY\ENS\out\</Setting>
    <Setting Target="Adapter" Name="AccountId">BW12001744_Acc</Setting>
    <Setting Target="Adapter" Name="BankId">BW_bank</Setting>
    <Setting Target="Adapter" Name="Overwrite">1</Setting>
  </Item>
  <Item Name="rcc.MONEY.Process" Category="" ClassName="rcc.MONEY.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="rcc.MONEY.InputFileService" Category="" ClassName="rcc.MONEY.InputFileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">C:\MONEY\ENS\inp\</Setting>
    <Setting Target="Adapter" Name="FileSpec">AT*.csv;BW*.csv</Setting>
    <Setting Target="Adapter" Name="ArchivePath">C:\MONEY\ENS\arc\</Setting>
  </Item>
</Production>
}

}
