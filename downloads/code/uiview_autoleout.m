    UIView * A = [[UIView alloc] init];
    UIView * B = [[UIView alloc] init];
    A.translatesAutoresizingMaskIntoConstraints = NO;
    B.translatesAutoresizingMaskIntoConstraints = NO;
    A.backgroundColor =[UIColor purpleColor];
    B.backgroundColor =[UIColor orangeColor];
    [self.view addSubview:A];
    [self.view addSubview:B];
    
    UIView * rootView = self.view;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(A, B, rootView);
    NSArray *verticalConstraints   = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[A(80)]-10-[B(80)]"
                                                                             options:0 metrics:nil
                                                                               views:viewsDictionary];
    NSArray *horizontalAConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[A]-10-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary];
    NSArray *horizontalBConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[B]-10-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary];
    
    [self.view addConstraints:verticalConstraints];
    [self.view addConstraints:horizontalAConstraints];
    [self.view addConstraints:horizontalBConstraints];
