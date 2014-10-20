package ObjectManager;

my %objects;

my %attributes = (
    'name' => 'First Name',
    'lastname' => 'Last Name',
    'age' => 'Age'
);

sub fill
{
    $objects{0} = {'name' => 'Petr', 'lastname' => 'Kuklianov', 'age' => 25};
    $objects{1} = {'name' => 'Den', 'lastname' => 'Davidoff', 'age' => 25};
    $objects{2} = {'name' => 'Ilya', 'lastname' => 'Pastukhov', 'age' => 22};
}

sub add
{
    my @ids = get_ids();
    my $id = 0;
    
    if(scalar @ids != 0)
    {
        $id = $ids[scalar @ids - 1]; # scalar @ids возвращает длину массива
        $id++;
    }
    
    my %obj;
    $objects{$id} = {};
    foreach $key (keys %attributes) {
        print $attributes{$key} . ": ";
        my $value = <STDIN>;
        $value = trim($value);
        $objects{$id}->{$key} = $value;
    }
    
    print "Object is added.\n";
}

sub edit
{
    print "Enter ID: ";
    my $id = <STDIN>;
    $id--;
    if(!exists($objects{$id})) {
        print "Object not exists\n";
        return;
    }
    
    foreach $key (keys %attributes) {
        my $oldValue = $objects{$id}->{$key};
        print $attributes{$key} . " [$oldValue]: ";
        my $value = <STDIN>;
        $value = trim($value);
        if(length $value == 0) {
            $value = $oldValue;
        }
        $objects{$id}->{$key} = $value;
    }
    
    print "Object is changed.\n";
}

sub remove
{
    print "Enter ID: ";
    my $id = <STDIN>;
    $id--;
    if(!exists($objects{$id})) {
        print "Object not exists\n";
        return;
    }
    
    delete $objects{$id};
    
    print "Removed.\n";
}

sub list
{
    my @ids = get_ids();
    
    if(scalar @ids > 0) 
    {
        print "\n--------------------------------------------------\n";
    }

    foreach $id (values @ids)
    {
        my $obj = $objects{$id};
        print "ID: ";
        printf("%-46s|\n", $id + 1);
        
        foreach $key (keys $obj)
        {
            printf "%-20s", $attributes{$key} . ':';
            printf "%-30s|", $obj->{$key};
            print "\n";
        }
        print "--------------------------------------------------\n";
    }
}

sub save
{
    my $defaultFile = 'data';
    print "Enter DB name [$defaultFile]: ";
    my $fileName = <STDIN>;
    $fileName = trim($fileName);
    if(length $fileName == 0) {
        $fileName = $defaultFile;
    }
    $fileName = 'data/' . $fileName;
    
    if(-e $fileName . '.dir') {
        unlink($fileName . '.dir');
    }
    if(-e $fileName . '.pag') {
        unlink($fileName . '.pag');
    }

    my %hash;
    dbmopen(%hash, $fileName, 0666);
    
    my $template = '';
    foreach $key (keys %attributes) {
        $template .= 'u i ';
    }
    foreach $key (keys %objects)
    {
        my $code = 'pack("' . $template . '"';
        foreach $attr (sort keys %attributes) {
            my $c = '$objects{$key}->{' . $attr . '}, 1';
            $code .= ', ' . $c;
        }
        $code .= ');';
        
        my $packed;
        eval '$packed = ' . $code;
        
        $hash{$key} = $packed;
    }
    
    dbmclose(%hash);
    
    print "Saved.\n";
}

sub load
{
    my $defaultFile = 'data';
    print "Enter DB name [$defaultFile]: ";
    my $fileName = <STDIN>;
    $fileName = trim($fileName);
    if(length $fileName == 0) {
        $fileName = $defaultFile;
    }
    $fileName = 'data/' . $fileName;
    
    %objects = ();
    
    my %hash;
    dbmopen(%hash, $fileName, 0666);
    
    my $template = '';
    foreach $key (keys %attributes) {
        $template .= 'u i ';
    }
    my @attr_keys = sort keys %attributes;
    foreach $key (keys %hash) {
        my @d = unpack($template, $hash{$key});
        $objects{$key} = {};
        my $i = 0;
        foreach $k (keys @d) {
            if(($k % 2) != 0) {
                next;
            }
            $objects{$key}->{$attr_keys[$i]} = $d[$k];
            $i++;
        }
    }
    
    dbmclose(%hash);
    
    print "Loaded.\n";
}

sub get_ids
{
    my @ids;
    foreach $id (keys %objects) 
    {
        push @ids, $id;
    }
    @ids = sort {$a<=>$b} @ids;
    
    return @ids;
}

sub trim 
{
    my $s = shift; $s =~ s/^\s+|\s+$//g; 
    return $s;
}

sub exit
{
    close;
}
return 1;
