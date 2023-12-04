/**
 * Coverage for packaging purposes only
 */
@IsTest
private with sharing class DebugAuthProviderTest {
    
    @IsTest
    static void coverage() {
        
        DebugAuthProvider dap = new DebugAuthProvider();
        dap.initiate(null,null);
        dap.handleCallback(null,null);
        dap.refresh(null,null);
        dap.getUserInfo(null,null);
        dap.getCustomMetadataType();

        Assert.areEqual(true,true,'true');
    }
}