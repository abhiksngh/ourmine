#!/usr/bin/gawk -f

BEGIN {	
  FS      = "," ;
  SUBSEP  = "=";
  Goal	  = "^recurrence-events$"; 
  Beam    = 20;
  OFMT    = "%.8g";
  srand(Seed ? Seed : 1);
}
NR == 1{ header(); next }
       { data()         }
END    { report()       }

# one-liners for br
function header(  i)  { for(i=1;i<=NF;i++) Name[i] = $i }
function data()       { if ($NF ~ Goal) {Best++; data1(B)} else {Rest++; data1(R)}}
function data1(a,  i) { for(i=1;i<NF;i++) a[Name[i],$i]++}
function report(  top){ br(top);  o(top," ","-n -k 1", "%3.0f") }

# library one-liners
function jiggle(n)    { return 100*n + rand() }
function round(n)     { return int(n+0.5)     }
function def(x, y)    { return x ? x : y      }

function  br(out,      range,sorted,n,stop,max,min,sum,b,r,i,j,value,memo,val) {
  	for( range in B) {
    b = B[range]/Best;
    r = R[range]/Rest;
    #print b "," r;
    if (b > r) { 
      j = jiggle(b^2/(b+r));
      value[range] = j;
      memo[j] = range;
    }}
  n = asort(value,sorted);
  max = sorted[n];
  stop = n < Beam ? 1 : n - Beam + 1;
  for(i=n; i >= stop; i--)
    if (sorted[i] > 0) 
      min = out[memo[sorted[i]]] = round(100*sorted[i]/max);
  return min;
}
function o(a,    str,order,show,  i,com) {   
  str   = def(str,  "a");
  order = def(order,"-n -k 1");
  show  = def(show, "%10.3f");
  com   = "sort " order " #" rand();
  for(i in a) 
    printf(show ": %s[ %s ]\n", a[i], str, i) | com;
  close(com);
}
