onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /simulacao/clock
add wave -noupdate -color Yellow -itemcolor Yellow -radix binary /simulacao/wren
add wave -noupdate -color Cyan -itemcolor Cyan -radix binary /simulacao/address
add wave -noupdate -color Orange -itemcolor Orange -radix binary /simulacao/data
add wave -noupdate -color Red -itemcolor Red -radix binary /simulacao/hit
add wave -noupdate -color Magenta -itemcolor White -radix binary /simulacao/via1
add wave -noupdate -color Magenta -itemcolor White -radix binary /simulacao/via2
add wave -noupdate -color Yellow -itemcolor Yellow -radix binary /simulacao/write_back_en
add wave -noupdate -color Magenta -itemcolor White -radix binary /simulacao/write_back_data
add wave -noupdate -color Cyan -itemcolor Cyan -radix binary /simulacao/mem_address
add wave -noupdate -color Orange -itemcolor Orange -radix binary /simulacao/mem_data
add wave -noupdate -color Magenta -itemcolor White -radix binary /simulacao/outData
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {38 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {48 ps}
