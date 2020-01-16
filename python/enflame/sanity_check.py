#!/usr/bin/env python
"""Sanity Check script before running DTU Profiler"""

from __future__ import print_function
import os

def sirius_env_check():
    """check sirius environment var is set correctly"""
    res = True
    enable_init_on_cpu = os.environ['ENABLE_INIT_ON_CPU']
    if enable_init_on_cpu != '1':
        print("ENABLE_INIT_ON_CPU is not set correctly")
        res = False
    xla_flags = os.environ['XLA_FLAGS']
    if "--xla_backend_extra_options='xla_no_new_fusion'" not in xla_flags:
        print("XLA_FLAGS is not set correctly")
        res = False
    tf_xla_flags = os.environ['TF_XLA_FLAGS']
    if '--tf_xla_auto_jit=-1 --tf_xla_min_cluster_size=4' not in tf_xla_flags:
        print("TF_XLA_FLAGS is not set correctly")
        res = False
    dtu_umd_flags = os.environ['DTU_UMD_FLAGS']
    if 'ib_wb_in_host=false odma_force=2 ib_pool_size=83886080' not in dtu_umd_flags:
        print("DTU_UMD_FLAGS is not set correctly")
        res = False
    enable_sdk_count_event = os.environ['ENABLE_SDK_COUNT_EVENT']
    if enable_sdk_count_event != 'false':
        print("ENABLE_SDK_COUNT_EVENT is not set correctly")
        res = False
    enable_sdk_stream_cache = os.environ['ENABLE_SDK_STREAM_CACHE']
    if enable_sdk_stream_cache != 'false':
        print("ENABLE_SDK_STREAM_CACHE is not set correctly")
        res = False
    dtu_opt_mode = os.environ['DTU_OPT_MODE']
    if dtu_opt_mode != 'false':
        print("DTU_OPT_MODE is not set correctly")
        res = False
    disablepass = os.environ['DisablePass']
    if 'ClearRedundantEdgePass' not in disablepass:
        print("DisablePass is not set correctly")
        res = False
    merge_mem_earlier = os.environ['MERGE_MEM_EARLIER']
    if merge_mem_earlier != 'true':
        print("MERGE_MEM_EARLIER is not set correctly")
        res = False
    reduce_hbm_use_peak = os.environ['REDUCE_HBM_USE_PEAK']
    if reduce_hbm_use_peak != 'true':
        print("REDUCE_HBM_USE_PEAK is not set correctly")
        res = False
    return res


def prof_env_check():
    """check profiler environment var is set correctly"""
    dtu_profiler_flags = os.environ['DTU_PROFILER_FLAGS']
    if '--do_dtu_profile=1' not in dtu_profiler_flags:
        return False
    return True


def driver_flag_check():
    """check the flags required by profiler"""
    f_ip_ts_enable = '/sys/module/dtu/parameters/ip_ts_enable'
    f_trace_enable = '/sys/module/dtu/parameters/trace_enable'
    f_cqm_debug_enable = '/sys/module/dtu/parameters/cqm_debug_enable'
    f1 = open(f_ip_ts_enable, 'r')
    f2 = open(f_trace_enable, 'r')
    f3 = open(f_cqm_debug_enable, 'r')
    ip_ts_enable = f1.read(1)
    trace_enable = f2.read(1)
    cqm_debug_enable = f3.read(1)
    if ip_ts_enable != '1':
        print("ip_ts_enable is not set")
    if trace_enable != '1':
        print("trace_enable is not set")
    if cqm_debug_enable != '1':
        print("cqm_debug_enable is not set")
    if ip_ts_enable != '1' or trace_enable != '1' or cqm_debug_enable != '1':
        return False
    else:
        return True


def sanity_check():
    res = True
    if driver_flag_check() != True:
        print('Driver is not loaded with correct parameter. ', end='')
        res = False
    if sirius_env_check() != True:
        print('Environment variable is not set correctly for sirius. ', end='')
        res = False
    if prof_env_check() != True:
        print('Environment variable is not set correctly for profiler. ', end='')
        res = False
    return res


try:
    if sanity_check() != True:
        print("Sanity Check failed!")
    else:
        print("Sanity Check passed, please go ahead!")

except IOError, e:
    print('file open error', e, '\ndevice not found. driver not loaded??')
except KeyError, e:
    print('environment varialble get error', e, '\nsome env var is not set??')
