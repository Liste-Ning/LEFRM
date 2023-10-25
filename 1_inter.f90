program inter
  implicit none
  include '/usr/include/netcdf.inc'!¶ÁncÎÄ¼þ

  integer*4  ncid, status, year   !4¸ö×Ö½Ú
  integer :: t,i,j,m,n,b,c
  real, dimension(:), allocatable :: lat,lon,nlat,mlon  !Ò»Î¬Êý×é
  real, dimension(:,:,:), allocatable :: data,data_inter   !ÈýÎ¬Êý×é
  real, dimension(:,:,:), allocatable :: sst,sst_inter,nsst,hadsst,hadsst_inter  

  integer      :: tempid, latDimID, lonDimID, frTimeDimID, &
                  latVarID, lonVarID, frTimeVarID, ALTVarID

  integer*4   :: start(10)
  integer*4   :: count(10)
  integer     :: dimid, xtype
  integer     :: ndim, natts, len
  integer     :: dimids(10)
  character(len = 31) :: dummy
  character(4) :: txti

  character(90) :: filename  = '/wind1/home/test/HadCRUT.5.0.1.0.analysis.anomalies.ensemble_mean.nc'  
!   character(90) :: filename  = '/wind1/home/test/Land_and_Ocean_LatLong1.nc'  
!   character(90) :: filename  = '/wind1/home/test/gistemp1200_GHCNv4_ERSSTv5.nc'  
!   character(90) :: filename  = '/wind1/home/test/NOAAGlobalTemp_v5.0.0_gridded_s188001_e202212_c20230108T133308.nc'  

 allocate(data(72,36,2076),data_inter(360,180,2076))
  status = nf_open(filename,nf_nowrite,ncid)  !open existing netCDF dataset

  !===========================================================
   write(*,*) "read data"
   status = nf_inq_varid (ncid, "tas_mean", tempid) !get variable IDs
   status = nf_inq_var(ncid,tempid,dummy,xtype,ndim,dimids,natts) !get variable names, types, shapes
   do j = 1,ndim
   status = nf_inq_dim(ncid,dimids(j),dummy,len) !get dimension names, lengths
        if ( status /= nf_noerr ) write (*,*) nf_strerror(status)
   start(j) = 1 ; count(j) = len
   enddo    !·µ»Ø´íÎóÐÅÏ¢£¿
   status = nf_get_vara_real(ncid,tempid,start,count,data)
   write(*,*) minval(data)
   write(*,*) maxval(data)

! ===========================================================
do t = 1,2076
  do i = 1,36
    do j = 1,72
      do m = 0,4
        do n = 0,4
          data_inter(j+n+(j-1)*4,i+m+(i-1)*4,t) = data(j,i,t)
        end do
      end do
    end do
  end do
end do

!============================================================================
! Create the file
status = nf_create("/wind1/home/test/inter_HadCRUT5.nc", nf_clobber, ncid)

! Define the dimensions
status = nf_def_dim(ncid, "time",  2076,  frTimeDimID)
status = nf_def_dim(ncid, "lat",   180,   latDimID)
status = nf_def_dim(ncid, "lon",   360,  lonDimID)

!define the coordinate variables
! Create variables and attributes
status = nf_def_var(ncid, "inter_data", nf_float, 3, (/ lonDimID, latDimID, frTimeDimID /), ALTVarID)
! status = nf_put_att(ncid, ALTVarID, "long_name", nf_string,  "monthly active layer depth")
! status = nf_put_att(ncid, ALTVarID, "units", nf_string,      "m")

! Leave define mode
status = nf_enddef(ncid)

! Write the dimension variables
status = nf_put_vara_real(ncid, ALTVarID, (/1,1,1/), (/360,180,2076/), data_inter)
status = nf_close(ncid)

end program