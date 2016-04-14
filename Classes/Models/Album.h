#import "_Album.h"
#import "ARGridViewItem.h"

#import "ARArtworkContainer.h"
#import "ARDocumentContainer.h"

@class Artwork, Artist, AlbumDelete;


@interface Album : _Album <ARGridViewItem, ARDocumentContainer, ARArtworkContainer>

@property (strong, nonatomic) NSSet *artworkSlugs;

+ (Album *)createOrFindAlbumInContext:(NSManagedObjectContext *)context slug:(NSString *)slug;

+ (NSFetchRequest *)allAlbumsFetchRequestInContext:(NSManagedObjectContext *)context;

+ (NSArray *)autoGeneratedAlbumsInContext:(NSManagedObjectContext *)context;

/// All editable albums
+ (NSArray *)editableAlbumsByLastUpdateInContext:(NSManagedObjectContext *)context;

- (void)updateArtists;

/// This is a version of the slug that will always have a prefixed partner ID
- (NSString *)publicSlug;

/// This creates ( and saves ) an AlbumEdit to the MOC, while
/// also setting the new artworks if it was previously at zero artworks.
- (AlbumEdit *)commitEditToArtworks:(NSArray *)newArtworks;

/// This deletes the Album and creates an AlbumDelete log in the MOC.
- (AlbumDelete *)commitAlbumDeletion;


@end
