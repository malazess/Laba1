package ObjectManager;

my %objects;

my %attributes = (
    'name' => 'First Name',
    'lastname' => 'Last Name',
    'age' => 'Age'
);

sub fill
{
    $objects{0} = {'name' => 'Ilya', 'lastname' => 'Pastukhov', 'age' => 22};
    $objects{1} = {'name' => 'Petr', 'lastname' => 'Kuklianov', 'age' => 25};
    $objects{2} = {'name' => 'Den', 'lastname' => 'Davidoff', 'age' => 25};
}

sub add
{
    my @ids = get_ids();
    my $id = 0;
    
    if(length @ids != 0)
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
    #my $defaultFile = 'objects';
    #print "Enter DB name [$defaultFile]: ";
    #my $fileName = <STDIN>;
    #$fileName = trim($fileName);
    #if(length $fileName == 0) {
    #    $fileName = $defaultFile;
    #}
    
    # Запись в файл
    use Fcntl;
    use NDBM_File;

    my %hash;
    tie %hash, "NDBM_File", 'data',  
                   O_RDWR|O_CREAT|O_EXCL, 0644;
    foreach $key (keys %objects)
    {
        $hash{$key} = $objects{$key};
        print $hash{$key}->{name};
    }
    
    untie %hash;
    
    print "Saved.\n";
}

sub load
{
    #my $defaultFile = 'objects';
    #print "Enter DB name [$defaultFile]: ";
    #my $fileName = <STDIN>;
    #$fileName = trim($fileName);
    #if(length $fileName == 0) {
    #    $fileName = $defaultFile;
    #}
    
    # Чтение из файла
    use Fcntl;
    use NDBM_File;
    use Data::Dumper;

    my %hash;
    tie %hash, "NDBM_File", 'data',  
                   O_RDWR|O_CREAT|O_EXCL, 0644;
    
    foreach $key (keys %hash) {
        print $hash{$key}; # ссылка на хеш
    }
    %objects = %hash;
    
    untie %hash;
    
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

return 1;
