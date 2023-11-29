use Test2::V0;

my $standard = 'get_kmer_frequencies1.pl';
my @files = sort { -M $a <=> -M $b } glob 'get_kmer*';
ok my $latest = shift @files;
isnt $latest, $standard, 'Files to compare';

my @args = qw'Covid-19.fasta 3';
ok system('perl', $standard, @args, 'A') == 0, 'Make A_kmers.txt';
ok system('perl', $latest, @args, 'B') == 0, 'Make B_kmers.txt';

is `diff A_kmers.txt B_kmers.txt`, q{}, 'No differences in output';

done_testing();
