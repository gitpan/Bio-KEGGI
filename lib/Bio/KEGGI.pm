package Bio::KEGGI;

=head1 NAME

    Bio::KEGGI - Perl module to parse KEGG genome, ko and pathway files.
    
=head1 VERSION

    Version 0.0.2

=head1 SYNOPSIS

    use Bio::KEGGI;
    
    my $keggi = Bio::KEGGI->new(
        -file => 'keggfilename',
        -type => 'filetype',
    );
    
    while (my $kegg = $keggi->next_rec) {
        print $kegg->id, "\n";
    }
    
    # Now supported KEGG file type are "genome", "ko" and "pathway".
    
=head1 DESCRIPTION

    Bio::KEGGI is used to parse KEGG files:
    
    genome:  ftp://ftp.genome.jp/pub/kegg/genes/genome
    ko:      ftp://ftp.genome.jp/pub/kegg/genes/ko
    pathway: ftp://ftp.genome.jp/pub/kegg/pathway/pathway
    
    KEGG data details could be retrieved by module Bio::KEGG.

=head1 AUTHOR

    Haizhou Liu, zeroliu-at-gmail-dot-com
    
=head1 BUGS

    This module works for Unix text file format only, which ends with a "\n".
    
    Please use other softwares, such as dos2unix to convert input file if
    necessary.
    
=head1 METHODS

=head2 new
    Name:   new
    Desc:   A constructor for a KEGGI object.
    Usage:  Bio::KEGGI->new(
                -file => $file,
		        -type => $type, # A fake parameter
            );
    Args:   $file: A KEGG file: genome, ko, pathway
            $type: 'genome' | 'ko' | 'pathway' 
    Return: A Bio::KEGGI object
    
=cut

use strict;
use warnings;

# use Smart::Comments;

use Switch;
use Text::Trim;

use Bio::KEGG;

our $VERSION = "v0.0.2";

=head2 new
    Name:   new
    Desc:   A constructor for a KEGGI object.
    Usage:  Bio::KEGGI->new(
                -file => $file,
		        -type => $type, # A fake parameter
            );
    Args:   $file: A KEGG file: genome, ko, pathway
            $type: 'genome' | 'ko' | 'pathway' 
    Return: A Bio::KEGGI object
=cut

sub new {
    my ($class, %args) = @_;
    
    my $self = {};
    
    my $infile = $args{'-file'};
    my $type = $args{'-type'};
    
    # Open file
    eval {
        open(INF, $infile);
    };
    if ($@) {
        warn "FATAL: Open KEGG file '$infile'}' failed!\n$!\n";
        exit 1;
    }
    
    $self->{'_FH'} = *INF;
    
    my $type_module = $class . '::' . $type;
    
    eval "require $type_module";
    
#    bless($self, $class.'::'.$type);
    bless($self, $type_module);
    
    return $self;
}

# Private method
#    Name:     DESTROY
#    Desc:     Destructor

sub DESTROY {
    my $self = shift;
    
    my $fh = $self->{'_FH'};
    
    close $fh;
}


1;