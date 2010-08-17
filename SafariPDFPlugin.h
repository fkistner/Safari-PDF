//
//  SafariPDFPlugin.h
//  SafariPDF
//
//  Created by Florian Kistner on 03.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SafariPDFPlugin : NSObject {

}

//+ (SafariPDFPlugin*) sharedInstance;
+ (void) load;
+ (NSData *) capturePdfData;
+ (NSImage *) newImageFromPdfData;
+ (BOOL) savePdfCapture;
+ (void)menuItemAction:(id)sender;

@end
