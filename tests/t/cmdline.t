########################################################################
# Command line syntax tests
########################################################################

  $ sysbench foo bar
  sysbench * (glob)
  
  Cannot find script foo: No such file or directory
  [1]

  $ sysbench foo bar baz
  Unrecognized command line argument: baz
  [1]

  $ sysbench --unknown <<EOF
  > EOF
  sysbench * (glob)
  

  $ sysbench fileio
  sysbench * (glob)
  
  The 'fileio' test requires a command argument. See 'sysbench fileio help'
  [1]

  $ sysbench --help foo | grep Usage:
  Usage:

  $ sysbench <<EOF
  > print('test')
  > EOF
  sysbench * (glob)
  
  test

  $ sysbench run <<EOF
  > print('script body')
  > function event()
  >   print('event function')
  > end
  > EOF
  sysbench * (glob)
  
  Cannot find script run: No such file or directory
  [1]

  $ cat >$CRAMTMP/cmdline.lua <<EOF
  > #!/usr/bin/env sysbench
  > print('script body')
  > function event()
  >   print('event function')
  > end
  > EOF
  $ sysbench --max-requests=1 $CRAMTMP/cmdline.lua
  sysbench * (glob)
  
  script body

  $ sysbench --max-requests=1 $CRAMTMP/cmdline.lua run
  sysbench * (glob)
  
  script body
  Running the test with following options:
  Number of threads: 1
  Initializing random number generator from current time
  
  
  Initializing worker threads...
  
  script body
  Threads started!
  
  event function
  
  General statistics:
      total time: *s (glob)
      total number of events:              1
      total time taken by event execution: *s (glob)
  
  Latency statistics:
           min: *ms (glob)
           avg: *ms (glob)
           max: *ms (glob)
           approx.  95th percentile: *ms (glob)
  
  Threads fairness:
      events (avg/stddev):           1.0000/0.00
      execution time (avg/stddev):   0.0000/0.00
  
########################################################################
Command line options tests
########################################################################

  $ cat >cmdline.lua <<EOF
  > sysbench.option_defs = {
  >   str_opt1 = {"str_opt1 description"},
  >   str_opt2 = {"str_opt2 description", "opt2"},
  >   str_opt3 = {"str_opt3 description", "opt3", sysbench.cmdline.ARG_STRING},
  >   bool_opt1 = {"bool_opt1 description", false},
  >   bool_opt2 = {"bool_opt2 description", true},
  >   bool_opt3 = {"bool_opt3 description", nil, sysbench.cmdline.ARG_BOOL},
  >   int_opt1 = {"int_opt1 description", 10},
  >   int_opt2 = {"int_opt2 description", nil, sysbench.cmdline.ARG_INT},
  >   int_opt3 = {"int_opt3 description", 20, sysbench.cmdline.ARG_INT},
  >   float_opt1 = {"float_opt1 description", 3.14, sysbench.cmdline.ARG_DOUBLE},
  >   float_opt2 = {"float_opt2 description", 0.2},
  >   list_opt1 = {"list_opt1 description", {"foo", "bar"}},
  >   list_opt2 = {"list_opt2 description", nil, sysbench.cmdline.ARG_LIST},
  >   ["dash-opt"] = {"dash-opt desc", "dash-opt val"}
  > }
  > 
  > function help()
  >   local o = sysbench.opt
  >    print(o.str_opt1)
  >    print(o.str_opt2)
  >    print(o.str_opt3)
  >    print(o.bool_opt1)
  >    print(o.bool_opt2)
  >    print(o.bool_opt3)
  >    print(o.int_opt1)
  >    print(o.int_opt2)
  >    print(o.float_opt1)
  >    print(o.float_opt2)
  >    print(o.list_opt1)
  >    print(o.list_opt2)
  >    print(o.dash_opt)
  > end
  > EOF

  $ sysbench cmdline.lua
  sysbench * (glob)
  
  $ sysbench cmdline.lua help
  sysbench * (glob)
  
  cmdline.lua options:
    --dash-opt=STRING      dash-opt desc [dash-opt val]
    --str_opt1=STRING      str_opt1 description
    --bool_opt3[=on|off]   bool_opt3 description
    --int_opt2=N           int_opt2 description
    --list_opt2=[LIST,...] list_opt2 description
    --float_opt2=N         float_opt2 description [0.2]
    --str_opt2=STRING      str_opt2 description [opt2]
    --list_opt1=[LIST,...] list_opt1 description [foo,bar]
    --str_opt3=STRING      str_opt3 description [opt3]
    --int_opt3=N           int_opt3 description [20]
    --bool_opt1[=on|off]   bool_opt1 description [off]
    --float_opt1=N         float_opt1 description [3.14]
    --bool_opt2[=on|off]   bool_opt2 description [on]
    --int_opt1=N           int_opt1 description [10]
  
  
  opt2
  opt3
  false
  true
  true
  10
  0
  3.14
  0.2
  table: 0x* (glob)
  table: 0x* (glob)
  dash-opt val

  $ sysbench cmdline.lua prepare
  sysbench * (glob)
  
  'cmdline.lua' test does not have the 'prepare' command.
  [1]

  $ sysbench --non-existing-option=3 cmdline.lua prepare
  sysbench * (glob)
  
  invalid option: --non-existing-option=3
  [1]

  $ sysbench cmdline.lua run
  sysbench * (glob)
  
  FATAL: cannot find the event() function in cmdline.lua
  [1]

  $ sysbench cmdline.lua cleanup
  sysbench * (glob)
  
  'cmdline.lua' test does not have the 'cleanup' command.
  [1]

  $ cat >cmdline.lua <<EOF
  > sysbench.option_defs = {
  >   {}, 
  > }
  > 
  > function help()
  > end
  > EOF
  $ sysbench cmdline.lua help
  sysbench * (glob)
  
  FATAL: `sysbench.cmdline.read_option_defs' function failed: [string "sysbench.cmdline.lua"]:95: wrong table structure in sysbench.option_defs
  Script execution failed (no-eol)
  [1]

  $ sysbench fileio --invalid-option prepare
  sysbench * (glob)
  
  invalid option: --invalid-option
  [1]
