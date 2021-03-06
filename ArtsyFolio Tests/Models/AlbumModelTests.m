#import "Album.h"
#import "Artwork.h"

SpecBegin(Album);

describe(@"validations", ^{
    it(@"Album gets a default name if not set", ^{
        Album *album = [Album objectInContext:[CoreDataManager stubbedManagedObjectContext]];
        [album saveManagedObjectContextLoggingErrors];

        expect(album.name).to.beTruthy();
    });

    describe(@"collection methods", ^{
        __block NSManagedObjectContext *context;
        __block Album *album1, *album2, *album3, *allArtworksAlbum;
        __block NSArray *allEditableAlbums, *downloadedArtworks;

        beforeEach(^{
            context = [CoreDataManager stubbedManagedObjectContext];

            album1 = [Album objectInContext:context];
            album1.editable = @YES;
            album1.artworks = [NSSet setWithArray:@[ [Artwork objectInContext:context] ]];
            album1.updatedAt = [[NSDate alloc] initWithTimeIntervalSince1970:0];

            album2 = [Album objectInContext:context];
            album2.editable = @NO;
            album2.artworks = [NSSet setWithArray:@[ [Artwork objectInContext:context] ]];

            album3 = [Album objectInContext:context];
            album3.editable = @YES;
            album3.artworks = [NSSet setWithArray:@[ [Artwork objectInContext:context] ]];
            album3.updatedAt = [NSDate date];

            allArtworksAlbum = [Album createOrFindAlbumInContext:context slug:@"all_artworks"];
            allEditableAlbums = [Album editableAlbumsByLastUpdateInContext:context];
            downloadedArtworks = [Album downloadedAlbumsInContext:context];
        });

        describe(@"editable ordered by date", ^{
            it(@"contains editable albums", ^{
                expect(allEditableAlbums).to.contain(album1);
                expect(allEditableAlbums).toNot.contain(album2);
            });

            it(@"is ordered by update date", ^{
                expect(allEditableAlbums[0]).to.equal(album3);
                expect(allEditableAlbums[1]).to.equal(album1);
            });
        });

        describe(@"downloaded albums", ^{
            it(@"should not include All Artworks", ^{
               expect(downloadedArtworks).toNot.contain(allArtworksAlbum);
            });

            it(@"includes only un-editable albums", ^{
                expect(downloadedArtworks).toNot.contain(album1);
                expect(downloadedArtworks).to.contain(album2);
            });
        });

    });

    describe(@"create or find albums", ^{
        it(@"gets created if it doesnt exist", ^{
            NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];
            expect([Album countInContext:context error:nil]).to.equal(0);

            Album *allArtworksAlbum = [Album createOrFindAlbumInContext:context slug:@"all_artworks"];
            expect(allArtworksAlbum).to.beTruthy();
            expect([Album countInContext:context error:nil]).to.equal(1);
        });

        it(@"gets a the old reference if it exists", ^{
            NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];

            Album *allArtworksAlbum = [Album createOrFindAlbumInContext:context slug:@"all_artworks"];
            Album *newAllArtworksAlbum = [Album createOrFindAlbumInContext:context slug:@"all_artworks"];
            
            expect(allArtworksAlbum).to.equal(newAllArtworksAlbum);

        });
    });
});

SpecEnd
