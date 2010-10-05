=head1 NAME
    
    Bio::KEGGI::genome
    
=head1 DESCRIPTION

    Parse KEGG genome file (ftp://ftp.genome.jp/pub/kegg/genes/genome).
    
    Retruned data structure:
    
    ----------------------------------------------------------------------------

    $rh_rec = {
        'id'          => $id,
        'name'        => $name,
        'definit'     => $definition,
        'annotation'  => $annotation,
        'taxid'       => $taxid,
        'tax_lineage' => $tax_lineage,
        'data_src'    => $data_src,
        'origin_db'   => $origin_db,
        'disease'     => [ $disease_id, ... ],
        'comment'     => $comment,
        'component'   => [
            {
                'category'    => $category, # 'chromasome' or 'plasmid'
                'is_circular' => $is_cir,   # 0 or 1
                'name'        => $name,
                'refseq'      => $refseq_id,
                'length'      => $length,
            },
            ...
        ],
        'nt'          => $nt_number,
        'prn'         => $protein_number,
        'rna'         => $rna_number,
        'pmid'        => [ $pmid, ... ],
    }
    
    ----------------------------------------------------------------------------
    
=head1 AUTHOR

    zeroliu-at-gmail-dot-com
    
=cut

package Bio::KEGGI::genome;

use strict;
use warnings;

use Switch;
use Text::Trim;

use Bio::KEGG::genome;

# use Smart::Comments;

our $VERSION = "v0.0.2";

use base qw(Bio::KEGGI);

=head2 next_rec
    Name:   next_rec
    Desc:   Get next KEGG record
    Usage:  $o_keggi->next_rec()
    Args:   none
    Return: A KEGG object
=cut

sub next_rec {
    my $self = shift;
    
    my $ra_rec = _get_next_rec($self->{'_FH'});
    my $rh_rec = _parse_genome_rec($ra_rec);
    
#    eval "require 'Bio::KEGG::genome'";
    
    bless $rh_rec, "Bio::KEGG::genome" if (defined $rh_rec);
    
    return $rh_rec;
}


=begin _get_next_rec
    Name:   _get_next_rec
    Desc:   Read a record from KEGG file
    Usage:  _get_next_rec(FH)
    Args:   A filehandle of KEGG file
    Return: A ref of an array for a KEGG record
=end
=cut

sub _get_next_rec {
    my $ifh = shift;
    
    # Since a KEGG record ended with '///'
    local $/ = "\/\/\/\n";
    
    my $rec;
    
    if ($rec = <$ifh>) {
        my @rec = split(/\n/, $rec);
        
        return \@rec;
    }
    else { # To the end of file
        return;
    }
}

=begin _parse_genome_rec
    Name:   _parse_genome_rec
    Desc:   Parse KEGG genome record
    Usage:  _parse_genome_rec($ra_rec)
    Args:   A reference to an array of Bio::KEGGI::genome record
    Return: A reference to a hash of Bio::KEGG record
=cut

sub _parse_genome_rec {
    my $ra_rec = shift;
    
    my $rh_rec;
    my $cur_section;
    
    for my $row ( @{$ra_rec} ) {
        next if ( $row =~ /^\s*$/);
        next if ( $row =~ /\/\/\// );
        
        if ($row =~ /^ENTRY\s+(.+?)\s+/) {
            $rh_rec->{'id'} = $1;
            
            next if ( $rh_rec->{'id'} =~ /T3/); # Dismiss environmental samples
        }
        elsif ($row =~ /^NAME/ ) {
            if ($row =~ /^NAME\s+(\w+),/) {
                $rh_rec->{'name'} = $1;
            }
            elsif ($row =~ /^NAME\s+(\d+)/) {
                $rh_rec->{'name'} = $1;
            }
            else {  # Unrecognized NAME
                print '-'x50, "\n", "Unrecognized:\n", $row, "\n", '-'x50, "\n";
            }
        }
        elsif ($row =~ /^DEFINITION\s+(.+?)$/) {
            my $cur_section = 'DEFINTION';
            
            $rh_rec->{'definit'} = $1;
        }
        elsif ($row =~ /^ANNOTATION\s+(.+)/) {
            $rh_rec->{'annotation'} = $1;
        }
        elsif ($row =~ /^TAXONOMY\s{4}TAX:(\d+)/) {
            $rh_rec->{'taxid'} = $1;
        }
        elsif ($row =~ /^\s{2}LINEAGE\s+(.+?)$/) {
            $cur_section = 'TAX_LINE';
            
            $rh_rec->{'tax_lineage'} = $1;
        }
        elsif ($row =~ /^DATA_SOURCE\s+(.+)$/) {
            $rh_rec->{'data_src'} = $1;
        }
        elsif ($row =~ /^ORIGINAL_DB\s+(.+)$/) {
            $rh_rec->{'origin_db'} = $1;
        }
        elsif ($row =~ /^DISEASE\s{5}(\w+)\s/) {
            $cur_section = 'DISEASE';
            
            push @{ $rh_rec->{'disease'} }, $1;
        }
        elsif ($row =~ /^COMMENT\s+(.+?)$/) {
            $cur_section = 'COMMENT';
            
            $rh_rec->{'comment'} = $1;
        }
        elsif ($row =~ /^(CHROMOSOME|PLASMID)/) { # CHROMOSOME or PLASMID
            my $rh_cpt;
            
            $rh_cpt->{'category'} = 'chromosome' if ($1 eq 'CHROMOSOME');
            $rh_cpt->{'category'} = 'plasmid' if ($1 eq 'PLASMID');

            # Genome is circular?
            if ($row =~ /Circular/) {
                $rh_cpt->{'is_circular'} = 1;
            }
            elsif ($row =~ /linear /) {
                $rh_cpt->{'is_circular'} = 0;
            }
            else {
                # Do nothing
                ### Unrecognized row: $row
            }
            
            # Genome or plasmid name
            # 'CHROMOSOME  I' or 'PLASMID  lp28-1'
            if ($row =~ /^CHROMOSOME$/) {
                # Do nothing
            }
            elsif ($row =~ /^(?:CHROMOSOME|PLASMID)\s+(\S+)/) {
                my $str = $1;
                
                unless ($str =~ /Circular/) {
                    $rh_cpt->{'name'} = $str;
                }
            }
            # 'CHROMOSOME  I; Circular' or 'PLASMID  pGT5; Circular'
            elsif ($row =~ /^(?:CHROMOSOME|PLASMID)\s+(\S+?);/) {
                $rh_cpt->{'name'} = $1;
                
                # Remove the tailing ';'
                # $rh_cpt->{'name'} =~ s/;$//;
            }
            # 'CHROMOSOME  MT (mitochondrion); Circular' or
            # 'CHROMOSOME  CP (chloroplast); Circular'
            elsif ($row =~ /^CHROMOSOME\s+(MT|CP)\s/) {
                $rh_cpt->{'name'} = $1;
            }
            else { # Not matched line
                # DEBUG
                ### Unrecognized row: $row
            }

            push @{ $rh_rec->{'component'} }, $rh_cpt;
        }
        elsif ($row =~ /^\s{2}SEQUENCE\s+RS:(.+?)$/) {
            my $rh_cpt = pop( @{$rh_rec->{'component'}} );
            $rh_cpt->{'refseq'} = $1;
            push @{ $rh_rec->{'component'} }, $rh_cpt;
        }
        elsif ($row =~ /^\s{2}LENGTH\s+(\d+)$/) {
            my $rh_cpt = pop( @{$rh_rec->{'component'}} );
            $rh_cpt->{'length'} = $1;
            push @{ $rh_rec->{'component'} }, $rh_cpt;
        }
        elsif ($row =~ /Number of nucleotides:\s+(\d+)/) {
            $rh_rec->{'nt'} = $1;
        }
        elsif ($row =~ /Number of protein genes:\s+(\d+)/) {
            $rh_rec->{'prn'} = $1;
        }
        elsif ($row =~ /Number of RNA genes:\s+(\d+)/) {
            $rh_rec->{'rna'} = $1;
        }
        elsif ($row =~ /^REFERENCE/) {
            if ($row =~ /^REFERENCE\s+PMID:(\d+)/) {
                $cur_section = 'REFERENCE';
                push @{ $rh_rec->{'pmid'} }, $1;
            }
            elsif ($row =~ /^REFERENCE/) {
                # Do nothing
            }
            else {
                ### Unrecognized row: $row
            }
        }
        elsif ($row =~ /^\s{2}(?:AUTHORS|TITLE|JOURNAL)/) { # REFERENCE section
            # Do nothing
        }
        elsif ($row =~ /^\s{12}/) { # COntinuous text for existing section
            switch ($cur_section) {
                case 'DEFINTION' {
                    trim($row);
                    
                    $rh_rec->{'definit'} .= " $row";
                }
                case 'DISEASE' {
                    trim($row);
                    
                    if ($row =~ /^(\S\d+)\s/) {
                        push @{ $rh_rec->{'disease'} }, $1;
                    }
                    # 'DISEASE     H00330  Methicillin-resistant Staphylococcal aureus (MRSA)
                    #              infection'
                    else {
                        # Do nothing
                        
                        # my $rh_disease = pop @{ $rh_rec->{'disease'}};
                        # trim($row);
                        # $rh_disease .= $row;
                        # push @{ $rh_rec->{'disease'} }, $rh_disease;
                    }
                }
                case 'TAX_LINE' {
                    trim($row);
                    $rh_rec->{'tax_lineage'} .= " $row";
                }
                case 'REFERENCE' {
                    # Do nothing
                }
                else {
                    ### Unrecognized row: $row
                }
            }
        }
        else {    # Output unparsed row
            ### Unrecognized row: $row
        }
    }
    
    return $rh_rec;
}

1;