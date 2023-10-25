set ns [new Simulator]
set nf [open sensor.nam w]
$ns namtrace-all $nf
set winFile [open winFile.tr w]
set tr [open sensor.tr w]
$ns trace-all $tr

$ns color 1 Blue
$ns color 2 Red

proc finish {} {
	global ns nf tr 
	$ns flush-trace
	close $nf
	close $tr
	exec nam sensor.nam &
	exit 0
}


for {set i 0} {$i < 6} {incr i} {
	set n($i) [$ns node]
}

$n(1) color red
$n(1) shape box

$ns duplex-link $n(0) $n(2) 2Mb 10ms DropTail
$ns duplex-link $n(1) $n(2) 2Mb 10ms DropTail

$ns simplex-link $n(2) $n(3) 0.3Mb 100ms DropTail
$ns simplex-link $n(3) $n(2) 0.3Mb 100ms DropTail

set lan [ $ns newLan "$n(3) $n(4) $n(5)" 0.5Mb 40ms LL Queue/DropTail MAC/CSMA/CD channel] 

set tcp [new Agent/TCP]
# $tcp set class_ 1 
$tcp set fid_ 1
$tcp set window_ 8000
$tcp set packetSize_ 552
$ns attach-agent $n(0) $tcp
set sink [new Agent/TCPSink]

$ns attach-agent $n(4) $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp 
$ftp set type_ FTP
$ns at 1.0 "$ftp start"
$ns at 124.0 "$ftp stop"


proc plotWindow {tcpSource file} {
	global ns

	set time 0.1
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	set wnd [$tcpSource set window_]

	puts $file "$now $cwnd"
	$ns at [expr $now + $time ] "plotWindow $tcpSource $file"

}
$ns at 0.1 "plotWindow $tcp $winFile"
$ns at 5 "$ns trace-annotate \"Packet Drop\""
$ns at 125.0 finish
$ns run

