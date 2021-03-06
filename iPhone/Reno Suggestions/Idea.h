//
//  Idea.h
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/15/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

//format of an idea as posted to betareno.cyberhobo.net
/*
api_key=BetaReno4hack4reno
what=text
who=text
latitutude=39.524435
longitude=-119.811745
when=2011-10-15+16:34:00+PDT (or empty)
before_photo=(multipart encoded binary or empty)
after_photo=(multipart encoded binary or empty)
*/

#import <Foundation/Foundation.h>

@interface Idea : NSObject

{
    NSMutableDictionary*           idea;
    
    /* key value pairs
    NSMutableString*        what;
    NSMutableString*        who;
    NSMutableString*        when;
    NSMutableString*        longitude;
    NSMutableString*        latitude;
    NSString*               beforePictureURL;
    NSString*               afterPictureURL;

    NSData*                 beforePicture;
    NSData*                 afterPicture;
    */
}
@property (nonatomic, retain) NSDictionary* idea;

-(id)initIdea;
-(void) saveIdeaField:(id)obj withKey:(NSString *)key;



@end
