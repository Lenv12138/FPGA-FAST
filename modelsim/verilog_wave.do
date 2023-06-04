onerror {resume}
quietly virtual signal -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo { (concat_noflatten) (context /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo )&{o06 , o05 , o04 , o03 , o02 , o01 , o00 }} line_1_7patch
quietly virtual signal -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo { (concat_noflatten) (context /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo )&{o16 , o15 , o14 , o13 , o12 , o11 , o10 }} line_2_7patch
quietly virtual signal -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo { (concat_noflatten) (context /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo )&{o26 , o25 , o24 , o23 , o22 , o21 , o20 }} line_3_7patch
quietly virtual signal -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo { (concat_noflatten) (context /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo )&{o36 , o35 , o34 , o33 , o32 , o31 , o30 }} line_4_7patch
quietly virtual signal -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo { (concat_noflatten) (context /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo )&{o46 , o45 , o44 , o43 , o42 , o41 , o40 }} line_5_7patch
quietly virtual signal -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo { (concat_noflatten) (context /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo )&{o50 , o51 , o52 , o53 , o54 , o55 , o56 }} line_6_7patch
quietly virtual signal -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo { (concat_noflatten) (context /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo )&{o66 , o65 , o64 , o63 , o62 , o61 , o60 }} line_7_7patch
quietly virtual signal -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder { (concat_noflatten) (context /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder )&{in15 , in14 , in13 , in12 , in11 , in10 , in9 , in8 , in7 , in6 , in5 , in4 , in3 , in2 , in1 , in0 }} ring_pixels
quietly virtual signal -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder { (concat_noflatten) (context /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder )&{in0 , in1 , in2 , in3 , in4 , in5 , in6 , in7 , in8 , in9 , in10 , in11 , in12 , in13 , in14 , in15 }} ring_pixel
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder -env /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder { (concat_noflatten)(concat_flatten)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o0b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o1b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o2b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o3b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o4b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o5b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o6b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o7b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o8b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o9b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o10b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o11b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o12b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o13b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o14b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o15b }} output_diff_brightpixel
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder -env /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder { (concat_noflatten)(concat_flatten)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o0d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o1d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o2d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o3d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o4d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o5d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o6d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o7d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o8d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o9d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o10d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o11d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o12d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o13d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o14d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/o15d }} output_diff_darkpixel
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder -env /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder { (concat_noflatten)(concat_flatten)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr0, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr1, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr2, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr3, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr4, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr5, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr6, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr7, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr8, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr9, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr10, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr11, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr12, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr13, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr14, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr15 }} first_clk_cmr
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder -env /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder { (concat_noflatten)(concat_flatten)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc0, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc1, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc2, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc3, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc4, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc5, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc6, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc7, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc8, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc9, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc10, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc11, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc12, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc13, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc14, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc15 }} first_clk_rmc
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder -env /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder { (concat_noflatten)(concat_flatten)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr0t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr1t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr2t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr3t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr4t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr5t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr6t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr7t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr8t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr9t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr10t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr11t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr12t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr13t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr14t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/cmr15t }} 2rd_clk_cmr_t
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder -env /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder { (concat_noflatten)(concat_flatten)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc0t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc1t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc2t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc3t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc4t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc5t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc6t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc7t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc8t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc9t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc10t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc11t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc12t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc13t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc14t, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/rmc15t }} 2rd_clk_rmc_t
quietly virtual signal -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score { (concat_noflatten) (context /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score )&{i0b , i1b , i2b , i3b , i4b , i5b , i6b , i7b , i8b , i9b , i10b , i11b , i12b , i13b , i14b , i15b }} diff_rmc_t
quietly virtual signal -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score { (concat_noflatten) (context /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score )&{i0d , i1d , i2d , i3d , i4d , i5d , i6d , i7d , i8d , i9d , i10d , i11d , i12d , i13d , i14d , i15d }} diff_cmr_t
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score -env /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score { (concat_noflatten)(concat_flatten)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/s0b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/s1b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/s2b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/s3b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/s4b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/s5b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/s6b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/s7b }} 1st_clk_compute_ixb_ixd
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score -env /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score { (concat_noflatten)(concat_flatten)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/ss0b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/ss1b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/ss2b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/ss3b }} 2nd_clk_compute
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score -env /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score { (concat_noflatten)(concat_flatten)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/sss0b, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/sss1b }} 3rd_clk_compute_ixb
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score -env /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score { (concat_noflatten)(concat_flatten)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/s0d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/s1d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/s2d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/s3d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/s4d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/s5d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/s6d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/s7d }} 1st_clk_compute_ixd
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score -env /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score { (concat_noflatten)(concat_flatten)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/ss0d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/ss1d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/ss2d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/ss3d }} 2nd_clk_compute_ixd
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score -env /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score { (concat_noflatten)(concat_flatten)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/sss0d, /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/sss1d }} 3rd_clk_compute_ixd
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo -env /tb_FAST_NMS { (concat_noflatten)(concat_flatten)(concat_reverse)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/ram_0 }} ram0
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo -env /tb_FAST_NMS { (concat_noflatten)(concat_flatten)(concat_reverse)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/ram_1 }} ram1
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo -env /tb_FAST_NMS { (concat_noflatten)(concat_flatten)(concat_reverse)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/ram_2 }} ram2
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo -env /tb_FAST_NMS { (concat_noflatten)(concat_flatten)(concat_reverse)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/ram_3 }} ram3
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo -env /tb_FAST_NMS { (concat_noflatten)(concat_flatten)(concat_reverse)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/ram_4 }} ram4
quietly virtual function -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo -env /tb_FAST_NMS { (concat_noflatten)(concat_flatten)(concat_reverse)&{/tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/ram_5 }} ram5
quietly virtual signal -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo { /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/xy_coord_tmp[19:10]} xy_coord_tmp_x_coord
quietly virtual signal -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo { /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/xy_coord_tmp[9:0]} xy_coord_tmp_y_coord
quietly virtual signal -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo { /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/xy_coord[19:10]} xy_coord_x_coord
quietly virtual signal -install /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo { /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/xy_coord[9:0]} xy_coord_y_coord
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/data_in
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/clk
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/rst
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/ce
add wave -noupdate -expand -group -radix unsigned fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/x_coord
add wave -noupdate -expand -group -radix unsigned fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/y_coord
add wave -noupdate -expand -group -radix unsigned fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/xy_coord_x_coord
add wave -noupdate -expand -group -radix unsigned fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/xy_coord_y_coord
add wave -noupdate -expand -group -radix unsigned fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/xy_coord
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/line_1_7patch
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/line_2_7patch
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/line_3_7patch
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/line_4_7patch
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/line_5_7patch
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/line_6_7patch
add wave -noupdate -expand -group fast_fifo -expand /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/line_7_7patch
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/patch_7x7_vld
add wave -noupdate -expand -group fast_fifo -radix unsigned /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/address_read
add wave -noupdate -expand -group fast_fifo -radix unsigned /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/address_write
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/data_out_0
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/data_out_1
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/data_out_2
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/data_out_3
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/data_out_4
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/data_out_5
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/ram0
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/ram1
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/ram2
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/ram3
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/ram4
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/ram5
add wave -noupdate -expand -group fast_fifo -radix unsigned /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/cnt_row
add wave -noupdate -expand -group fast_fifo -radix unsigned /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/cnt_row_d
add wave -noupdate -expand -group fast_fifo -radix unsigned /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/xy_coord_tmp_x_coord
add wave -noupdate -expand -group fast_fifo -radix unsigned /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/xy_coord_tmp_y_coord
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/xy_coord_tmp
add wave -noupdate -expand -group fast_fifo /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_fifo/EOL
add wave -noupdate -group fast_diff_center_ring /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/THRESHOLD
add wave -noupdate -group fast_diff_center_ring /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/ring_pixel
add wave -noupdate -group fast_diff_center_ring /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/center
add wave -noupdate -group fast_diff_center_ring /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/bright
add wave -noupdate -group fast_diff_center_ring /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/dark
add wave -noupdate -group fast_diff_center_ring /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/first_clk_cmr
add wave -noupdate -group fast_diff_center_ring /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/first_clk_rmc
add wave -noupdate -group fast_diff_center_ring /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/2rd_clk_cmr_t
add wave -noupdate -group fast_diff_center_ring /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/2rd_clk_rmc_t
add wave -noupdate -group fast_diff_center_ring /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/output_diff_brightpixel
add wave -noupdate -group fast_diff_center_ring /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_thresholder/output_diff_darkpixel
add wave -noupdate -group check_contiguity /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_contig_processor/clk
add wave -noupdate -group check_contiguity /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_contig_processor/rst
add wave -noupdate -group check_contiguity /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_contig_processor/ce
add wave -noupdate -group check_contiguity /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_contig_processor/input_d
add wave -noupdate -group check_contiguity /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_contig_processor/input_b
add wave -noupdate -group check_contiguity /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_contig_processor/contig
add wave -noupdate -group check_contiguity /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_contig_processor/contig_d
add wave -noupdate -group check_contiguity /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_contig_processor/contig_d1
add wave -noupdate -group check_contiguity /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_contig_processor/contig_d2
add wave -noupdate -group check_contiguity /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_contig_processor/contig_d3
add wave -noupdate -group check_contiguity /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_contig_processor/contig_b
add wave -noupdate -group compute_score /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/clk
add wave -noupdate -group compute_score /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/rst
add wave -noupdate -group compute_score /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/ce
add wave -noupdate -group compute_score /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/diff_rmc_t
add wave -noupdate -group compute_score /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/diff_cmr_t
add wave -noupdate -group compute_score /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/score
add wave -noupdate -group compute_score /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/1st_clk_compute_ixb_ixd
add wave -noupdate -group compute_score /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/2nd_clk_compute
add wave -noupdate -group compute_score /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/3rd_clk_compute_ixb
add wave -noupdate -group compute_score /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/1st_clk_compute_ixd
add wave -noupdate -group compute_score /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/2nd_clk_compute_ixd
add wave -noupdate -group compute_score /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/3rd_clk_compute_ixd
add wave -noupdate -group compute_score /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/sum_all_b
add wave -noupdate -group compute_score /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/u_fast_score/sum_all_d
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {845423 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 201
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {2059163 ps}
