!==============================================================
!
! SAMPLE SOURCE CODE - SUBJECT TO THE TERMS OF SAMPLE CODE LICENSE AGREEMENT,
! http://software.intel.com/en-us/articles/intel-sample-source-code-license-agreement/
!
! Copyright 2016 Intel Corporation
!
! THIS FILE IS PROVIDED "AS IS" WITH NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING BUT
! NOT LIMITED TO ANY IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
! PURPOSE, NON-INFRINGEMENT OF INTELLECTUAL PROPERTY RIGHTS.
!
! =============================================================
!
! Part of the Coarray Tutorial. For information, please read
! Tutorial: Using Fortran Coarrays
! Getting Started Tutorials document
program mcpi
! This program demonstrates using a sequential method to implement the classic
! method of computing the mathematical value pi using a Monte Carlo technique.
! A good explanation of this method can be found at:
! http://www.mathcs.emory.edu/~cheung/Courses/170/Syllabus/07/compute-pi.html
!
!
! Compiler options:  None
implicit none
! Declare kind values for large integers, single and double precision
integer, parameter :: K_BIGINT = selected_int_kind(15)
integer, parameter :: K_DOUBLE = selected_real_kind(15,300)
! Number of trials per image. The bigger this is, the better the result
integer(K_BIGINT), parameter :: num_trials = 600000000_K_BIGINT
! Actual value of PI to 18 digits for comparison
real(K_DOUBLE), parameter :: actual_pi = 3.141592653589793238_K_DOUBLE
! Local variables
integer(K_BIGINT) :: total
real(K_DOUBLE) :: x,y
real(K_DOUBLE) :: computed_pi
integer :: i
integer(K_BIGINT) :: bigi
integer(K_BIGINT) :: clock_start,clock_end,clock_rate
print '(A,I0,A)', "Computing pi using ",num_trials," trials sequentially"
! Start timing
call SYSTEM_CLOCK(clock_start)

! Set the initial random number seed to an unpredictable value. The Fortran 2015 
! standard specifies a new RANDOM_INIT intrinsic subroutine that does this, but 
! Intel Fortran doesn't yet support it.
!
! What we do here is first call RANDOM_SEED with no arguments. The standard doesn't
! specify that behavior, but Intel Fortran sets the seed to a value based on the
! system clock. 
call RANDOM_SEED() ! Initialize based on time
! Initialize our total
total = 0_K_BIGINT
! Run the trials. Get a random X and Y and see if the position
! is within a circle of radius 1. If it is, add one to the subtotal
do bigi=1_K_BIGINT,num_trials
    call RANDOM_NUMBER(x)
    call RANDOM_NUMBER(y)
    if ((x*x)+(y*y) <= 1.0_K_DOUBLE) total = total + 1_K_BIGINT
end do
! total/num_trials is an approximation of pi/4
computed_pi = 4.0_K_DOUBLE*(REAL(total,K_DOUBLE)/REAL(num_trials,K_DOUBLE))
print '(A,G0.8,A,G0.3)', "Computed value of pi is ", computed_pi, &
    ", Relative Error: ",ABS((computed_pi-actual_pi)/actual_pi)
! Show elapsed time
call SYSTEM_CLOCK(clock_end,clock_rate)
print '(A,G0.3,A)', "Elapsed time is ", &
    REAL(clock_end-clock_start)/REAL(clock_rate)," seconds"
end program mcpi