//
//  CF_SampleRESTConnector.h
//  GetEPGData
//
//  Created by  on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CF_SampleRESTConnector : NSObject {
    
    //Variables ----
    
    //JSON Connector
    NSMutableDictionary *connectJSON;
    
    //JSON Data Container
    NSData* jsonData;
    
    //JSON Response
    NSData *responseData;

}

//Methods
- (void)createAuthRESTSession;
- (NSData*)getRESTEPGData;

@end
