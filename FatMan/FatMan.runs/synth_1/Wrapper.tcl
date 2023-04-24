# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
namespace eval ::optrace {
  variable script "C:/Users/johnj/dev/ece350/FatMan/FatMan.runs/synth_1/Wrapper.tcl"
  variable category "vivado_synth"
}

# Try to connect to running dispatch if we haven't done so already.
# This code assumes that the Tcl interpreter is not using threads,
# since the ::dispatch::connected variable isn't mutex protected.
if {![info exists ::dispatch::connected]} {
  namespace eval ::dispatch {
    variable connected false
    if {[llength [array get env XILINX_CD_CONNECT_ID]] > 0} {
      set result "true"
      if {[catch {
        if {[lsearch -exact [package names] DispatchTcl] < 0} {
          set result [load librdi_cd_clienttcl[info sharedlibextension]] 
        }
        if {$result eq "false"} {
          puts "WARNING: Could not load dispatch client library"
        }
        set connect_id [ ::dispatch::init_client -mode EXISTING_SERVER ]
        if { $connect_id eq "" } {
          puts "WARNING: Could not initialize dispatch client"
        } else {
          puts "INFO: Dispatch client connection id - $connect_id"
          set connected true
        }
      } catch_res]} {
        puts "WARNING: failed to connect to dispatch server - $catch_res"
      }
    }
  }
}
if {$::dispatch::connected} {
  # Remove the dummy proc if it exists.
  if { [expr {[llength [info procs ::OPTRACE]] > 0}] } {
    rename ::OPTRACE ""
  }
  proc ::OPTRACE { task action {tags {} } } {
    ::vitis_log::op_trace "$task" $action -tags $tags -script $::optrace::script -category $::optrace::category
  }
  # dispatch is generic. We specifically want to attach logging.
  ::vitis_log::connect_client
} else {
  # Add dummy proc if it doesn't exist.
  if { [expr {[llength [info procs ::OPTRACE]] == 0}] } {
    proc ::OPTRACE {{arg1 \"\" } {arg2 \"\"} {arg3 \"\" } {arg4 \"\"} {arg5 \"\" } {arg6 \"\"}} {
        # Do nothing
    }
  }
}

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
OPTRACE "synth_1" START { ROLLUP_AUTO }
set_param chipscope.maxJobs 5
set_param xicom.use_bs_reader 1
set_msg_config -id {Common 17-41} -limit 10000000
OPTRACE "Creating in-memory project" START { }
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/johnj/dev/ece350/FatMan/FatMan.cache/wt [current_project]
set_property parent.project_path C:/Users/johnj/dev/ece350/FatMan/FatMan.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/johnj/dev/ece350/FatMan/FatMan.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
OPTRACE "Creating in-memory project" END { }
OPTRACE "Adding files" START { }
read_mem {
  {C:/Users/johnj/dev/ece350/processor/Test Files/Memory Files/sort.mem}
  {C:/Users/johnj/dev/ece350/processor/Test Files/Memory Files/rep_add.mem}
}
read_verilog -library xil_defaultlib {
  C:/Users/johnj/dev/ece350/processor/RAM.v
  C:/Users/johnj/dev/ece350/processor/ROM.v
  C:/Users/johnj/dev/ece350/processor/my_modules/alu/alu.v
  C:/Users/johnj/dev/ece350/processor/my_modules/bit_regfile.v
  C:/Users/johnj/dev/ece350/processor/my_modules/btn_debouncer.v
  C:/Users/johnj/dev/ece350/processor/my_modules/alu/cla/cla32bit.v
  C:/Users/johnj/dev/ece350/processor/my_modules/alu/cla/cla8bit.v
  C:/Users/johnj/dev/ece350/processor/my_modules/multdiv/counter/counter_mod32.v
  C:/Users/johnj/dev/ece350/processor/my_modules/regfile/decoder32.v
  {C:/Users/johnj/dev/ece350/processor/Provided Behavioral Components/dffe_ref.v}
  C:/Users/johnj/dev/ece350/processor/my_modules/alu/shifter/left_shift_1.v
  C:/Users/johnj/dev/ece350/processor/my_modules/alu/shifter/left_shift_16.v
  C:/Users/johnj/dev/ece350/processor/my_modules/alu/shifter/left_shift_2.v
  C:/Users/johnj/dev/ece350/processor/my_modules/alu/shifter/left_shift_32_barrel.v
  C:/Users/johnj/dev/ece350/processor/my_modules/alu/shifter/left_shift_4.v
  C:/Users/johnj/dev/ece350/processor/my_modules/alu/shifter/left_shift_8.v
  C:/Users/johnj/dev/ece350/processor/my_modules/linear_actuator_controller.v
  C:/Users/johnj/dev/ece350/processor/my_modules/multdiv/multdiv.v
  C:/Users/johnj/dev/ece350/processor/my_modules/alu/mux/mux_16.v
  C:/Users/johnj/dev/ece350/processor/my_modules/alu/mux/mux_2.v
  C:/Users/johnj/dev/ece350/processor/my_modules/alu/mux/mux_32.v
  C:/Users/johnj/dev/ece350/processor/my_modules/alu/mux/mux_4.v
  C:/Users/johnj/dev/ece350/processor/my_modules/alu/mux/mux_8.v
  C:/Users/johnj/dev/ece350/processor/my_modules/multdiv/negate_32.v
  C:/Users/johnj/dev/ece350/processor/my_modules/alu/not_32.v
  C:/Users/johnj/dev/ece350/processor/processor.v
  C:/Users/johnj/dev/ece350/processor/my_modules/pwm/pwm_generator.v
  C:/Users/johnj/dev/ece350/processor/my_modules/regfile/reg32.v
  C:/Users/johnj/dev/ece350/processor/my_modules/multdiv/reg65.v
  C:/Users/johnj/dev/ece350/processor/my_modules/regfile/regfile.v
  C:/Users/johnj/dev/ece350/processor/my_modules/multdiv/t_flip-flop/tff.v
  C:/Users/johnj/dev/ece350/processor/Wrapper.v
}
OPTRACE "Adding files" END { }
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/johnj/dev/ece350/processor/master.xdc
set_property used_in_implementation false [get_files C:/Users/johnj/dev/ece350/processor/master.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

OPTRACE "synth_design" START { }
synth_design -top Wrapper -part xc7a100tcsg324-1
OPTRACE "synth_design" END { }


OPTRACE "write_checkpoint" START { CHECKPOINT }
# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef Wrapper.dcp
OPTRACE "write_checkpoint" END { }
OPTRACE "synth reports" START { REPORT }
create_report "synth_1_synth_report_utilization_0" "report_utilization -file Wrapper_utilization_synth.rpt -pb Wrapper_utilization_synth.pb"
OPTRACE "synth reports" END { }
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
OPTRACE "synth_1" END { }
