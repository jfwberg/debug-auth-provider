/**
 * Debug Auth. Provider
 */
public with sharing class DebugAuthProvider extends Auth.AuthProviderPluginClass{

    public String authProviderName = 'DebugAuthProvider';

    @SuppressWarnings('PMD.ApexOpenRedirect')
    public PageReference initiate(Map<String,String> authProviderConfiguration, String stateToPropagate){ 
        
        // Create a callback to the debug auth provider
        PageReference pr = new PageReference(URL.getOrgDomainUrl().toExternalForm() + '/services/authcallback/' + this.authProviderName);
        
        // Add some details about the user in the initiate state to add to our access token
        pr.getParameters().put('initiateUserId',   UserInfo.getUserId());
        pr.getParameters().put('initiateUserName', UserInfo.getUserName());
        pr.getParameters().put('state', stateToPropagate);

        return pr;
    }


    public Auth.AuthProviderTokenResponse handleCallback(Map<String,String> authProviderConfiguration, Auth.AuthProviderCallbackState callbackState){
        
        // Initiating user details
        String iUserId   = (!Test.isRunningTest()) ? callbackState.queryParameters.get('initiateUserId')  : 'test';
        String iUserName = (!Test.isRunningTest()) ? callbackState.queryParameters.get('initiateUserName'): 'test';

        // Current user details
        String cUserId   = UserInfo.getUserId();
        String cUserName = UserInfo.getUserName();

        return new Auth.AuthProviderTokenResponse(
            this.authProviderName,
            String.format(
                'iUserId__"{0}"__iUserName__"{1}"__cUserId__"{2}"__cUserName__"{3}"',
                new String[]{iUserId, iUserName, cUserId, cUserName}
            ),
            'No_Refresh_Token_In_This_OAuth_Flow',
            (!Test.isRunningTest()) ? callbackState.queryParameters.get('state') : 'test'
        ); 
    }


    public override Auth.OAuthRefreshResult refresh(Map<String,String> authProviderConfiguration, String refreshToken){

        // Current user details
        String cUserId   = UserInfo.getUserId();
        String cUserName = UserInfo.getUserName();

        return new Auth.OAuthRefreshResult(
            this.authProviderName,
            String.format(
                'REFRESH__iUserId__"{0}"__REFRESH__iUserName__"{1}"',
                new String[]{cUserId, cUserName}
            )
        );
    }


    public Auth.UserData getUserInfo(Map<string,string> authProviderConfiguration, Auth.AuthProviderTokenResponse response) {
        return new Auth.UserData(
            UserInfo.getUserId(),   // User Id
            UserInfo.getFirstName(),// First Name
            UserInfo.getLastName(), // Last Name
            UserInfo.getUserName(), // Full Name
            UserInfo.getUserEmail(),// Email Address
            'link',                 // Link
            null,                   // Username
            null,                   // Locale
            null,                   // Provider
            null,                   // Site login
            null                    // Attribute map
        );
    }


    public String getCustomMetadataType() {
        return String.valueOf(DebugAuthProvider__mdt.getSObjectType());
    }
}