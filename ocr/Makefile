# This file is subject to the license agreement located in the file LICENSE
# and cannot be distributed without it. This notice cannot be
# removed or modified.

MAKE := make

OCR_ROOT=/ocr/lib/
OCR_TYPE=x86

LOTSADEFS=-DCACHE_LINE_SZB=64 -DGUID_PROVIDER_LOCID_SIZE=10 -DALLOW_EAGER_DB -DENABLE_LAZY_DB -DOCR_ASSERT -DOCR_DEBUG -DOCR_DEBUG_LVL=DEBUG_LVL_WARN -DOCR_DEBUG_API -DOCR_DEBUG_ALLOCATOR -DOCR_DEBUG_COMP_PLATFORM -DOCR_DEBUG_COMM_PLATFORM -DOCR_DEBUG_COMM_API -DOCR_DEBUG_COMM_WORKER -DOCR_DEBUG_COMP_TARGET -DOCR_DEBUG_DATABLOCK -DOCR_DEBUG_EVENT -DOCR_DEBUG_GUID -DOCR_DEBUG_INIPARSING -DOCR_DEBUG_MACHINE -DOCR_DEBUG_MEM_PLATFORM -DOCR_DEBUG_MEM_TARGET -DOCR_DEBUG_POLICY -DOCR_DEBUG_MICROTASKS  -DOCR_DEBUG_SAL -DOCR_DEBUG_SCHEDULER -DOCR_DEBUG_SCHEDULER_HEURISTIC -DOCR_DEBUG_SCHEDULER_OBJECT -DOCR_DEBUG_STATS -DOCR_DEBUG_SYNC -DOCR_DEBUG_SYSBOOT -DOCR_DEBUG_TASK -DOCR_DEBUG_UTIL -DDEBUG_LVL_UTIL=DEBUG_LVL_WARN -DOCR_DEBUG_WORKER -DOCR_DEBUG_WORKPILE -DOCR_TRACE_API -DOCR_TRACE_ALLOCATOR -DOCR_TRACE_COMP_PLATFORM -DOCR_TRACE_COMM_PLATFORM -DOCR_TRACE_COMM_API -DOCR_TRACE_COMM_WORKER -DOCR_TRACE_COMP_TARGET -DOCR_TRACE_DATABLOCK -DOCR_TRACE_EVENT -DOCR_TRACE_GUID -DOCR_TRACE_INIPARSING -DOCR_TRACE_MACHINE -DOCR_TRACE_MEM_PLATFORM -DOCR_TRACE_MEM_TARGET -DOCR_TRACE_POLICY -DOCR_TRACE_SCHEDULER -DOCR_TRACE_SCHEDULER_HEURISTIC -DOCR_TRACE_SCHEDULER_OBJECT -DOCR_TRACE_STATS -DOCR_TRACE_SYNC -DOCR_TRACE_SYSBOOT -DOCR_TRACE_TASK -DOCR_TRACE_UTIL -DOCR_TRACE_WORKER -DOCR_TRACE_WORKPILE

INCLUDES= -I . -I ${OCR_ROOT}/ocr/inc -I ${OCR_ROOT}/ocr/src -I ${OCR_ROOT}/src/inc

fib: fib.c
	gcc ${INCLUDES} -g -Wall -DOCR_TYPE_H=${OCR_TYPE}.h ${LOTSADEFS} -Werror -fpic -O2 -MMD -c $^ -o $@
