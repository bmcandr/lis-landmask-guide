! Open a sequential binary LIS output file with valid forcing points,
! and convert to a direct-access binary mask file for use within LDT.
!
! David.Mocko@nasa.gov
! Brendan.B.McAndrew@nasa.gov
      program make_mask

      implicit none
! filename = filename arg, cols = read in Xpts, rows = read in Ypts
      character(len=250)            :: infile, cols, rows
      character(len=250), parameter :: outfile = "forcing_mask.1gd4r"
! argc = arg count, n = arg iterator 
      integer :: argc, n
! ipts = rows, jpts = columns
      integer :: i, j, ipts, jpts
! arrays to hold the input/output data
      real, allocatable :: in_data(:,:), out_data(:,:)

      argc = iargc()

      if (argc .lt. 3 .OR. argc .gt. 3) then
         print *, "ERR: incorrect number of arguments"
         print *, "Usage:                            "
         print *, "     ./<exec> [FILE] [XPTS] [YPTS]"
         stop
      endif

      do n = 1, argc
         if (n .eq. 1) then
            ! read filename 
            call getarg(n, infile)
         elseif (n .eq. 2) then
            ! read cols (as char)
            call getarg(n, cols)
            ! convert cols to jpts (integer)
            read(cols,*) jpts
         elseif (n .eq. 3) then
            ! read rows (as char)
            call getarg(n, rows)
            ! convert rows to ipts (integer)
            read(rows,*) ipts
         else
            ! do nothing
         endif
      enddo
      
      ! allocate arrays with read-in dimensions
      allocate(in_data(ipts, jpts))
      allocate(out_data(ipts, jpts))

      ! read the input file
      open(98,file=trim(infile),   &
              convert="big_endian",                    &
              form="unformatted",status="old")
      read(98) in_data
      close(98)

      do j = 1,jpts
         do i = 1,ipts
            if (in_data(i,j).gt.-1.0) then
! Set all points with valid forcing to "1.0"
               out_data(i,j) = 1.0
            else
! Set all points without valid forcing to "0.0"
               out_data(i,j) = 0.0
            endif
         enddo
      enddo
      
      ! write data to output file
      open(99,file=trim(outfile),                                   &
              access='stream',convert="big_endian",                        &
              form="unformatted",status="unknown")
      write(99) out_data
      close(99)

      stop
      end program make_mask

