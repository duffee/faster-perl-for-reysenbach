# Adding Go-faster stripes to old Perl scripts 
Tracks the progress of making old Perl scripts faster and more maintainable.
Working from Meneghin's
[perl-for-reysenbach-lab](https://github.com/jmeneghin/perl-for-reysenbach-lab)
repository of bioinformatics scripts.

## Guiding principles

This is a refactoring, so the output of the script should not change.

Make the scripts easier to maintain and follow
[Best Practices](https://en.wikipedia.org/wiki/Perl_Best_Practices)
where possible. E.g. use `my` to localize variables.

Make them faster by cutting down unnecessary loops and computation. 

Take advantage of newer features of [Modern Perl](http://modernperlbooks.com/)
(e.g. `say` instead of `print "\n"`)
Try to make the code shorter while maintaining readability.

## General Process

1. Translate the code into my personal style, adding basic Best Practice
and changing the code as little as possible.
This helps me understand what the code is doing.

2. Verify the output is the same

3. Use [NYTProf](https://www.perl.org/about/whitepapers/perl-profiling.html)
to identify the longest running subs/statements (highlighted in red),
copy script into new file and optimize _one_ thing

4. Benchmark with [hyperfine](https://github.com/sharkdp/hyperfine)

5. Verify the output and repeat from 3. until all reasonable optimizations made

## References

* [Perl performance and optimization techniques](https://perldoc.perl.org/perlperf)
