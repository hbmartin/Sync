#import "CommentsViewController.h"
#import "CommentsTableViewCell.h"

static const CGFloat HYPDistanceFromSides = 15.0;

@interface CommentsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSMutableArray *arrayWithComments;
@property (nonatomic) NSMutableArray *arrayWithSubcommentPositions;

@end

@implementation CommentsViewController

#pragma mark - UITableViewMethods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayWithComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell updateWithComment:self.arrayWithComments[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(HYPDistanceFromSides, HYPDistanceFromSides, [UIScreen mainScreen].bounds.size.width - HYPDistanceFromSides*2, 0)];;
    label.text = self.arrayWithComments[indexPath.row];
    label.numberOfLines = 1000;
    [label sizeToFit];
    return label.frame.size.height + HYPDistanceFromSides*2;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[CommentsTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.title = self.story.title;
    self.arrayWithComments = [NSMutableArray new];
    self.arrayWithSubcommentPositions = [NSMutableArray new];

    for (NSDictionary *dictionary in [NSKeyedUnarchiver unarchiveObjectWithData:self.story.comments]) {
        [self.arrayWithComments addObject:[dictionary objectForKey:@"body"]];

        for (NSDictionary *subDictionary in [dictionary objectForKey:@"comments"]) {
            [self.arrayWithComments addObject:[subDictionary objectForKey:@"body"]];
            [self.arrayWithSubcommentPositions addObject:@1];
        }

        [self.arrayWithSubcommentPositions addObject:@0];
    }

    [self.tableView reloadData];
}

@end
