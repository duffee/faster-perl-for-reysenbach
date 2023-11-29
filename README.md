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

## General Process

1. Translate the code into my personal style, adding Best Practice and changing the code as little as possible.
This helps me understand what the code is doing.

2. Verify the output is the same

3. Use NYTProf to identify the longest running loop, copy script into new file and optimize.

4. Measure the time difference with hyperfine

5. Verify the output and repeat from 3. until all reasonable optimizations made
