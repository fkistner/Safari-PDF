//
//  SafariPDFPlugin.m
//  SafariPDF
//
//  Created by Florian Kistner on 03.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SafariPDFPlugin.h"
#import <FScript/FScript.h>
#import <WebKit/WebKit.h>
#import <WebKit/WebPreferences.h>

@implementation SafariPDFPlugin

/**
 * @return the single static instance of the plugin object
 */
//+ (SafariPDFPlugin*) sharedInstance
//{
//	static SafariPDFPlugin* plugin = nil;
//	
//	if (plugin == nil)
//		plugin = [[SafariPDFPlugin alloc] init];
//	
//	return plugin;
//}

/**
 * A special method called by SIMBL once the application has started and all classes are initialized.
 */
+ (void) load
{
	//SafariPDFPlugin* plugin = [SafariPDFPlugin sharedInstance];
	// ... do whatever
	[FScriptMenuItem insertInMainMenu];
	
	NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"PDF Snapshot …" action:@selector(menuItemAction:) keyEquivalent:@""];
	[item setTarget:self];
	NSMenu *menu = [[[NSApp mainMenu] itemAtIndex:1] submenu];
    //[menu addItem:[NSMenuItem separatorItem]];
    [menu addItem:item];
    [item release];
	
	NSLog(@"SafariPDFPlugin loaded");
}

+ (NSData *) capturePdfData
{
	id webView = [[[[NSApplication sharedApplication] orderedDocuments] objectAtIndex:0] currentWebView];
	id docView = [[[webView mainFrame] frameView] documentView];
	[docView lockFocus];
	
	WebPreferences *oldPref = [[webView preferences] retain];
	WebPreferences *newPref = [[WebPreferences alloc] initWithIdentifier:@"com.github.struct54.safari-pdf"];
	[newPref setShouldPrintBackgrounds:YES];
	[webView setPreferences:newPref];
	
	NSString *cssMedia = [webView mediaStyle];
	[webView setMediaStyle:@"screen"];
	
	NSData *data = [docView dataWithPDFInsideRect:[docView bounds]];
	
	[webView setMediaStyle:cssMedia];
	[webView setPreferences:oldPref];
	[newPref release];
	[oldPref release];
	
	[docView unlockFocus];
	return data;
}

+ (NSImage *) newImageFromPdfData
{
	NSData *data = [self capturePdfData];
	NSImage *img = [[NSImage alloc] initWithData: data];
	return img;
}

+ (BOOL) savePdfCapture
{	
	NSData *data = [self capturePdfData];
	NSSavePanel *sp;
	int runResult;
	
	/* create or get the shared instance of NSSavePanel */
	sp = [NSSavePanel savePanel];
	
	/* set up new attributes */
//	[sp setAccessoryView:newView];
	[sp setDirectoryURL:[NSURL fileURLWithPath:NSHomeDirectory()]];
	[sp setAllowedFileTypes:[NSArray arrayWithObject:@"pdf"]];
	
	/* display the NSSavePanel */
	runResult = [sp runModal];
	
	BOOL success = NO;
	/* if successful, save file under designated name */
	if (runResult == NSOKButton) {
		if ([data writeToFile:[sp filename] atomically:YES]) {
			success = YES;
		} else {
			NSBeep();
		}
	}
	return success;
}

+ (void)menuItemAction:(id)sender
{
	[self savePdfCapture];
}

@end
