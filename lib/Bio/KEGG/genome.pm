=head1 NAME

    Bio::KEGG::genome - Perl module to fetch details of KEGG file 'genome'.

=head1 DESCRIPTION

    Fetch data from a Bio::KEGGI::genome object

=head1 METHODS

=head2 anno

    Name:   anno
    Desc:   Get KEGG entry ANNOTATION information.
    Usage:  $anno = $o_kegg->anno()
    Args:
    Return: A string
    
=head2 taxid
    
    Name:   taxid
    Desc:   Get KEGG entry taxonomy id.
    Usage:  $taxid = $o_kegg->taxid()
    Args:
    Return: A string    

=head2 taxonomy

    Name:   taxonomy
    Desc:   Get KEGG entry taxonomy information.
    usage:  $taxonomy = $o_kegg->taxonomy
    Args:
    Return: A string
    
=head2 data_src

    Name:   data_src
    Desc:   Get KEGG entry DATA_SOURCE information
    Usage:  $data_src = $o_kegg->data_src()
    Args:
    Return: A string

=head2 comment

    Name:   comment
    Desc:   Get KEGG entry COMMENT.
    usage:  $comment = $o_kegg->comment()
    Args:
    Return: A string
    
=head2 origin_db

    Name:   origin_db
    Desc:   Get KEGG entry ORIGINAL_DB.
    usage:  $origin_db = $o_kegg->original_db()
    Args:
    Return: A string
    
=head2 component

    Name:   component
    Desc:   Get KEGG entry CHROMOSOME and PLASMID information.
    
    $rh_component = [
        {
            'category'    => $category, # 'chromosome' or 'plasmid'
            'is_circular' => $is_cir,  # 0 or 1
            'name'        => $name,
            'refseq'      => $refseq_id,
            'length'      => $length
        },
        ...
    ]
    
    Usage:  Bio::KEGG::genome->component()
    Args:
    Return: A reference to an array    

=head2 statistics

    Name:   statistics
    Disc:   Get KEGG entry STATISTICS information.
            
            $rh_statistics = {
                'nt'  => $nt,  # Number of nucleotides
                'prn' => $prn, # Number of protein genes
                'rna' => $rna, # Number of RNA genes 
            }
    
    Usage:  $o_kegg->statistics()
    Args:
    Return: A reference to a hash.
    
=cut

package Bio::KEGG::genome;

use strict;
use warnings;

use base qw(Bio::KEGG);

# use Smart::Comments;

our $VERSION = "v0.0.2";

=head2 anno
    Name:   anno
    Desc:   Get KEGG entry ANNOTATION information.
    Usage:  $anno = $o_kegg->anno()
    Args:
    Return: A string
=cut

sub anno {
    my $self = shift;
    
    return $self->{'annotation'};
}

=head2 taxid
    Name:   taxid
    Desc:   Get KEGG entry taxonomy id.
    Usage:  $taxid = $o_kegg->taxid()
    Args:
    Return: A string
=cut

sub taxid {
    my $self = shift;
    
    return $self->{'taxid'};
}

=head2 taxonomy
    Name:   taxonomy
    Desc:   Get KEGG entry taxonomy information.
    usage:  $taxonomy = $o_kegg->taxonomy
    Args:
    Return: A string
=cut

sub taxonomy {
    my $self = shift;
    
    return $self->{'tax_lineage'};
}

=head2 data_src
    Name:   data_src
    Desc:   Get KEGG entry DATA_SOURCE information
    Usage:  $data_src = $o_kegg->data_src()
    Args:
    Return: A string
=cut

sub data_src {
    my $self = shift;
    
    return $self->{'data_src'};
}

=head2 comment
    Name:   comment
    Desc:   Get KEGG entry COMMENT.
    usage:  $comment = $o_kegg->comment()
    Args:
    Return: A string
=cut

sub comment {
    my $self = shift;
    
    return $self->{'comment'};
}

=head2 origin_db
    Name:   origin_db
    Desc:   Get KEGG entry ORIGINAL_DB.
    usage:  $origin_db = $o_kegg->original_db()
    Args:
    Return: A string
=cut

sub origin_db {
    my $self = shift;
    
    return $self->{'origin_db'};
}

=head2 component
    Name:   component
    Desc:   Get KEGG entry CHROMOSOME and PLASMID information.
    ------------------------------------------------------------------
    $rh_component = [
        {
            'category'    => $category, # 'chromosome' or 'plasmid'
            'is_circular' => $is_cir,  # 0 or 1
            'name'        => $name,
            'refseq'      => $refseq_id,
            'length'      => $length
        },
        ...
    ]
    ------------------------------------------------------------------
    
    Usage:  Bio::KEGG::genome->component()
    Args:
    Return: A reference to an array
=cut

sub component {
    my $self = shift;
    
    return $self->{'component'};
}

=head2 statistics
    Name:   statistics
    Disc:   Get KEGG entry STATISTICS information.
    ------------------------------------------------------------------
            $rh_statistics = {
                'nt'  => $nt,  # Number of nucleotides
                'prn' => $prn, # Number of protein genes
                'rna' => $rna, # Number of RNA genes 
            }
    ------------------------------------------------------------------
    Usage:  $o_kegg->statistics()
    Args:
    Return: A reference to a hash.
=cut

sub statistics {
    my $self = shift;

    my $rh_stat = {
        'nt'  => $self->{'nt'},
        'prn' => $self->{'prn'},
        'rna' => $self->{'rna'},
    };
    
    return $rh_stat;
}

1;
