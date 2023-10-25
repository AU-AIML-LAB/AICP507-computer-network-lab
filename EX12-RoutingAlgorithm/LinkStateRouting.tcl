

set ns [new Simulator]
set nf [open dv.nam w]
$ns namtrace-all $nf
set tr [open dv.tr w ] 
$ns trace-all $tr

proc finish {} {
	global ns nf tr 
	$ns flush-trace
	close $nf
	close $tr
	exec nam dv.nam &
	exit 0
}

for {set i 0} {$i < 12} {incr i} {
	set n($i) [$ns node]
}
for {set i 0} {$i < 8} {incr i} {
	$ns duplex-link $n($i) $n([expr ($i+1) ]) 10Mb 10ms DropTail
}

$ns duplex-link $n(0) $n(8) 10Mb 10ms DropTail
$ns duplex-link $n(1) $n(10) 10Mb 10ms DropTail
$ns duplex-link $n(0) $n(9) 10Mb 10ms DropTail
$ns duplex-link $n(9) $n(11) 10Mb 10ms DropTail
$ns duplex-link $n(10) $n(11) 10Mb 10ms DropTail
$ns duplex-link $n(11) $n(5) 10Mb 10ms DropTail

set udp [new Agent/UDP]
$ns attach-agent $n(0) $udp

set udp1 [new Agent/UDP]
$ns attach-agent $n(1) $udp1


set null [new Agent/Null]
$ns attach-agent $n(5) $null

set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 500
$cbr set interval_ 0.005
$cbr attach-agent $udp


set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1

set null [new Agent/Null]
$ns attach-agent $n(5) $null

$ns connect $udp $null
$ns connect $udp1 $null


$ns rtproto LS
$ns rtmodel-at 10.0 down $n(11) $n(5)
$ns rtmodel-at 15.0 down $n(7) $n(6)
$ns rtmodel-at 30.0 up $n(11) $n(5)
$ns rtmodel-at 20.0 up $n(7) $n(6)

$udp set fid_ 1
$udp1 set fid_ 2

$ns color 1 Red
$ns color 2 Green

$ns at 1.0 "$cbr start"
$ns at 2.0 "$cbr1 start"

$ns at 45.0 finish
$ns run

