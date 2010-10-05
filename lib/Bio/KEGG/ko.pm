=head1 NAME

    Bio::KEGG::ko- Perl module to fetch details of KEGG file 'ko'.

=head1 DESCRIPTION

    Fetch data from a Bio::KEGGI::ko object

=head1 METHODS

=head2 ec

    Name:   ec
    Disc:   Get KEGG entry ECs
    
        $ra_ecs = [ ec, ... ];
        
    Usage:  $o_kegg->ec()
    Args:
    Return: A reference to an array.
    
=head2 pathway

    Name:   pathway
    Disc:   Get KEGG entry PATHWAY ids
            
            $ra_pathways = [ pathway_id, ... ];
    
    Usage:  $o_kegg->pathway()
    Args:
    Return: A reference to an array.
    
=head2 gene
    Name:   gene
    Disc:   Get KEGG ko entry GENES information
        
        $rh_gene = [
            {
                'org'      => $org,
                'org_gene' => [
                    {
                        'entry' => $entry,
                        'name'  => $name,
                    },
                    ...
                ],
                ...
            };
            ...,
        ];
    
    Usage:  $o_kegg->gene()
    Args:
    Return: A reference to an array.    

=cut

package Bio::KEGG::ko;

use strict;
use warnings;

use base qw(Bio::KEGG);

# use Smart::Comments;

our $VERSION = 'v0.0.2';

=head2 ec
    Name:   ec
    Disc:   Get KEGG entry ECs
    ------------------------------------------------------------------
        $ra_ecs = [ ec, ... ];
    ------------------------------------------------------------------
    Usage:  $o_kegg->ec()
    Args:
    Return: A reference to an array.
=cut

sub ec {
    my $self = shift;
    
    return $self->{'ec'};
}

=head2 pathway
    Name:   pathway
    Disc:   Get KEGG entry PATHWAY ids
    ------------------------------------------------------------------
            $ra_pathways = [ pathway_id, ... ];
    ------------------------------------------------------------------
    Usage:  $o_kegg->pathway()
    Args:
    Return: A reference to an array.
=cut

sub pathway {
    my $self = shift;
    
    return $self->{'pathway'};
}

=head2 gene
    Name:   gene
    Disc:   Get KEGG ko entry GENES information
    ------------------------------------------------------------------
        $rh_gene = [
            {
                'org'      => $org,
                'org_gene' => [
                    {
                        'entry' => $entry,
                        'name'  => $name,
                    },
                    ...
                ],
                ...
            };
            ...,
        ];
    ------------------------------------------------------------------
    Usage:  $o_kegg->gene()
    Args:
    Return: A reference to an array.
=cut

sub gene {
    my $self = shift;
    
    return $self->{'gene'};
}

1;
