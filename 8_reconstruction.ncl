begin
    a = asciiread("coefficient_intercept.txt", (/11,1/), "float")
    b = asciiread("factors.txt", (/168,10/), "float") ;1850-2017
    c = asciiread("6_data_1850-2022.txt", (/173,6/), "float") ;Imax、Imin、BE、HadCRUT5、NOAA、GISS

    factor  = b
    
    series1 = new((/173,5/), "float")
    series1 = c(:,:4)

    coef   = a(0:9,0)
    inter  = a(10,0)

    ;forcing
    p1 = new((/168,10/), "float")
    do i = 0,167
        do j = 0,9
            p1(i,j) = coef(j)*factor(i,j)
        end do
    end do

    forcing1 = new((/168/), "float")
    do i = 0,167
        forcing1(i) = sum(p1(i,:)) + inter   
    end do   

    ;IV
    re   = dim_avg_n(series1(0:29,:), 0) - dim_avg_n(forcing1(0:29), 0)

    forcing2 = new((/30,5/), "float")
    do i = 0,29
        do j = 0,4
            forcing2(i,j) = forcing1(i) + re(j)  
        end do 
    end do    

    hf = new((/30,5/), "float")
    do i = 0,29
        do j = 0,4
            hf(i,j) = series1(i,j) - forcing2(i,j)   
        end do 
    end do

    series2 = new((/30,5/), "float")
    do i = 0,29
        do j = 0,4
            series2(i,j) = hf(i,j) + forcing1(i) 
        end do 
    end do

    series_avg = new((/173,5/),"float")
    series_avg(:29,:) = series2
    series_avg(30:,:) = series1(30:,:)
    ; print(series_avg)

    series  = [/series_avg(:,0),series_avg(:,1),series_avg(:,2),series_avg(:,3),series_avg(:,4)/] 

    write_table("Obs_LEFRM.txt","w",series,"%9.5f,%9.5f,%9.5f,%9.5f,%9.5f")
           

end