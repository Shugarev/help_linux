# https://learnbyexample.github.io/learn_perl_oneliners/one-liner-introduction.html
# ----------------------Filtering ------------------------

# same as: grep 'at' and sed -n '/at/p' and awk '/at/'
printf 'gate\napple\nwhat\nkite\n' | perl -ne 'print if /at/'

# print all lines NOT containing 'e'
# same as: grep -v 'e' and sed -n '/e/!p' and awk '!/e/'
printf 'gate\napple\nwhat\nkite\n' | perl -ne 'print if !/e/'

#    /REGEXP/FLAGS is a shortcut for $_ =~ m/REGEXP/FLAGS
#   !/REGEXP/FLAGS is a shortcut for $_ !~ m/REGEXP/FLAGS

text='brown bread mat hair 42\nblue cake mug shirt -7\nyellow banana window shoes 3.14'
echo -e $text | perl -nE 'print $& if /(?<!-)\d+$/; print();'
# 42

# 14
echo -e $text | perl -nE 'print /(\d+)$/ ; print("\n");'
# 42
# 7
# 14

#  ------------------------Substitution ------------------------
# for each input line, change only first ':' to '-'
# same as: sed 's/:/-/' and awk '{sub(/:/, "-")} 1'
printf '1:2:3:4\na:b:c:d\n' | perl -pe 's/:/-/'
# 1-2:3:4
# a-b:c:d

$ # for each input line, change all ':' to '-'
$ # same as: sed 's/:/-/g' and awk '{gsub(/:/, "-")} 1'
printf '1:2:3:4\na:b:c:d\n' | perl -pe 's/:/-/g'
# 1-2-3-4
# a-b-c-d

#  ------------------------Field processing------------------------
# print the second field of each input line
# same as: awk '{print $2}' 
echo -e $text | perl -lane 'print $F[1]' 
# bread
# cake
# banana

# print lines only if the last field is a negative number
# same as: awk '$NF<0' 
echo -e $text | perl -lane 'print  if $F[-1] < 0' 

# change 'b' to 'B' only for the first field
# same as: awk '{gsub(/b/, "B", $1)} 1' table.txt
echo -e $text | perl -lane '$F[0] =~ s/b/B/g; print "@F"' 
# Brown bread mat hair 42
# Blue cake mug shirt -7
# yellow banana window shoes 3.14

#  ------------------------BEGIN and END------------------------
# same as: awk 'BEGIN{print "---"} 1; END{print "%%%"}'
seq 4 | perl -pE 'BEGIN{print "---"} END{print "%%%"}'
# same as: awk 'BEGIN{print "---"} 1; END{print "%%%"}'
seq 4 | perl -pE 'BEGIN{print "---"} END{print "%%%"}'
# ---
# 1
# 2
# 3
# 4

perl -E 'say $ENV{HOME}'