#!/usr/bin/perl -w
use strict;

use File::Basename;
use File::Spec;
use Getopt::Long;
use Benchmark;

my $num=0;
my $all_samples_index = "";
my $index_dir="";
my $kmer = 31;
my $qthresh = 10;
my $bc="yes";
my $pd = "no";
my $mem_height = 16;
my $mem_width=100;
my $vcftools_dir = "";
my $stampy_bin="";
my $stampy_hash="";
my $list_ref="";
my $refbindir="";

&GetOptions(
    ##mandatory args
    'index:s'                     =>\$all_samples_index,
    'list_ref:s'                  =>\$list_ref,
    'refbindir:s'                 =>\$refbindir,
    'index_dir:s'                 =>\$index_dir,
    'vcftools_dir:s'              =>\$vcftools_dir,
    'stampy_bin:s'                =>\$stampy_bin,
    'stampy_hash:s'               =>\$stampy_hash,
    'bc:s'                        =>\$bc,
    'pd:s'                        =>\$pd,
    'kmer:i'                      =>\$kmer,
    'mem_height:i'                =>\$mem_height,
    'mem_width:i'                 =>\$mem_width,
    'qthresh:i'                   =>\$qthresh,
    'num:i'                       =>\$num,
    );

my $num = shift;

if ($index_dir !~ /\/$/)
{
    $index_dir = $index_dir.'/';
}
my $index = $index_dir."index_".$num;
my $c1 = "head -n $num $all_samples_index  | tail -n 1 > $index";
qx{$c1};
open(F, $index)||die();
my $line= <F>;
chomp $line;
my @sp = split(/\t/, $line);
my $sample = $sp[0];
my $odir = "results/".$sample.'/';
my $c2 = "mkdir $odir";
qx{$c2};
my $log = $odir."log_bc.".$sample;
print "$log\n";
my $cmd ="perl $cortex_dir"."scripts/calling/run_calls.pl --fastaq_index $index --first_kmer $kmer --auto_cleaning yes --bc $bc --pd $pd --outdir $odir --ploidy 1 --genome_size 4400000 --mem_height $mem_height --mem_width $mem_width --qthresh $qthresh --vcftools_dir $vcftools_dir  --do_union yes --logfile $log --workflow independent --ref CoordinatesAndInCalling --list_ref_fasta $list_ref --refbindir $refbindir --stampy_bin $stampy_bin --stampy_hash $stampy_hash --outvcf $sample ";
qx{$cmd};
