Class rcc.MONEY.OFX.OutboundAdapter Extends EnsLib.File.OutboundAdapter
{

Property BankId As %String [ InitialExpression = "MyBankId" ];

Property AccountId As %String [ InitialExpression = "myBankAccount" ];

Parameter SETTINGS = "BankId,AccountId,RegistryID:Basic:selector?context={Ens.ServiceRegistry.External.ContextSearch/Services?Protocols_1=File},FilePath:Basic:directorySelector,Overwrite,Charset::selector?context={Ens.ContextSearch/CharacterSets},OpenTimeout";

}
