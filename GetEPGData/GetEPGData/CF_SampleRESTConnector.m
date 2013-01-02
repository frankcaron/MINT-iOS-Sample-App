//
//  CF_SampleRESTConnector.m
//
//  Created by Frank Caron on 7/10/12.
//  Copyright (c) 2012 UXP Systems. All rights reserved.
//

#import "CF_SampleRESTConnector.h"

@implementation CF_SampleRESTConnector 

// =====================================================================
//
// createAuthRestSession
//
// Method to create an authenticated REST session with the MINT API
// 
// =====================================================================

- (void)createAuthRESTSession {
    
    // Start REST session --------------
    // ---------------------------------
    
    //Prepare Request String with a dictionary
    connectJSON = [[ NSMutableDictionary alloc] init];
    [connectJSON setObject:@"TESTHERE" forKey:@"username"];
    [connectJSON setObject:@"TESTHERE" forKey:@"credential"];
    [connectJSON setObject:@"TESTHERE" forKey:@"byPIN"];
    
    //Create temp error holder
    NSError *error = nil;
    
    //Serialize object to JSON data
    jsonData = [NSJSONSerialization dataWithJSONObject:connectJSON 
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    //Log the serialized JSON
    //NSLog(@"JSON = %@", jsonData);
    //NSLog(@"%@", @"======="); 
    
    //Prepare to establish the connection
    NSURL *url = [NSURL URLWithString:@"http://testenv/webconsole/rest/session/start"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"json" forHTTPHeaderField:@"Data-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: jsonData];
    
    //Create temp response holder
    NSHTTPURLResponse *response = nil;
    
    //Make the request
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //Check for errors
    if (error == nil && response.statusCode == 200) {
        //Log success                        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"Auth Success: %@", responseString);         
    } else if (error != nil) {
        //Log failure
        NSLog(@"Auth Failure: %@", [error localizedDescription]);
    } else {
        //Log errors                        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"Auth Error: %@", responseString); 
    }   

}

// =====================================================================
//
// getRESTEPGData
//
// Method to pull EPG Data for today from the RESTful MINT API
// 
// =====================================================================


- (NSData*)getRESTEPGData {
    
    // Fetch EPG Data ------------------
    // ---------------------------------
    
    //Prepare to establish the connection
    NSURL *url = [NSURL URLWithString:@"http://testenv/webconsole/rest/tv/epg/2012-12-06T00:00:00Z/2012-12-06T00:00:01Z"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //[request setValue:@"json" forHTTPHeaderField:@"Data-Type"];
    //[request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    //Make the request
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //Check for errors
    if (error != nil) {
        //Log errors
        NSLog(@"Pull Error: %@", [error localizedDescription]);
    } else {
        //Log success
        NSLog(@"Pull Success: %@", response);
        
        //Inform user with alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" 
                                                        message:@"Your data has been returned." 
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles: nil];
        [alert show];
    }
    
    //Log toString version of the data                       
    //NSString *responseString2 = [[NSString alloc] initWithData:responseData2 encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", responseString2);   
    
    //Return the response
    return responseData;
    
}

@end
