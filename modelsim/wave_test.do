onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/Data00
add wave -noupdate /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/Data01
add wave -noupdate /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/Data10
add wave -noupdate /tb_FAST_NMS/u_FAST_with_NMS/u_fast_main_top/Data11
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
WaveRestoreZoom {498043796 ps} {500102959 ps}
