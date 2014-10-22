package ST08;
use strict;
use warnings;
my @OPTIONS = 
(
  "Add",
  "Edit",
  "Delete",
  "Show All",
  "Save to file",
  "Load from file",
  "Exit",
);
  my @FOPTIONS=
  (
    \&add,
    \&edit,
    \&delete,
    \&showall,
    \&tofile,
    \&fromfile,
  );
 my @humans=();
sub menu
{
  my $i = 0;
  print "\n------------------------------\n";
  foreach my $s(@OPTIONS)
  {
    $i++;
    print "$i. $s\n";
  }
  print "------------------------------\n";
  my $ch = <STDIN>;
  return ($ch-1);
}

 sub add
 {
  print "Name = ";
  my $tmp1=<STDIN>; 
  print "Surname = ";
  my $tmp2=<STDIN>; 
  print "Age = ";
  my $tmp3=<STDIN>; 
  print "Fourth argument = ";
  my $tmp4=<STDIN>; 
  my $human={
  Name => $tmp1,
  SurName => $tmp2,
  Age => $tmp3,
  Sth => $tmp4,
  };
  push(@humans,$human);
  return 1;
  
 }
 sub edit
 {
  showall();
  print "Whom to change?\n";
  my $id=<STDIN>;
  print "Name = ";
  my $tmp1=<STDIN>; 
  print "Surname = ";
  my $tmp2=<STDIN>; 
  print "Age = ";
  my $tmp3=<STDIN>; 
  print "Fourth argument = ";
  my $tmp4=<STDIN>; 
  my $human={
  Name => $tmp1,
  SurName => $tmp2,
  Age => $tmp3,
  Sth => $tmp4,
  };
  $humans[$id]=$human;
  return 1;
 }
 sub delete
 {
  showall();
  print "Whom to delete?\n";
  my $id=<STDIN>;
  splice( @humans, $id, 1);
  return 1;
 }
 sub showall
 {
  my $j=0;
  foreach my $i(@humans)
  {
    print "\n===================$j================\n$i->{Name}$i->{SurName}$i->{Age}$i->{Sth}";
    $j++;
  }
  return 1;
 }
 sub tofile
 {
  my %filehash=();
  dbmopen(%filehash, "file", 0644);
  my $id=0;
  foreach my $i(@humans)
  { 
    $filehash{$id}=$i->{Name}.$i->{SurName}.$i->{Age}.$i->{Sth};
    $id++;
  }
  dbmclose(%filehash);
  return 1;
 }
 sub fromfile
 {
  my %filehash;
  dbmopen(%filehash, "file", 0644);
  @humans=();
  my $id=0;
  foreach my $i(values %filehash)
  {
    my @tmp = split /\n/, $i;
    my $human={
    Name => "$tmp[0]\n",
    SurName => "$tmp[1]\n",
    Age => "$tmp[2]\n",
    Sth => "$tmp[3]\n",
    };
    $humans[$id]=$human;
    $id++;
  }
  
  dbmclose(%filehash);
  return 1;

 }
 
 
sub st08
{
 
while(1)
{
  my $ch = menu();
  if(defined $FOPTIONS[$ch])
  { 
    $FOPTIONS[$ch]->();   
  }
  else
  {
    return;
  }
}

}

return 1;