begin
    a = asciiread("factors.txt", (/168,10/), "float") ;1850-2017
    b = asciiread("coefficient_intercept_CESM2.txt", (/11,1/), "float");1880-2017    
    c = asciiread("coefficient_intercept_all_forcing.txt", (/11,1/), "float");1880-2017
    d = asciiread("stand_coefficient_std_CESM2_ALL_1850_1880_Obs1.96.txt", (/10,10/), "float")
   
    CESM2 = asciiread("CESM2.txt", (/168,1/), "float") ;1850-2017
    ALL   = asciiread("all_forcing.txt", (/168,1/), "float") ;1850-2017

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    CESM2_forcing_1850  = new((/10,168/),float)
    CESM2_forcing_1880  = new((/10,168/),float)
    ALL_forcing_1850   = new((/10,168/),float)
    ALL_forcing_1880   = new((/10,168/),float)

    do i = 0,9
        CESM2_forcing_1850(i,:) = a(:,i)*b(i,0)
        CESM2_forcing_1880(i,:) = a(:,i)*b(i,1)        
        ALL_forcing_1850(i,:)   = a(:,i)*c(i,0)
        ALL_forcing_1880(i,:)   = a(:,i)*c(i,1)
    end do

    CESM2_1850 = new((/168/), "float")
    CESM2_1880 = new((/168/), "float")
    ALL_1850   = new((/168/), "float")
    ALL_1880   = new((/168/), "float")

    do i = 0,167
        CESM2_1850(i) = sum(CESM2_forcing_1850(:,i)) + b(10,0)  
        CESM2_1880(i) = sum(CESM2_forcing_1880(:,i)) + b(10,1)  
        ALL_1850(i)   = sum(ALL_forcing_1850(:,i))   + c(10,0)  
        ALL_1880(i)   = sum(ALL_forcing_1880(:,i))   + c(10,1) 
    end do  

    time         = ispan(1850, 2017, 1)
    time@units   = "year since 1850"
    time!0       = "time"
    time&time    = time    
   
    CESM2_plot_1850      = new((/2,168/), float)
    CESM2_plot_1850(0,:) = CESM2
    CESM2_plot_1850(1,:) = CESM2_1850

    CESM2_plot_1880      = new((/2,168/), float)
    CESM2_plot_1880(0,:) = CESM2
    CESM2_plot_1880(1,:) = CESM2_1880

    ALL_plot_1850        = new((/2,168/), float)
    ALL_plot_1850(0,:)   = ALL
    ALL_plot_1850(1,:)   = ALL_1850

    ALL_plot_1880        = new((/2,168/), float)
    ALL_plot_1880(0,:)   = ALL
    ALL_plot_1880(1,:)   = ALL_1880
    ; printMinMax(ALL_plot_1850, 0)

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    x = ispan(1,60,1)

    coef = new((/50,2/),float)
    do i = 1,10
        do j = 1,5
            coef(5*i+j-6,0) = d(i-1,2*j-2)
            coef(5*i+j-6,1) = d(i-1,2*j-1)            
        end do
    end do

    std_coef = new((/60,2/),float)
    do i = 1,10
        do j = 1,5
            std_coef(6*i+j-7,:) = coef(5*i+j-6,:)
        end do
    end do
    ; print(std_coef)

;============================================================
    type         = "eps"
    pltName      = "Fig.4"
    wks          = gsn_open_wks(type,pltName)

    res                               = True
    res@gsnDraw                       = False                   ; don't draw
    res@gsnFrame                      = False                   ; don't advance frame

    res@vpHeightF                     = 0.4
    res@vpWidthF                      = 0.6
    res@xyDashPattern                 = 0
    res@xyMarkLineMode                = "Lines"
    res@xyLineThicknesses             = (/3.7,3.7/)
    ; res@tiYAxisString                 = "Temperature anomaly/~S~o~N~C"

    res@trXMinF                       = 1850
    res@trXMaxF                       = 2017
    res@tiMainFontHeightF             = 0.035

    res@gsnYRefLine                   = 0
    res@gsnXRefLineColor              = "black"  
    res@gsnYRefLineThicknesses        = 2.  
    res@gsnYRefLineDashPattern        = 16

    res@tiXAxisFontHeightF            = 0.02
    res@tiYAxisFontHeightF            = 0.02
    res@tmXBLabelFontHeightF          = 0.02
    res@tmYLLabelFontHeightF          = 0.02

    res@lgPerimOn                     = False
    res@tmXBMajorOutwardLengthF       = False
    res@tmYLMajorOutwardLengthF       = False
    res@tmXBMinorOn                   = False
    res@tmYLMinorOn                   = False
    res@tmYROn                        = False
    res@tmXTOn                        = False

    plots                             = new(5,graphic)
    
    res@trYMinF                       = -0.8
    res@trYMaxF                       = 1.2
    res@tmYLMode                      = "Explicit"
    res@tmYLValues                    = (/1.2,0.8,0.4,0,-0.4,-0.8/)
    res@tmYLLabels                    = (/"1.2","0.8","0.4","0.0","-0.4","-0.8"/)
    res@xyLineColors                  = (/"black","royalblue2"/)
    plots(0)                          = gsn_csm_xy(wks, time, CESM2_plot_1850, res)

    res@xyLineColors                  = (/"black","tan2"/)    
    plots(1)                          = gsn_csm_xy(wks, time, ALL_plot_1850, res)

    res@xyLineColors                  = (/"black","mediumorchid3"/)    
    plots(2)                          = gsn_csm_xy(wks, time(30:), CESM2_plot_1880(:,30:), res)
    
    res@xyLineColors                  = (/"black","darkgreen"/)    
    plots(3)                          = gsn_csm_xy(wks, time(30:), ALL_plot_1880(:,30:), res)

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    res@vpHeightF                     = 0.4
    res@vpWidthF                      = 1.32

    res@trYMinF                       = -1
    res@trYMaxF                       = 1.5  
    res@trXMinF                       = 0
    res@trXMaxF                       = 60

    res@xyLineThicknesses             := 2
    res@xyLineColors                  := "white"

    res@tmYLMode                      = "Manual"
    res@tmYLTickSpacingF              = 0.5

    res@tmXBMode                      = "Explicit"
    res@tmXBValues                    = (/3,9,15,21,27,33,39,45,51,57/)
    res@tmXBLabels                    = (/"Natural","CO2","OtherGHG","Aerosol","SOzone",\
                                          "TOzone","WaterVapour","Landuse","SnowBC","Contrails"/)
    res@tmXBLabelAngleF               = 15
    ; res@tmXBLabelJust                 = "CenterRight"

    res@gsnYRefLine                   = 0
    res@gsnXRefLineColor              = "black"  
    res@gsnYRefLineThicknesses        = 1.  
    ; res@gsnYRefLineDashPattern        = 16    

    res@tmYLMajorLengthF              = 0.015
    res@tmXBMajorLengthF              = 0.015

    plots(4) = gsn_csm_xy(wks, x, std_coef(:,0), res)                        ; draw y plot

    polyres                           = True
    polyres@gsMarkerIndex             = 1.0
    polyres@gsMarkerSizeF             = 0.02
    polyres@gsMarkerThicknessF        = 1.0

    polyres@gsLineDashPattern         = 0
    polyres@gsLineThicknessF          = 2.8
    polyres@PreDraw                   = True

    lineres                           = True        ; polyline mods desired
    lineres@gsLineThicknessF          = 2.4         ; line thicker
    lineres@gsLineDashPattern         = 0   ; dash pattern

    centers   = new((/50/),graphic)
    error_bar = new((/50/),graphic)
    dum       = new((/100/),graphic)

    color     = (/"royalblue2","tan2","mediumorchid3","darkgreen","red3",\
                  "royalblue2","tan2","mediumorchid3","darkgreen","red3",\
                  "royalblue2","tan2","mediumorchid3","darkgreen","red3",\
                  "royalblue2","tan2","mediumorchid3","darkgreen","red3",\
                  "royalblue2","tan2","mediumorchid3","darkgreen","red3",\
                  "royalblue2","tan2","mediumorchid3","darkgreen","red3",\
                  "royalblue2","tan2","mediumorchid3","darkgreen","red3",\
                  "royalblue2","tan2","mediumorchid3","darkgreen","red3",\
                  "royalblue2","tan2","mediumorchid3","darkgreen","red3",\
                  "royalblue2","tan2","mediumorchid3","darkgreen","red3"/)

    do i = 1,10
        do j = 1,5
            polyres@gsMarkerColor             = color(5*i+j-6) 
            polyres@gsLineColor               = color(5*i+j-6) 
            lineres@gsLineColor               = color(5*i+j-6)  ; line color

            centers(5*i+j-6)   = gsn_add_polymarker(wks, plots(4), 6*i+j-6, std_coef(6*i+j-7,0), polyres)
            error_bar(5*i+j-6) = gsn_add_polyline(wks,plots(4),(/6*i+j-6,6*i+j-6/),(/std_coef(6*i+j-7,0)+std_coef(6*i+j-7,1),std_coef(6*i+j-7,0)-std_coef(6*i+j-7,1)/),polyres)

            xx     = (/0.665+6*i+j-7,1.335+6*i+j-7/)
            yy     = (/std_coef(6*i+j-7,0)+std_coef(6*i+j-7,1),std_coef(6*i+j-7,0)+std_coef(6*i+j-7,1)/)
            dum(5*i+j-6) = gsn_add_polyline(wks, plots(4), xx, yy, lineres)

            yy     = (/std_coef(6*i+j-7,0)-std_coef(6*i+j-7,1),std_coef(6*i+j-7,0)-std_coef(6*i+j-7,1)/)
            dum(5*i+j+44) = gsn_add_polyline(wks, plots(4), xx, yy, lineres)

            delete(xx)
            delete(yy)
        end do
    end do

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    txtres                 = True
    txtres@txFontHeightF   = 0.013        ; font height
    txtres@txJust          = "CenterLeft" ; align text to left

    pgres                  = True
    pgres@gsLineThicknessF = 3.7

    gsres                  = True             
    gsres@gsMarkerIndex    = 1.0
    gsres@gsMarkerSizeF    = 0.025

    pgres@gsLineColor     = "black"
    gsn_polyline_ndc(wks,(/0.12,0.16/),(/0.88,0.88/),pgres)
    gsn_text_ndc(wks,"LENS2 since 1850",0.18,0.88,txtres)

    gsn_polyline_ndc(wks,(/0.12,0.16/),(/0.56,0.56/),pgres)
    gsn_text_ndc(wks,"LENS2 since 1880",0.18,0.56,txtres)

    gsn_polyline_ndc(wks,(/0.62,0.66/),(/0.88,0.88/),pgres)
    gsn_text_ndc(wks,"MME since 1850",0.68,0.88,txtres)

    gsn_polyline_ndc(wks,(/0.62,0.66/),(/0.56,0.56/),pgres)
    gsn_text_ndc(wks,"MME since 1880",0.68,0.56,txtres)

    pgres@gsLineColor     = "royalblue2"
    gsn_polyline_ndc(wks,(/0.12,0.16/),(/0.94,0.94/),pgres)
    gsn_text_ndc(wks,"External forcing of LENS2",0.18,0.94,txtres)
    gsn_text_ndc(wks,"since 1850 [97.4%]",0.18,0.915,txtres)    

    pgres@gsLineColor     = "mediumorchid3"
    gsn_polyline_ndc(wks,(/0.12,0.16/),(/0.62,0.62/),pgres)
    gsn_text_ndc(wks,"External forcing of LENS2",0.18,0.62,txtres)
    gsn_text_ndc(wks,"since 1880 [97.8%]",0.18,0.595,txtres)

    pgres@gsLineColor     = "tan2"
    gsn_polyline_ndc(wks,(/0.62,0.66/),(/0.94,0.94/),pgres)
    gsn_text_ndc(wks,"External forcing of MME",0.68,0.94,txtres)
    gsn_text_ndc(wks,"since 1850 [97.7%]",0.68,0.915,txtres)   

    pgres@gsLineColor     = "darkgreen"
    gsn_polyline_ndc(wks,(/0.62,0.66/),(/0.62,0.62/),pgres)
    gsn_text_ndc(wks,"External forcing of MME",0.68,0.62,txtres)
    gsn_text_ndc(wks,"since 1880 [98.1%]",0.68,0.595,txtres)

    ;+++++++++++++++++++++++++++++++++++++++++++++++
    gsres@gsMarkerColor = "royalblue2"
    gsn_polymarker_ndc(wks, 0.58, 0.315, gsres)
    gsn_text_ndc(wks,"LENS2 since 1850",0.6,0.315,txtres)

    gsres@gsMarkerColor = "mediumorchid3"
    gsn_polymarker_ndc(wks, 0.58, 0.285, gsres)   
    gsn_text_ndc(wks,"LENS2 since 1880",0.6,0.285,txtres)

    gsres@gsMarkerColor = "tan2"
    gsn_polymarker_ndc(wks, 0.78, 0.315, gsres)
    gsn_text_ndc(wks,"MME since 1850",0.8,0.315,txtres)

    gsres@gsMarkerColor = "darkgreen"
    gsn_polymarker_ndc(wks, 0.78, 0.285, gsres)   
    gsn_text_ndc(wks,"MME since 1880",0.8,0.285,txtres)

    gsres@gsMarkerColor = "red3"
    gsn_polymarker_ndc(wks, 0.58, 0.255, gsres)   
    gsn_text_ndc(wks,"Obs",0.6,0.255,txtres)    

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    ; drawNDCGrid(wks)
    resPanel                                             = True
    resPanel@gsnPanelFigureStrings                       = (/"(a)","(b)","(c)","(d)","(e)"/)
    resPanel@gsnPanelFigureStringsFontHeightF            = 0.016
    resPanel@amJust                                      = "TopLeft"   
    resPanel@gsnPanelFigureStringsPerimOn                = False          
    resPanel@gsnPanelFigureStringsBackgroundFillColor    = -1                
   
    resPanel@gsnPanelRowSpec                             = True 
    resPanel@gsnPanelDebug                               = True

    resPanel@gsnPanelXF                                  = (/0.065,0.565,0.065,0.565,0.065/)   
    resPanel@gsnPanelYF                                  = (/0.98,0.98,0.66,0.66,0.34/) 

    gsn_panel(wks,plots,(/2,2,1/),resPanel)
    ; frame(wks)

    delete (wks)           
    system("convert -geometry 3000x3000 -density 600x600 -trim " + pltName + ".eps " + pltName + ".png")   
    system("rm " + pltName + ".eps -f")
end